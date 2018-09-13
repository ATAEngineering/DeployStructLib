within DeployStructLib.Examples.ModelsForExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model OffloaderStrings "Block of offloader strings for Offloader model"
  parameter Real connDist;
  parameter Real height;
  parameter Real c;
  parameter Real mass = 0.001;
  parameter Real[3] topPt = {0, 0, height};
  parameter Real[3] botPt = {connDist, 0, 0};
  parameter Real Ls = sqrt(connDist ^ 2 + height ^ 2);
  //
  DeployStructLib.Parts.Springs.FindLengthSpring springs(c = c, m = mass, Ls = Ls);
  //
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_sideSpar;
  //
equation
  connect(springs.frame_b, frame_sideSpar);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-06, Interval = 0.01), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
Model of strings for an offloader. Each string is modeled as a FindLengthSpring, meaning that the unstretched length of the springs is not known <i>a priori</a> and must be calculated as part of the initalization. 
</p>
</html>"));
end OffloaderStrings;
