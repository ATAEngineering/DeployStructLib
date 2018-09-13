within DeployStructLib.Parts.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model BarrierSpring "Non-linear spring acting as a barrier between frame_a and frame_b."

  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Interfaces;
  import Modelica.Mechanics.MultiBody.Forces;
  import Modelica.Mechanics.MultiBody.Frames;
  import SI = Modelica.SIunits;
  extends Modelica.Mechanics.MultiBody.Interfaces.PartialTwoFrames;
  Interfaces.Frame_resolve frame_resolve if resolveInFrame == Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_resolve "The input signals are optionally resolved in this frame" annotation(Placement(transformation(origin = {40, 100}, extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  parameter SI.TranslationalSpringConstant c(final min = 0) "Spring constant";
  parameter SI.TranslationalDampingConstant d(final min = 0) = 0 "Damping constant";
  parameter SI.Length s_unstretched = 0 "Unstretched spring length";
  parameter Real[3] normal = {0, 1, 0} "Direction of barrier normal relative to frame_a" annotation(Evaluate = true);
  parameter Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB resolveInFrame = Modelica.Mechanics.MultiBody.Types.ResolveInFrameAB.frame_a "Frame in which input force is resolved (1: world, 2: frame_a, 3: frame_b, 4: frame_resolve)";
  Modelica.Mechanics.MultiBody.Forces.Force force1(animation = false, resolveInFrame = resolveInFrame) annotation(Placement(visible = true, transformation(origin = {-0.686381, -1.86575}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression[3] const(y = -f * normal) annotation(Placement(visible = true, transformation(origin = {-0.950119, 82.8979}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  SI.Position length "Distance between the origin of frame_a and the origin of frame_b";
  SI.Position r_rel_0[3] "Position vector from frame_a to frame_b resolved in world frame";
  Real[3] vec;
  Real f;
  parameter SI.Position s_small = 0.0000000001 "Prevent zero-division if distance between frame_a and frame_b is zero" annotation(Dialog(tab = "Advanced"));
  Boolean compression "=true, if in compression, otherwise in tension";
  Modelica.SIunits.Force f_d "Damping force";
equation
  connect(force1.frame_resolve, frame_resolve) annotation(Line(points = {{3.31362, 8.13425}, {37.5297, 8.13425}, {37.5297, 99.7625}, {37.5297, 99.7625}}));
  compression = noEvent(length < s_unstretched);
  f_d = noEvent(if compression then d * der(length) else 0.0);
  f = noEvent(semiLinear(length - s_unstretched, 0.0, c)) + f_d;
  r_rel_0 = frame_b.r_0 - frame_a.r_0;
  vec = Frames.resolve2(frame_a.R, r_rel_0);
  length = normal * vec;
  //
  connect(force1.frame_b, frame_b) annotation(Line(points = {{9.31362, -1.86575}, {99.2874, -1.86575}, {99.2874, 0.23753}, {99.2874, 0.23753}}));
  connect(force1.frame_a, frame_a) annotation(Line(points = {{-10.6864, -1.86575}, {-98.5748, -1.86575}, {-98.5748, 0.23753}, {-98.5748, 0.23753}}));
  connect(const.y, force1.force);
  annotation(Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {-19.9768, 1.39373}, points = {{-79.0941, 0}, {-58, 0}, {-43, -30}, {-13, 30}, {17, -30}, {47, 30}, {62, 0}, {82.8107, 0}}), Text(lineColor = {0, 0, 255}, extent = {{-150, 56}, {150, 96}}, textString = "%name"), Text(extent = {{-150, -80}, {150, -50}}, textString = "c=%c"), Ellipse(visible = false, lineColor = {255, 0, 0}, extent = {{-70, 30}, {-130, -30}}, endAngle = 360), Text(visible = false, lineColor = {255, 0, 0}, extent = {{-62, 50}, {-140, 30}}, textString = "R=0"), Ellipse(visible = false, lineColor = {255, 0, 0}, extent = {{70, 30}, {130, -30}}, endAngle = 360), Text(visible = false, lineColor = {255, 0, 0}, extent = {{62, 50}, {140, 30}}, textString = "R=0"), Line(origin = {-32.5202, 43.2056}, points = {{80.8362, 0}, {15.331, 0}}, thickness = 5), Line(origin = {-17.4215, 57.1429}, points = {{80.6039, 0}, {80.3717, -107.549}}, thickness = 5), Line(origin = {49.2785, 43.3216}, points = {{-10, 10}, {0, 0}, {-10, -10}}, thickness = 5)}), Documentation(info = "<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.MultiBody.Forces package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

     <p>
     <b>Non-linear spring</b> acting as line force between frame_a and frame_b.
     A <b>force f</b> is exerted on the origin of frame_b and with opposite sign
     on the origin of frame_a along the line from the origin of frame_a to the origin
     of frame_b.
     <p>
     This spring only exerts force when in compression. The force exerted increases
     exponentially as the spring length gets smaller, to prevent contact between 
     frame_a and frame_b.
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

     </HTML>"));
end BarrierSpring;
