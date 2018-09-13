within DeployStructLib.Parts.Cloth.Interfaces;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Location2Frame
  "Convert connection from Location to Frame"
  import Modelica.Mechanics.MultiBody.Frames;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(Placement(visible = true, transformation(origin = {-100.116, 5.57491}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-97.561, -0.464576}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Location location annotation(Placement(visible = true, transformation(origin = {99.4193, 6.73635}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {97.7933, -1.16144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  frame_a.r_0 = location.r_0;
  zeros(3) = Frames.resolve1(frame_a.R, frame_a.f) + location.f;
  zeros(3) = frame_a.t;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>
</HTML>"));
end Location2Frame;
