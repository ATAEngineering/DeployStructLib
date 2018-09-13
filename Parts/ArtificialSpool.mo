within DeployStructLib.Parts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model ArtificialSpool "Model consisting of a string connector to which a length change for the string  is applied"
  Interfaces.StringConnector string_conn annotation(Placement(visible = true, transformation(origin = {99, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {91.0569, 1.62602}, extent = {{-27.5, -27.5}, {27.5, 27.5}}, rotation = 0)));
  parameter Real dL = -0.1;
equation
  string_conn.dL = dL;
  annotation(Documentation(info = "<html>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>"), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}), graphics), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-60, -60}, {60, 60}}, endAngle = 360)}));
end ArtificialSpool;
