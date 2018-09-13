within DeployStructLib.Parts.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model TensionSpring "Linear translational tension-only spring with optional mass"
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Interfaces;
  import Modelica.Mechanics.MultiBody.Forces;
  import Modelica.Mechanics.MultiBody.Frames;
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  parameter Boolean animation = true "= true, if animation shall be enabled";
  parameter Boolean showMass = false "= true, if point mass shall be visualized as sphere if animation=true and m>0";
  parameter Boolean use_events = true "=true, if an event should be used to find changes in tension state" annotation(Evaluate = true);
  parameter SI.TranslationalSpringConstant c(final min = 0) "Spring constant";
  parameter SI.TranslationalDampingConstant d(final min = 0) = 0 "Damping constant";
  parameter SI.Length s_unstretched = 0 "Unstretched spring length";
  parameter Boolean s_rel_fixed = true "Fixed spring length at initialization?";
  parameter Boolean v_rel_fixed = true "Fixed spring length rate of change at initialization?";
  parameter SI.Mass m(min = 0) = 0 "Spring mass located on the connection line between the origin of frame_a and the origin of frame_b";
  parameter Real lengthFraction(min = 0, max = 1) = 0.5 "Location of spring mass with respect to frame_a as a fraction of the distance from frame_a to frame_b (=0: at frame_a; =1: at frame_b)";
  input SI.Distance width = world.defaultForceWidth "Width of spring" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input SI.Distance coilWidth = width / 10 "Width of spring coil" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  parameter Integer numberOfWindings = 5 "Number of spring windings" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Types.Color relaxedColor = {0, 255, 0} "Color when spring is relaxed" annotation(Dialog(colorSelector = true, tab = "Animation", group = "if animation = true", enable = animation));
  input Types.Color tensionedColor = {255, 128, 0} "Color when spring is in tension" annotation(Dialog(colorSelector = true, tab = "Animation", group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input SI.Diameter massDiameter = max(0, (width - 2 * coilWidth) * 0.9) "Diameter of mass point sphere" annotation(Dialog(tab = "Animation", group = "if animation = true and showMass = true", enable = animation and showMass));
  input Types.Color massColor = Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor "Color of mass point" annotation(Dialog(colorSelector = true, tab = "Animation", group = "if animation = true and showMass = true", enable = animation and showMass));
  parameter Boolean fixedRotationAtFrame_a = false "=true, if rotation frame_a.R is fixed (to directly connect line forces)" annotation(Evaluate = true, choices(checkBox = true), Dialog(tab = "Advanced", group = "If enabled, can give wrong results, see MultiBody.UsersGuide.Tutorial.ConnectionOfLineForces"));
  parameter Boolean fixedRotationAtFrame_b = false "=true, if rotation frame_b.R is fixed (to directly connect line forces)" annotation(Evaluate = true, choices(checkBox = true), Dialog(tab = "Advanced", group = "If enabled, can give wrong results, see MultiBody.UsersGuide.Tutorial.ConnectionOfLineForces"));
  Forces.LineForceWithMass lineForce(final animateLine = false, final animateMass = showMass, m = m, lengthFraction = lengthFraction, final lineShapeType = "spring", final lineShapeHeight = coilWidth * 2, final lineShapeWidth = width, final lineShapeExtra = numberOfWindings, final lineShapeColor = Modelica.Mechanics.MultiBody.Types.Defaults.SpringColor, final specularCoefficient = specularCoefficient, final massDiameter = massDiameter, final massColor = massColor, fixedRotationAtFrame_a = fixedRotationAtFrame_a, fixedRotationAtFrame_b = fixedRotationAtFrame_b) annotation(Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Translational.TensionSpring1D spring(c = c, d = d, s_rel(fixed = false, start = s_unstretched), s_rel0 = s_unstretched, use_events = use_events, v_rel(fixed = false, start = 0.0)) annotation(Placement(transformation(extent = {{-8, 40}, {12, 60}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape lineShape(shapeType = "cylinder", color = noEvent(if spring.f > 0.0 then tensionedColor else relaxedColor), specularCoefficient = specularCoefficient, length = lineForce.length, width = width, height = coilWidth * 2, lengthDirection = lineForce.e_rel_0, widthDirection = Frames.resolve1(frame_a.R, {0, 1, 0}), extra = numberOfWindings, r = frame_a.r_0) if world.enableAnimation and animation;
equation
  connect(lineForce.frame_a, frame_a) annotation(Line(points = {{-20, 0}, {-100, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(lineForce.frame_b, frame_b) annotation(Line(points = {{20, 0}, {100, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(spring.flange_b, lineForce.flange_b) annotation(Line(points = {{12, 50}, {12, 20}}, color = {0, 191, 0}));
  connect(spring.flange_a, lineForce.flange_a) annotation(Line(points = {{-8, 50}, {-12, 50}, {-12, 20}}, color = {0, 191, 0}));
  annotation(Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics), Documentation(info = "<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.MultiBody.Forces package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

     <p>
     <b>Linear spring</b> acting as line force between frame_a and frame_b.
     A <b>force f</b> is exerted on the origin of frame_b and with opposite sign
     on the origin of frame_a along the line from the origin of frame_a to the origin
     of frame_b according to the equation:
     </p>
     <pre>
        f = c*(s - s_unstretched);
     </pre>
     <p>
     where \"c\" and \"s_unstretched\" are parameters and \"s\" is the
     distance between the origin of frame_a and the origin of frame_b.
     </p>
     <p>
     This spring only exerts force when in tension.
     </p>
     <p>
     Optionally, the mass of the spring is taken into account by a
     point mass located on the line between frame_a and frame_b
     (default: middle of the line). If the spring mass is zero, the
     additional equations to handle the mass are removed.
     </p>
     <p>
     In the following figure a typical animation of the
     spring is shown. The blue sphere in the middle of the
     spring characterizes the location of the point mass.
     </p>

     <p>
     <IMG src=\"modelica://Modelica/Resources/Images/Mechanics/MultiBody/Examples/Elementary/SpringWithMass.png\"
     ALT=\"model Examples.Elementary.SpringWithMass\">
     </p>

     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>"), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {10, 10}), graphics = {Line(points = {{-100, 0}, {-58, 0}, {-43, -30}, {-13, 30}, {17, -30}, {47, 30}, {62, 0}, {100, 0}}), Text(lineColor = {0, 0, 255}, extent = {{-130, 49}, {132, 109}}, textString = "%name", fontName = "Arial"), Text(fillPattern = FillPattern.Solid, extent = {{-141, -92}, {125, -51}}, textString = "k=%k", fontName = "Arial"), Line(origin = {-99.1869, 43.9025}, points = {{80.8362, 0}, {15.331, 0}}, thickness = 5), Line(origin = {-85.4485, 44.0185}, points = {{10, 10}, {0, 0}, {10, -10}}, thickness = 5), Line(origin = {-5.34257, 43.6702}, points = {{80.8362, 0}, {15.331, 0}}, thickness = 5), Line(origin = {76.9208, 43.7862}, points = {{-10, 10}, {0, 0}, {-10, -10}}, thickness = 5)}));
end TensionSpring;
