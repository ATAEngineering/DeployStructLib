within DeployStructLib.Examples.ModelsForExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Offloader "Basic offloader model"
  parameter Real connDist "Radial distance at which strings will be connected";
  final parameter Integer S "Number of sections to offload";
  parameter Real height "Height of gathering point above array";
  parameter Real c "Stiffness of offloader strings";
  parameter Real mass "Mass of strings";
  OffloaderStrings[S] strings(each connDist = connDist, each height = height, each c = c, each mass = mass);
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_Top annotation(Placement(visible = true, transformation(origin = {-98.1417, -6.03949}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {0, 84}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
equation
  for i in 1:S loop
    connect(strings[i].springs.frame_a, frame_Top);
  end for;
  annotation(Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
Basic offloader model for fan-fold array. The strings are gathered at a single point (\"frame_Top\") and attach to the array at \"connDist\" away from the center.
</html>"), Icon(graphics = {Line(origin = {-20, -8}, points = {{22, 50}, {-22, -50}}, thickness = 4), Line(origin = {24, -8}, points = {{-22, 50}, {22, -50}}, thickness = 4), Text(origin = {3, -78}, lineThickness = 3, extent = {{-63, 14}, {63, -14}}, textString = "Offloader", fontName = "MS Shell Dlg 2"), Text(origin = {0, 56}, lineThickness = 3, extent = {{-38, 6}, {38, -6}}, textString = "frame_top", fontName = "MS Shell Dlg 2")}, coordinateSystem(initialScale = 0.1)));
end Offloader;
