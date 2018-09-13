within DeployStructLib.Interfaces;
/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

connector StringConnector

  flow Modelica.SIunits.Velocity dL "Rate of change in length";
  Modelica.SIunits.Force T "Tension";
  annotation(defaultComponentName = "string_conn", Documentation(info = "<html>
     This is a connector for 1-D string/rope/tape systems. At the connection, the
     tension in the string is equal on both sides, while the rate change in length
     is conserved.
     </p>
     <p>
     The following variables are transported through this connector:
     <pre>
       dL: Rate of change in length of the string in [m/s]. A positive dL
           means that length is added to the string.
       T:  Tension in the string in [N].
     </pre>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>
     </HTML>
     "), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}, initialScale = 0.1, grid = {10, 10}), graphics = {Polygon(visible = true, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{60.0, 15.0}, {-60.0, 15.0}, {-60.0, 40.0}, {-100.0, 0.0}, {-60.0, -40.0}, {-60.0, -15.0}, {60.0, -15.0}, {60.0, -40.0}, {100.0, 0.0}, {60.0, 40.0}})}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}, initialScale = 0.1, grid = {10, 10}), graphics = {Text(visible = true, lineColor = {0, 127, 0}, extent = {{-160.0, 50.0}, {40.0, 110.0}}, textString = "%name", fontName = "Arial"), Polygon(visible = true, fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, points = {{60.0, 15.0}, {-60.0, 15.0}, {-60.0, 40.0}, {-100.0, 0.0}, {-60.0, -40.0}, {-60.0, -15.0}, {60.0, -15.0}, {60.0, -40.0}, {100.0, 0.0}, {60.0, 40.0}})}));
end StringConnector;
