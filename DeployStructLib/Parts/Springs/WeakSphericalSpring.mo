within DeployStructLib.Parts.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model WeakSphericalSpring "Spherical joint with torsional stiffness (weak formulation, 3 constraints and no potential states, or 3 degrees-of-freedom and 3 states)"
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  parameter SI.TranslationalSpringConstant c_constraint(final min = 0) = 1.0e6 "Spring constant";
  parameter SI.TranslationalSpringConstant[3] c(each final min = 0) "Spring constants {rx,ry,rz}";
  parameter SI.Angle[3] phi_rel0 = {0, 0, 0} "Unstretched spring angles";
  parameter Boolean animation = false "= true, if animation shall be enabled (show sphere)";
  parameter SI.Distance sphereDiameter = world.defaultJointLength "Diameter of sphere representing the spherical joint" annotation(Dialog(group = "if animation = true", enable = animation));
  input Types.Color sphereColor = Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of sphere representing the spherical joint" annotation(Dialog(colorSelector = true, group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group = "if animation = true", enable = animation));
  parameter Types.RotationSequence sequence_angles = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b around the 3 angles used as states" annotation(Evaluate = true, Dialog(tab = "Advanced"));
  SI.Position r_rel_0[3] "Position vector from frame_a to frame_b resolved in world frame";
  SI.Angle phi[3] "Three angles to rotate frame_a into frame_b";
  Frames.Orientation R_rel "Relative orientation object to rotate from frame_a to frame_b";
protected
  Visualizers.Advanced.Shape sphere(shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = {-0.5, 0, 0} * sphereDiameter, r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
equation
  // torque balance
  zeros(3) = frame_a.t + c .* (phi - phi_rel0);
  zeros(3) = frame_b.t - c .* (phi - phi_rel0);
  // weak positional constraint and forces
  r_rel_0 = frame_b.r_0 - frame_a.r_0;
  frame_a.f = -Frames.resolve2(frame_a.R, c_constraint * r_rel_0);
  frame_b.f = -Frames.resolve2(frame_b.R, -c_constraint * r_rel_0);
  //
  R_rel = Frames.relativeRotation(frame_a.R, frame_b.R);
  phi = Frames.axesRotationsAngles(R_rel, sequence_angles);
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
Block for modeling a spherical joint with a weak constraint. Most Modelica joints introduce strong constraints, i.e. the position of the two frames must be 
exactly equal. In reality, such strong constraints can cause binding in systems with multiple joints and cause systems to have kinematic loops. This joint overcomes these problems by using a weak formulation of the joint constraints.
<p>
The torsional stiffness of this joint in all three directions is determined by the constant c.
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164}), Text(extent = {{-150, -115}, {150, -75}}, textString = "%name", lineColor = {0, 0, 255})}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-70, -70}, {70, 70}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {192, 192, 192}), Ellipse(extent = {{-49, -50}, {51, 50}}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{30, 70}, {71, -68}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{-100, 10}, {-68, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Rectangle(extent = {{23, 10}, {100, -10}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {192, 192, 192}), Ellipse(extent = {{-24, 25}, {26, -25}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {160, 160, 164})}));
end WeakSphericalSpring;
