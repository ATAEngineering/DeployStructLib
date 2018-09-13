within DeployStructLib.Parts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Beam

  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.MaterialProperties.*;
  import DeployStructLib.Properties.EAGJ_BeamProperty;
  import Modelica.Mechanics.MultiBody.Types;
  parameter Boolean rigid = false;
  parameter Boolean useLumpedMassMatrix = false "=true, use a lumped mass matrix formulation else use a consistent mass matrix formulation";
  parameter Boolean useEAGJ = false "=true, use the EAGJ formulation for the beam, requires EAGJ_BeamProperty input parameter";
  parameter Boolean useQuaternions = true;
  parameter Boolean useGravity = false "=true, use gravity in the simulation (computational speedup if not used)";
  import SI = Modelica.SIunits;
  parameter SI.Length L "Beam length";
  parameter beamXProperty xprop "Beam cross-section properties";
  parameter isotropicMaterialProperty matProp "Beam material properties";
  parameter EAGJ_BeamProperty EAGJprop "Beam properties in EAGJ format";
  parameter SI.Length[2] centroid = {0,0} "Cross section centroid relative to frame_a";
  parameter Boolean animation = true;
  parameter SI.Angle angles_start[3] = {0, 0, 0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(tab = "Initialization"));
  parameter SI.Position r_0_start[3] = {0, 0, 0};
  parameter Types.RotationSequence sequence_start = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b at initial time" annotation(Evaluate = true, Dialog(tab = "Initialization"));
  Utilities.RigidBeam beamR(L = L, xprop = xprop, rho = matProp.rho, animation = animation, useQuaternions = useQuaternions, angles_start = angles_start, sequence_start = sequence_start) if rigid;
  Utilities.FlexBeam beamF(L = L, xprop = xprop, matProp = matProp, animation = animation, angles_start = angles_start, r_0_start = r_0_start, useLumpedMassMatrix = useLumpedMassMatrix, useGravity = useGravity) if not rigid and not useEAGJ;
  Utilities.FlexBeamEAGJ beamEAGJ(L = L, EAGJprop = EAGJprop, animation = animation, angles_start = angles_start, r_0_start = r_0_start, useLumpedMassMatrix = useLumpedMassMatrix, useGravity = useGravity) if not rigid and useEAGJ;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(Placement(transformation(extent = {{-116, -16}, {-84, 16}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b annotation(Placement(transformation(extent = {{84, -16}, {116, 16}}, rotation = 0)));
  //
protected
  outer DeployStructLib.DSL_Globals DSLglb;
equation
  if rigid then
    connect(beamR.frame_a, frame_a);
    connect(beamR.frame_b, frame_b);
  elseif not rigid and not useEAGJ then
    connect(beamF.frame_a, frame_a);
    connect(beamF.frame_b, frame_b);
  elseif not rigid and useEAGJ then
    connect(beamEAGJ.frame_a, frame_a);
    connect(beamEAGJ.frame_b, frame_b);
  end if;
  annotation(Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {0, -8.99}, fillColor = {0, 170, 255}, fillPattern = FillPattern.Solid, points = {{-98, 18.9912}, {-44, 18.9912}, {10, 14.9912}, {56, 8.99117}, {98, 0.991169}, {98, -19.0088}, {56, -11.0088}, {10, -5.00883}, {-44, -1.00883}, {-98, -1.00883}, {-98, 18.9912}})}), Documentation(info = "<html>
  <p>
  Standard beam model for DS Library. This block can be used to model either rigid or flexible beams, by setting the value of the \"rigid\" flag to either true or false.
  </p>
  <p>
  The length of the beam should be set here in the beam block. Cross-sectional dimensions and cross section type should be passed in via one of the  <b>DeployStructLib.Properties.BeamXProperties</b> records. Material properties should similarly be supplied by an <b>DeployStructLib.Properties.MaterialProperties</b> record.
  </p>
  <p>
  For <b>rigid</b> beams only:
    If parameter <b>useQuaternions</b> 
   is <b>true</b> (this is the default), then <b>4 quaternions</b>
   are potential states. Additionally, the coordinates of the
   absolute angular velocity vector of the
   body are 3 potential states.<br>
   If <b>useQuaternions</b> in the \"Advanced\" menu
   is <b>false</b>, then <b>3 angles</b> and the derivatives of
   these angles are potential states. The orientation of frame_a
   is computed by rotating the world frame along the axes defined
   in parameter vector \"sequence_angleStates\" (default = {1,2,3}, i.e.,
   the Cardan angle sequence) around the angles used as potential states.
   For example, the default is to rotate the x-axis of the world frame
   around angles[1], the new y-axis around angles[2] and the new z-axis
   around angles[3], arriving at frame_a.
  <p>
  The quaternions have the slight disadvantage that there is a
  non-linear constraint equation between the 4 quaternions.
  Therefore, at least one non-linear equation has to be solved
  during simulation. A tool might, however, analytically solve this
  simple constraint equation. Using the 3 angles as states has the
  disadvantage that there is a singular configuration in which a
  division by zero will occur. If it is possible to determine in advance
  for an application class that this singular configuration is outside
  of the operating region, the 3 angles might be used as potential
  states by setting <b>useQuaternions</b> = <b>false</b>.
  </p>
  <p>
  Copyright &copy; 2018<br>
  ATA ENGINEERING, INC.<br>
  ALL RIGHTS RESERVED
  </p>

  </html>"));
end Beam;
