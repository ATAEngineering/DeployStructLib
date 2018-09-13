within DeployStructLib.Sources;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

block VariableLengthSource "Block for specifying length rate of change, start, minimum, and maximum lengths for VariableLengthBeam."
  parameter Real dt = 0.1 "Time rate of change of length";
  parameter Real minLength = 0.0 "Minimum length";
  parameter Real maxLength = 1.0 "Maximum length";
  parameter Real startLength = 0.0 "Start length";
  Real L(start=startLength);
  Modelica.Blocks.Interfaces.RealOutput dL annotation(Placement(visible = true, transformation(extent = {{100, -10}, {120, 10}}, rotation = 0), iconTransformation(origin = {130, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
equation
  dL=der(L);
  if L < minLength then
    dL = 0;
  elseif L > maxLength then
    dL = 0;
  else
    dL = dt;
  end if;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {0, 0})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end VariableLengthSource;
