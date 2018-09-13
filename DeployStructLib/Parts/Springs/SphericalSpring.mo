within DeployStructLib.Parts.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model SphericalSpring "Spherical joint (3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)"
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  parameter SI.TranslationalSpringConstant[3] c(each final min = 0) "Spring constants {rx,ry,rz}";
  parameter Boolean animation = false "= true, if animation shall be enabled (show sphere)";
  parameter SI.Distance sphereDiameter = world.defaultJointLength "Diameter of sphere representing the spherical joint" annotation(Dialog(group = "if animation = true", enable = animation));
  input Types.Color sphereColor = Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of sphere representing the spherical joint" annotation(Dialog(colorSelector = true, group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group = "if animation = true", enable = animation));
  parameter Boolean angles_fixed = false "= true, if angles_start are used as initial values, else as guess values" annotation(Evaluate = true, choices(checkBox = true), Dialog(tab = "Initialization"));
  parameter SI.Angle angles_start[3] = {0, 0, 0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(tab = "Initialization"));
  parameter Types.RotationSequence sequence_start = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b at initial time" annotation(Evaluate = true, Dialog(tab = "Initialization"));
  parameter Boolean w_rel_a_fixed = false "= true, if w_rel_a_start are used as initial values, else as guess values" annotation(Evaluate = true, choices(checkBox = true), Dialog(tab = "Initialization"));
  parameter SI.AngularVelocity w_rel_a_start[3] = {0, 0, 0} "Initial values of angular velocity of frame_b with respect to frame_a, resolved in frame_a" annotation(Dialog(tab = "Initialization"));
  parameter Boolean z_rel_a_fixed = false "= true, if z_rel_a_start are used as initial values, else as guess values" annotation(Evaluate = true, choices(checkBox = true), Dialog(tab = "Initialization"));
  parameter SI.AngularAcceleration z_rel_a_start[3] = {0, 0, 0} "Initial values of angular acceleration z_rel_a = der(w_rel_a)" annotation(Dialog(tab = "Initialization"));
  parameter Types.RotationSequence sequence_angleStates = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b around the 3 angles used as states" annotation(Evaluate = true, Dialog(tab = "Advanced"));
  final parameter Frames.Orientation R_rel_start = Frames.axesRotations(sequence_start, angles_start, zeros(3)) "Orientation object from frame_a to frame_b at initial time";
  // Declaration for 3 angles
  parameter SI.Angle phi_start[3] = if sequence_start[1] == sequence_angleStates[1] and sequence_start[2] == sequence_angleStates[2] and sequence_start[3] == sequence_angleStates[3] then angles_start else Frames.axesRotationsAngles(R_rel_start, sequence_angleStates) "Potential angle states at initial time";
  SI.Angle phi[3](start = phi_start) "Dummy or 3 angles to rotate frame_a into frame_b";
  SI.AngularVelocity phi_d[3] "= der(phi)";
  SI.AngularAcceleration phi_dd[3] "= der(phi_d)";
  // Other declarations
  SI.AngularVelocity w_rel[3](start = Frames.resolve2(R_rel_start, w_rel_a_start), fixed = fill(w_rel_a_fixed, 3)) "Dummy or relative angular velocity of frame_b with respect to frame_a, resolved in frame_b";
protected
  Visualizers.Advanced.Shape sphere(shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = {-0.5, 0, 0} * sphereDiameter, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
  Frames.Orientation R_rel "Dummy or relative orientation object to rotate from frame_a to frame_b";
  Frames.Orientation R_rel_inv "Dummy or relative orientation object to rotate from frame_b to frame_a";
initial equation
  if angles_fixed then
    // The 3 angles 'phi' are used as states
    phi = phi_start;
  end if;
  if z_rel_a_fixed then
    // Initialize acceleration variables
    der(w_rel) = Frames.resolve2(R_rel_start, z_rel_a_start);
  end if;
equation
  // torque balance
  zeros(3) = frame_a.t + c .* phi;
  zeros(3) = frame_b.t - c .* phi;
  //
  Connections.branch(frame_a.R, frame_b.R);
  frame_b.r_0 = frame_a.r_0;
  if rooted(frame_a.R) then
    R_rel_inv = Frames.nullRotation();
    frame_b.R = Frames.absoluteRotation(frame_a.R, R_rel);
    zeros(3) = frame_a.f + Frames.resolve1(R_rel, frame_b.f);
  else
    R_rel_inv = Frames.inverseRotation(R_rel);
    frame_a.R = Frames.absoluteRotation(frame_b.R, R_rel_inv);
    zeros(3) = frame_b.f + Frames.resolve2(R_rel, frame_a.f);
  end if;
  // Compute relative orientation object
  // Use angles as states
  phi_d = der(phi);
  phi_dd = der(phi_d);
  R_rel = Frames.axesRotations(sequence_angleStates, phi, phi_d);
  w_rel = Frames.angularVelocity2(R_rel);
  annotation(Documentation(info = "<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spherical block in the Mechanics.MultiBody.Joints package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Block for modeling a spherical joint with torsional stiffness in each direction.
The torsional stiffness of this joint in all three directions is determined by the constant c.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164}), Text(extent = {{-150, -115}, {150, -75}}, textString = "%name", lineColor = {0, 0, 255})}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164})}));
end SphericalSpring;
