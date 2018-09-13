within DeployStructLib.Parts.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model UniversalSpring "Universal joint with torsional stiffness (2 degrees-of-freedom, 4 potential states)"
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import SI = Modelica.SIunits;
  parameter SI.TranslationalSpringConstant c_a(each final min = 0) "Spring constant for joint1 axis";
  parameter SI.TranslationalSpringConstant c_b(each final min = 0) "Spring constant for joint2 axis";
  parameter Boolean animation = false "= true, if animation shall be enabled";
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_a = {1, 0, 0} "Axis of revolute joint 1 resolved in frame_a" annotation(Evaluate = true);
  parameter Modelica.Mechanics.MultiBody.Types.Axis n_b = {0, 1, 0} "Axis of revolute joint 2 resolved in frame_b" annotation(Evaluate = true);
  parameter SI.Distance cylinderLength = world.defaultJointLength "Length of cylinders representing the joint axes" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  parameter SI.Distance cylinderDiameter = world.defaultJointWidth "Diameter of cylinders representing the joint axes" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Types.Color cylinderColor = Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinders representing the joint axes" annotation(Dialog(colorSelector = true, tab = "Animation", group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  parameter StateSelect stateSelect = StateSelect.prefer "Priority to use joint coordinates (phi_a, phi_b, w_a, w_b) as states" annotation(Dialog(tab = "Advanced"));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute_a(n = n_a, stateSelect = StateSelect.never, cylinderDiameter = cylinderDiameter, cylinderLength = cylinderLength, cylinderColor = cylinderColor, specularCoefficient = specularCoefficient, animation = animation, useAxisFlange = true) annotation(Placement(transformation(extent = {{-60, -25}, {-10, 25}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute_b(n = n_b, stateSelect = StateSelect.never, animation = animation, cylinderDiameter = cylinderDiameter, cylinderLength = cylinderLength, cylinderColor = cylinderColor, specularCoefficient = specularCoefficient, useAxisFlange = true) annotation(Placement(transformation(origin = {35, 45}, extent = {{-25, -25}, {25, 25}}, rotation = 90)));
  SI.Angle phi_a(start = 0, stateSelect = stateSelect) "Relative rotation angle from frame_a to intermediate frame";
  SI.Angle phi_b(start = 0, stateSelect = stateSelect) "Relative rotation angle from intermediate frame to frame_b";
  SI.AngularVelocity w_a(start = 0, stateSelect = stateSelect) "First derivative of angle phi_a (relative angular velocity a)";
  SI.AngularVelocity w_b(start = 0, stateSelect = stateSelect) "First derivative of angle phi_b (relative angular velocity b)";
  SI.AngularAcceleration a_a(start = 0) "Second derivative of angle phi_a (relative angular acceleration a)";
  SI.AngularAcceleration a_b(start = 0) "Second derivative of angle phi_b (relative angular acceleration b)";
  Modelica.Mechanics.Rotational.Components.Spring spring_a(c = c_a) annotation(Placement(visible = true, transformation(origin = {-42, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.Spring spring_b(c = c_b) annotation(Placement(visible = true, transformation(origin = {-6, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(spring_b.flange_b, revolute_b.axis) annotation(Line(points = {{-6, 48}, {10, 48}, {10, 44}, {10, 44}}));
  connect(spring_b.flange_a, revolute_b.support) annotation(Line(points = {{-6, 28}, {10, 28}, {10, 30}, {10, 30}}));
  connect(spring_a.flange_b, revolute_a.axis) annotation(Line(points = {{-32, 48}, {-34, 48}, {-34, 26}, {-34, 26}}));
  connect(spring_a.flange_a, revolute_a.support) annotation(Line(points = {{-52, 48}, {-50, 48}, {-50, 26}, {-50, 26}}));
  phi_a = revolute_a.phi;
  phi_b = revolute_b.phi;
  w_a = der(phi_a);
  w_b = der(phi_b);
  a_a = der(w_a);
  a_b = der(w_b);
  connect(frame_a, revolute_a.frame_a) annotation(Line(points = {{-100, 0}, {-60, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(revolute_b.frame_b, frame_b) annotation(Line(points = {{35, 70}, {35, 90}, {70, 90}, {70, 0}, {100, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(revolute_a.frame_b, revolute_b.frame_a) annotation(Line(points = {{-10, 0}, {35, 0}, {35, 20}}, color = {95, 95, 95}, thickness = 0.5));
  annotation(Documentation(info = "<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Universal block in the Mechanics.MultiBody.Joints package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Block for modeling a universal joint with torsional stiffness in each direction.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 15}, {-65, -15}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {235, 235, 235}), Ellipse(extent = {{-80, -80}, {80, 80}}, lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-60, -60}, {60, 60}}, lineColor = {160, 160, 164}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-150, -80}, {150, -120}}, textString = "%name", lineColor = {0, 0, 255}), Rectangle(extent = {{12, 82}, {80, -82}}, lineColor = {255, 255, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Rectangle(extent = {{56, 15}, {100, -15}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {235, 235, 235}), Line(points = {{12, 78}, {12, -78}}, color = {0, 0, 0}, thickness = 0.5), Ellipse(extent = {{-52, -40}, {80, 40}}, lineColor = {160, 160, 164}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Ellipse(extent = {{-32, -20}, {60, 26}}, lineColor = {160, 160, 164}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Polygon(points = {{-22, -54}, {-60, 0}, {-22, 50}, {40, 52}, {-22, -54}}, pattern = LinePattern.None, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineColor = {0, 0, 255}), Line(points = {{12, 78}, {12, -20}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{32, 38}, {-12, -36}}, color = {0, 0, 0}, thickness = 0.5)}));
end UniversalSpring;
