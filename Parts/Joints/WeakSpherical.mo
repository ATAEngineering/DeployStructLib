within DeployStructLib.Parts.Joints;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model WeakSpherical "Spherical joint with spring (weak formulation, 3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)"
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  parameter Boolean useAxisFlangeX = false "= true, if axis flange X is enabled" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
  parameter Boolean useAxisFlangeY = false "= true, if axis flange Y is enabled" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
  parameter Boolean useAxisFlangeZ = false "= true, if axis flange Z is enabled" annotation(Evaluate = true, HideResult = true, choices(checkBox = true));
  parameter SI.TranslationalSpringConstant c_constraint(final min = 0) = 1.0e7 "Spring constant";
  parameter SI.TranslationalDampingConstant d_constraint(final min = 0) = 1.0 "Damping constant";
  parameter Boolean animation = false "= true, if animation shall be enabled (show sphere)";
  parameter SI.Distance sphereDiameter = world.defaultJointLength "Diameter of sphere representing the spherical joint" annotation(Dialog(group = "if animation = true", enable = animation));
  input Types.Color sphereColor = Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of sphere representing the spherical joint" annotation(Dialog(colorSelector = true, group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group = "if animation = true", enable = animation));
  parameter Types.RotationSequence sequence_angles = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b around the 3 angles used as states" annotation(Evaluate = true, Dialog(tab = "Advanced"));
  SI.Position[3] r_rel_a(each start = 0, each stateSelect = StateSelect.never, each nominal=1.0/c_constraint) "Position vector from frame_a to frame_b resolved in world frame";
  SI.Position[3] v_rel_a(each start = 0, each stateSelect = StateSelect.never);
  SI.Angle[3] phi(each start = 0, each stateSelect = StateSelect.never) "Three angles to rotate frame_a into frame_b";
  Frames.Orientation R_rel "Relative orientation object to rotate from frame_a to frame_b";
  SI.Torque[3] tau "Driving torque in direction of axis of rotation";
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axisX if useAxisFlangeX "1-dim. rotational flange that drives the joint" annotation(Placement(transformation(extent = {{10, 90}, {-10, 110}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b supportX if useAxisFlangeX "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation(Placement(transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b supportZ if useAxisFlangeZ "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation(Placement(visible = true, transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0), iconTransformation(extent = {{80, -56}, {100, -36}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axisZ if useAxisFlangeZ "1-dim. rotational flange that drives the joint" annotation(Placement(visible = true, transformation(extent = {{10, 90}, {-10, 110}}, rotation = 0), iconTransformation(extent = {{80, -100}, {100, -80}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axisY if useAxisFlangeY "1-dim. rotational flange that drives the joint" annotation(Placement(visible = true, transformation(extent = {{10, 90}, {-10, 110}}, rotation = 0), iconTransformation(extent = {{80, 34}, {100, 54}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b supportY if useAxisFlangeY "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation(Placement(visible = true, transformation(extent = {{-70, 90}, {-50, 110}}, rotation = 0), iconTransformation(extent = {{80, 80}, {100, 100}}, rotation = 0)));
protected
  Visualizers.Advanced.Shape sphere(shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = {-0.5, 0, 0} * sphereDiameter, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
  Modelica.Mechanics.Rotational.Components.Fixed fixedX "support flange is fixed to ground" annotation(Placement(transformation(extent = {{-70, 70}, {-50, 90}})));
  Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalAxisX(tau = tau[1]) annotation(Placement(transformation(extent = {{-10, 90}, {10, 70}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorqueX(tau_constant = 0) if not useAxisFlangeX annotation(Placement(transformation(extent = {{40, 70}, {20, 90}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixedY "support flange is fixed to ground" annotation(Placement(transformation(extent = {{-70, 70}, {-50, 90}})));
  Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalAxisY(tau = tau[2]) annotation(Placement(transformation(extent = {{-10, 90}, {10, 70}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorqueY(tau_constant = 0) if not useAxisFlangeY annotation(Placement(transformation(extent = {{40, 70}, {20, 90}})));
  Modelica.Mechanics.Rotational.Components.Fixed fixedZ "support flange is fixed to ground" annotation(Placement(transformation(extent = {{-70, 70}, {-50, 90}})));
  Modelica.Mechanics.Rotational.Interfaces.InternalSupport internalAxisZ(tau = tau[3]) annotation(Placement(transformation(extent = {{-10, 90}, {10, 70}})));
  Modelica.Mechanics.Rotational.Sources.ConstantTorque constantTorqueZ(tau_constant = 0) if not useAxisFlangeZ annotation(Placement(transformation(extent = {{40, 70}, {20, 90}})));
equation
//
  R_rel = Frames.relativeRotation(frame_a.R, frame_b.R);
  r_rel_a = Frames.resolve2(frame_a.R, frame_b.r_0 - frame_a.r_0);
  v_rel_a = der(r_rel_a);
  zeros(3) = frame_a.t + Frames.resolve1(R_rel, frame_b.t) + cross(r_rel_a, Frames.resolve1(R_rel, frame_b.f));
  frame_b.f = -Frames.resolve2(R_rel, -c_constraint * r_rel_a - d_constraint * v_rel_a);
  zeros(3) = frame_a.f + Frames.resolve1(R_rel, frame_b.f);
  phi[1] = Frames.planarRotationAngle({1, 0, 0}, {0, 0, 1}, Frames.resolve2(R_rel, {0, 0, 1}));
  phi[2] = Frames.planarRotationAngle({0, 1, 0}, {1, 0, 0}, Frames.resolve2(R_rel, {1, 0, 0}));
  phi[3] = Frames.planarRotationAngle({0, 0, 1}, {0, 1, 0}, Frames.resolve2(R_rel, {0, 1, 0}));
  tau = -frame_b.t;
  // Connection to internal connectors
  phi[1] = internalAxisX.phi;
  phi[2] = internalAxisY.phi;
  phi[3] = internalAxisZ.phi;
  connect(fixedX.flange, supportX) annotation(Line(points = {{-60, 80}, {-60, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(internalAxisX.flange, axisX) annotation(Line(points = {{0, 80}, {0, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(constantTorqueX.flange, internalAxisX.flange) annotation(Line(points = {{20, 80}, {0, 80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(fixedY.flange, supportY) annotation(Line(points = {{-60, 80}, {-60, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(internalAxisY.flange, axisY) annotation(Line(points = {{0, 80}, {0, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(constantTorqueY.flange, internalAxisY.flange) annotation(Line(points = {{20, 80}, {0, 80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(fixedZ.flange, supportZ) annotation(Line(points = {{-60, 80}, {-60, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(internalAxisZ.flange, axisZ) annotation(Line(points = {{0, 80}, {0, 100}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(constantTorqueZ.flange, internalAxisZ.flange) annotation(Line(points = {{20, 80}, {0, 80}}, color = {0, 0, 0}, smooth = Smooth.None));
  annotation(Documentation(info = "<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is a modification of the Spherical block in the Mechanics.MultiBody.Joints package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Block for modeling a spherical joint with a weak constraint. Most Modelica joints introduce strong constraints, i.e. the position of the two frames must be 
exactly equal. In reality, such strong constraints can cause binding in systems with multiple joints and cause systems to have kinematic loops. This joint overcomes these problems by using a weak formulation of the joint constraints.
<p>
Rotational springs can be connected to add torsional stiffness to the joint.
<p>
One needs to pay attention and be careful with angle definitions when used in conjunction with rotational springs because phi is determined as a function of R_rel, therefore angle branching occurs at phi = pi and -pi.
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164}), Text(extent = {{-150, -115}, {150, -75}}, textString = "%name", lineColor = {0, 0, 255})}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164})}));
end WeakSpherical;
