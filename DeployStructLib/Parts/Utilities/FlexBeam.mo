within DeployStructLib.Parts.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FlexBeam
  "Model of flexible beam"
  import SI = Modelica.SIunits;
  import Inf = Modelica.Constants.inf;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.MaterialProperties.*;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Interfaces;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Visualizers;
  parameter Boolean animation = true "= true, if animation shall be enabled";
  parameter Types.ShapeType shapeType = "box" "Type of shape" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Types.Color color = Modelica.Mechanics.MultiBody.Types.Defaults.RodColor "Color of shape" annotation(Dialog(colorSelector = true, tab = "Animation", group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  //
  parameter SI.Length L "Beam length";
  parameter beamXProperty xprop;
  parameter isotropicMaterialProperty matProp;
  parameter SI.Density rho = matProp.rho "density";
  parameter SI.ModulusOfElasticity E = matProp.E "Elasitic Modulus";
  parameter SI.PoissonNumber nu = if matProp.nu > 0 then matProp.nu else matProp.E/2.0/matProp.G-1.0 "Poisson's ratio";
  parameter SI.ShearModulus G = if matProp.G > 0 then matProp.G else matProp.E / 2 / (1 + matProp.nu) "Shear Modulus";
  parameter SI.Mass mass = if DSLglb.quasiStatic then DSLglb.quasiStaticFactor * rho * xprop.A * L else rho * xprop.A * L "Beam mass";
  parameter Real qsFacR = if DSLglb.quasiStatic then 1 / DSLglb.quasiStaticFactor else 1.0 "Quasi-static factor";
  parameter Real alpha = matProp.alpha "Rayleigh damping  coefficient (mass proportional)";
  parameter Real beta = matProp.beta "Rayleigh damping coefficient (stiffness proportional)";
  //
  Interfaces.Frame_a frame_a "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent = {{-116, -16}, {-84, 16}}, rotation = 0)));
  Interfaces.Frame_b frame_b "Coordinate system fixed to the component with one cut-force and cut-torque" annotation(Placement(transformation(extent = {{84, -16}, {116, 16}}, rotation = 0)));
  //protected
  parameter Boolean steadyState = DSLglb.SteadyState "Initialize to steady state?";
  parameter Boolean useLumpedMassMatrix = false "=true, use a lumped mass matrix formulation else use a consistent mass matrix formulation" annotation(Evaluate=true);
  parameter Boolean useGravity = false "=true, use gravity in the simulation (computational speedup if not used)" annotation(Evaluate=true);
  parameter SI.Position r[3] = {L, 0, 0} "Vector from frame_a to undeformed frame_b resolved in frame_a";
  parameter Real dim2 = DeployStructLib.Properties.BeamXProperties.getDim(xprop, 2);
  parameter Real dim3 = DeployStructLib.Properties.BeamXProperties.getDim(xprop, 3);
  final parameter Types.RotationSequence sequence(min = {1, 1, 1}, max = {3, 3, 3}) = {1, 2, 3} "Angles are returned to rotate frame_a around axes sequence[1], sequence[2] and finally sequence[3] into frame_b" annotation(Evaluate = true);
  // max/min values are related to linear strain assumptions
  SI.Position qf[6](start = {0, 0, 0, 0, 0, 0}, each fixed = not steadyState, each stateSelect = StateSelect.prefer, min = {-Inf, -0.1 * L ^ 2 / dim2, -0.1 * L ^ 2 / dim3, -Inf, -0.1 * L / dim3, -0.1 * L / dim2}, max = {Inf, 0.1 * L ^ 2 / dim2, 0.1 * L ^ 2 / dim3, Inf, 0.1 * L / dim3, 0.1 * L / dim2}, nominal = {L/E/xprop.A, L^3/E/12/xprop.Izz, L^3/E/12/xprop.Iyy, L/G/xprop.J, L^2/E/6/xprop.Iyy, L^2/E/6/xprop.Izz});
  Real dqf[6](start = {0, 0, 0, 0, 0, 0}, each fixed = true, each stateSelect = StateSelect.prefer, nominal = {L/E/xprop.A, L^3/E/12/xprop.Izz, L^3/E/12/xprop.Iyy, L/G/xprop.J, L^2/E/6/xprop.Iyy, L^2/E/6/xprop.Izz});
  Real ddqf[6](start = {0, 0, 0, 0, 0, 0}, each fixed = steadyState);
  SI.Velocity v[3];
  SI.Velocity v0[3];
  SI.Acceleration a[3];
  SI.AngularVelocity w[3];
  SI.AngularAcceleration z[3];
  SI.Force Fb_a[3];
  SI.Torque Tb_a[3];
  Frames.Orientation R_rel "Relative orientation object from frame_a to frame_b";
  Real[3] QeR;
  Real[3] Qet;
  Real[3] QvR;
  Real[3] Qvt;
  Real[6] Qef;
  Real[6] Qvf;
  Real[6] Qeg;
  Real[3] r_CM;
  //
  parameter Real[6, 6] Kff = {{E * xprop.A / L, 0, 0, 0, 0, 0}, {0, 12 * E * xprop.Izz / L ^ 3, 0, 0, 0, -6 * E * xprop.Izz / L ^ 2}, {0, 0, 12 * E * xprop.Iyy / L ^ 3, 0, 6 * E * xprop.Iyy / L ^ 2, 0}, {0, 0, 0, G * xprop.J / L, 0, 0}, {0, 0, 6 * E * xprop.Iyy / L ^ 2, 0, 4 * E * xprop.Iyy / L, 0}, {0, -6 * E * xprop.Izz / L ^ 2, 0, 0, 0, 4 * E * xprop.Izz / L}};
  parameter Real[6, 6] Mff = if useLumpedMassMatrix then mass * {{1 / 2, 0, 0, 0, 0, 0}, {0, 1 / 2, 0, 0, 0, 0}, {0, 0, 1 / 2, 0, 0, 0}, {0, 0, 0, 1 / 2*Itt_massless[1], 0, 0}, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0}} else mass * {{1 / 2, 0, 0, 0, 0, 0}, {0, 13 / 35, 0, 0, 0, -11 * L / 210}, {0, 0, 13 / 35, 0, 11 * L / 210, 0}, {0, 0, 0, 1 / 2 * Itt_massless[1], 0, 0}, {0, 0, 11 * L / 210, 0, L * L / 105, 0}, {0, -11 * L / 210, 0, 0, 0, L * L / 105}};
  //
  // Assume small displacements so that Itt is constant
  // Rigid rotational moment of inertia about frame_a
  parameter SI.Inertia Itt_massless[3] = BeamIttCalc(xprop, L) "Inertia tensor of body box with respect to center of mass, parallel to frame_a";
  parameter SI.Inertia Itt[3] = mass * (Itt_massless + {0, (L / 2) ^ 2, (L / 2) ^ 2}) "Inertia tensor of body box with respect frame_a";
  SI.Acceleration g_0[3] "Gravity acceleration resolved in world frame";
  //
  SI.Position r_0[3](start = r_0_start, each stateSelect = StateSelect.avoid) "Position vector from origin of world frame to origin of frame_a" annotation(Dialog(tab = "Initialization", showStartAttribute = true));
  parameter SI.Position r_0_start[3] = {0, 0, 0} "Initial values of position of frame_a" annotation(Dialog(tab = "Initialization"));
  parameter SI.Angle angles_start[3] = {0, 0, 0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(tab = "Initialization"));
  SI.Angle phi[3](start = angles_start, each stateSelect = StateSelect.avoid) "Dummy or 3 angles to rotate world frame into frame_a of body";
  SI.AngularVelocity phi_d[3](each stateSelect = StateSelect.avoid) "= der(phi)";
  //
protected
  outer Modelica.Mechanics.MultiBody.World world;
  outer DeployStructLib.DSL_Globals DSLglb;
  Visualizers.Advanced.Shape shape(shapeType = DeployStructLib.Properties.BeamXProperties.getShapeType(xprop), color = color, specularCoefficient = specularCoefficient, r_shape = {0, 0, 0}, lengthDirection = r+qf[1:3], widthDirection = {0, 1, 0}, length = Modelica.Math.Vectors.length(frame_b.r_0-frame_a.r_0), width = dim2, height = dim3, extra = DeployStructLib.Properties.BeamXProperties.getShapeExtra(xprop), r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
equation
  Connections.branch(frame_a.R, frame_b.R);
  Connections.potentialRoot(frame_a.R);
  //
  if Connections.isRoot(frame_a.R) then
    phi_d = der(phi);
    frame_a.R = Frames.axesRotations(sequence, phi, phi_d);
  else
    phi = zeros(3);
    phi_d = zeros(3);
  end if;
  r_0 = frame_a.r_0;
  //
  //Take this out when omc bug #3202 is fixed
  if DSLglb.useDSgravity then
    g_0 = Frames.resolve2(frame_a.R, world.g * Modelica.Math.Vectors.normalizeWithAssert(world.n));
  else
  //  original: g_0 = world.gravityAcceleration(frame_a.r_0 + Frames.resolve1(frame_a.R, r_CM));
    g_0 = Frames.resolve2(frame_a.R, world.gravityAcceleration(frame_a.r_0));
  end if;
  v = Frames.resolve2(frame_a.R, der(frame_a.r_0));
  v0 = der(frame_a.r_0);
  a = Frames.resolve2(frame_a.R, der(v0));
  w = Frames.angularVelocity2(frame_a.R);
  z = der(w);
  R_rel = Frames.axesRotations({1, 2, 3}, qf[4:6], dqf[4:6]);
  Fb_a = Frames.resolve1(R_rel, frame_b.f);
  Tb_a = Frames.resolve1(R_rel, frame_b.t);
  dqf = der(qf);
  ddqf = der(dqf);
  r_CM = r/2+{qf[1]/2,qf[2]/2-L*qf[6]/8,qf[3]/2+L*qf[5]/8};
  frame_b.r_0 = frame_a.r_0 + Frames.resolve1(frame_a.R, r + qf[1:3]);
  frame_b.R = Frames.absoluteRotation(frame_a.R, R_rel);
  QeR = frame_a.f + Fb_a;
  Qet = frame_a.t + Tb_a + cross(r + qf[1:3], Fb_a);
  // Gravity loads
  if useGravity then
    Qeg = qsFacR * mass / 2 * {g_0[1], g_0[2], g_0[3], 0, g_0[3] * L / 6, -g_0[2] * L / 6};
  else
    Qeg = zeros(6);
  end if;
  Qef = {Fb_a[1], Fb_a[2], Fb_a[3], Tb_a[1], Tb_a[2], Tb_a[3]} + Qeg;
  QvR = -mass * cross(w, cross(w, r_CM));
  Qvt = -cross(w, Itt .* w);
  Qvf = -{-(w[2]*w[2]+w[3]*w[3])/3, w[1]*w[2]*7/20, w[1]*w[3]*7/20, 0, w[1]*w[3]*L/20, -w[1]*w[2]*L/20};
  //
  mass * (a - qsFacR * g_0 + cross(z, r_CM)) = QvR + QeR;
  mass * cross(r_CM, a - qsFacR * g_0) + Itt .* z = Qvt + Qet;
  Mff * ddqf = (-Kff * qf) - (alpha * Mff + beta * Kff) * dqf + Qvf + Qef;
  //
  annotation(Diagram(coordinateSystem(extent = {{-148.5, -105.0}, {148.5, 105.0}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})), Documentation(info="<html>
  <p>
  This block provides an Euler-Bernoulli model of a flexible beam. It is recommended that this model not be used directly. Instead, use DeployStructLib.Parts.Beam and set the \"rigid\" flag to false.
  </p>
  <p>
  Copyright &copy; 2018<br>
  ATA ENGINEERING, INC.<br>
  ALL RIGHTS RESERVED
  </p>
  
  </html>"));
end FlexBeam;
