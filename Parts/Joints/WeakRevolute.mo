within DeployStructLib.Parts.Joints;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model WeakRevolute "Revolute joint (weak formulation)"
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import Modelica.Mechanics.Rotational;
  import SI = Modelica.SIunits;
  //
  Modelica.Mechanics.Rotational.Interfaces.Flange_a axis if useAxisFlange "1-dim. rotational flange that drives the joint" annotation (Placement(transformation(extent={{10,90},{-10,110}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_b support if useAxisFlange "1-dim. rotational flange of the drive support (assumed to be fixed in the world frame, NOT in the joint)" annotation (Placement(transformation(extent={{-70,90},{-50,110}})));
  //
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  //
  parameter Boolean useAxisFlange=false "= true, if axis flange is enabled" annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean rotateAboutX=false "= true, if rotating about X axis relative to frame_a" annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean rotateAboutY=false "= true, if rotating about Y axis relative to frame_a" annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean rotateAboutZ=true "= true, if rotating about Z axis relative to frame_a" annotation(Evaluate=true, HideResult=true, choices(checkBox=true));
  parameter Boolean animation=true "= true, if animation shall be enabled (show axis as cylinder)";
  parameter SI.TranslationalSpringConstant c_pos_constraint(final min = 0) = 1.0e6 "Spring constant for positional constraint";
  parameter SI.RotationalSpringConstant c_rot_constraint(final min = 0) = 1.0e6 "Spring constant for rotational constraint";
  parameter SI.RotationalSpringConstant d_rot_constraint(final min = 0) = 100.0 "Spring constant for rotational constraint";
  parameter SI.Distance cylinderLength=world.defaultJointLength "Length of cylinder representing the joint axis" annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
  parameter SI.Distance cylinderDiameter=world.defaultJointWidth "Diameter of cylinder representing the joint axis" annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
  input Modelica.Mechanics.MultiBody.Types.Color cylinderColor=Modelica.Mechanics.MultiBody.Types.Defaults.JointColor "Color of cylinder representing the joint axis" annotation (Dialog(colorSelector=true, tab="Animation", group="if animation = true", enable=animation));
  input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation (Dialog(tab="Animation", group="if animation = true", enable=animation));
  //
  WeakSpherical weakSpherical(animation = false, c_constraint = c_pos_constraint, useAxisFlangeX = if not rotateAboutX then true elseif useAxisFlange then true else false, useAxisFlangeY = if not rotateAboutY then true elseif useAxisFlange then true else false, useAxisFlangeZ = if not rotateAboutZ then true elseif useAxisFlange then true else false) annotation(Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  Visualizers.Advanced.Shape cylinder(
    shapeType="cylinder",
    color=cylinderColor,
    specularCoefficient=specularCoefficient,
    length=cylinderLength,
    width=cylinderDiameter,
    height=cylinderDiameter,
    lengthDirection=if rotateAboutX then {1,0,0} elseif rotateAboutY then {0,1,0} else {0,0,1},
    widthDirection=if rotateAboutX then {0,1,0} elseif rotateAboutY then {0,0,1} else {1,0,0},
    r_shape=-(if rotateAboutX then {1,0,0} elseif rotateAboutY then {0,1,0} else {0,0,1})*(cylinderLength/2),
    r=frame_a.r_0,
    R=frame_a.R) if world.enableAnimation and animation;
  //
  Modelica.Mechanics.Rotational.Components.SpringDamper spring1(c = c_rot_constraint, d = d_rot_constraint, phi_rel(displayUnit = "rad", nominal=1.0/c_rot_constraint), phi_rel0(displayUnit = "rad"))  annotation(Placement(visible = true, transformation(origin = {-42, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.SpringDamper spring2(c = c_rot_constraint, d = d_rot_constraint, phi_rel(displayUnit = "rad", nominal=1.0/c_rot_constraint), phi_rel0(displayUnit = "rad")) annotation(Placement(visible = true, transformation(origin = {46, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
protected
  outer Modelica.Mechanics.MultiBody.World world;
initial equation
assert((rotateAboutX and rotateAboutY) == false, "Only one rotateAbout? may be selected");
assert((rotateAboutX and rotateAboutZ) == false, "Only one rotateAbout? may be selected");
assert((rotateAboutY and rotateAboutZ) == false, "Only one rotateAbout? may be selected");
equation
  assert(cardinality(frame_a) > 0, "Connector frame_a of revolute joint is not connected");
  assert(cardinality(frame_b) > 0, "Connector frame_b of revolute joint is not connected");
//
  connect(weakSpherical.frame_b, frame_b) annotation(Line(points = {{10, 0}, {102, 0}, {100, 0}}, color = {95, 95, 95}));
  connect(frame_a, weakSpherical.frame_a) annotation(Line(points = {{-100, 0}, {-18, 0}, {-18, -4}, {-18, -4}}));
//
  if rotateAboutX then
    connect(axis, weakSpherical.axisX);
    connect(support, weakSpherical.supportX);
    connect(spring1.flange_a, weakSpherical.supportY);
    connect(spring1.flange_b, weakSpherical.axisY);
    connect(spring2.flange_a, weakSpherical.supportZ);
    connect(spring2.flange_b, weakSpherical.axisZ);
  end if;
  if rotateAboutY then
    connect(axis, weakSpherical.axisY);
    connect(support, weakSpherical.supportY);
    connect(spring1.flange_a, weakSpherical.supportZ);
    connect(spring1.flange_b, weakSpherical.axisZ);
    connect(spring2.flange_a, weakSpherical.supportX);
    connect(spring2.flange_b, weakSpherical.axisX);
  end if;
  if rotateAboutZ then
    connect(axis, weakSpherical.axisZ);
    connect(support, weakSpherical.supportZ);
    connect(spring1.flange_a, weakSpherical.supportX);
    connect(spring1.flange_b, weakSpherical.axisX);
    connect(spring2.flange_a, weakSpherical.supportY);
    connect(spring2.flange_b, weakSpherical.axisY);
  end if;
//
  annotation(Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -60}, {-30, 60}}, radius = 10), Rectangle(lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{30, -60}, {100, 60}}, radius = 10), Rectangle(lineColor = {64, 64, 64}, extent = {{-100, 60}, {-30, -60}}, radius = 10), Rectangle(lineColor = {64, 64, 64}, extent = {{30, 60}, {100, -60}}, radius = 10), Text(lineColor = {128, 128, 128}, extent = {{-90, 14}, {-54, -11}}, textString = "a", fontName = "MS Shell Dlg 2"), Text(lineColor = {128, 128, 128}, extent = {{51, 11}, {87, -14}}, textString = "b", fontName = "MS Shell Dlg 2"), Line(visible = false, points = {{-20, 80}, {-20, 60}}), Line(visible = false, points = {{20, 80}, {20, 60}}), Rectangle(visible = false, fillColor = {192, 192, 192}, fillPattern = FillPattern.VerticalCylinder, extent = {{-10, 100}, {10, 50}}), Polygon(visible = false, lineColor = {64, 64, 64}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-10, 30}, {10, 30}, {30, 50}, {-30, 50}, {-10, 30}}), Rectangle(lineColor = {64, 64, 64}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, extent = {{-30, 11}, {30, -10}}), Polygon(visible = false, lineColor = {64, 64, 64}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{10, 30}, {30, 50}, {30, -50}, {10, -30}, {10, 30}}), Text(extent = {{-150, -110}, {150, -80}}, textString = "n=%n", fontName = "MS Shell Dlg 2"), Text(visible = false, lineColor = {0, 0, 255}, extent = {{-150, -155}, {150, -115}}, textString = "%name", fontName = "MS Shell Dlg 2"), Line(visible = false, points = {{-20, 70}, {-60, 70}, {-60, 60}}), Line(visible = false, points = {{20, 70}, {50, 70}, {50, 60}}), Line(visible = false, points = {{-90, 100}, {-30, 100}}), Line(visible = false, points = {{-30, 100}, {-50, 80}}), Line(visible = false, points = {{-49, 100}, {-70, 80}}), Line(visible = false, points = {{-70, 100}, {-90, 80}}), Text(lineColor = {0, 0, 255}, extent = {{-150, 70}, {150, 110}}, textString = "%name", fontName = "MS Shell Dlg 2"), Line(origin = {-1.99, 2.47}, points = {{-36, 32}, {-20, -32}, {0, 30}, {20, -32}, {36, 32}}, thickness = 4)}), Documentation(info = "<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is a modification of the Revolute block in the Mechanics.MultiBody.Joints package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>
<p>
Block for modeling a revolute joint with a weak constraint. Most Modelica joints introduce strong constraints, i.e. the position of the two frames must be 
exactly equal. In reality, such strong constraints can cause binding in systems with multiple joints and cause systems to have kinematic loops. This joint overcomes these problems by using a weak formulation of the joint constraints.
<p>
Model extends the WeakSpherical joint and adds rotational stiffness to constrained rotations.
<p>
One needs to pay attention and be careful with angle definitions when used in conjunction with rotational springs because phi is determined as a function of R_rel, therefore angle branching occurs at phi = pi and -pi.
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), uses(Modelica(version = "3.2.2")), Diagram(coordinateSystem(initialScale = 0.1)));
end WeakRevolute;
