within DeployStructLib.Parts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Spool "Model of a spool with rotational and string connectors that changes converts rotational motion to tension and change in length of the string"

  import Modelica.Mechanics.Rotational;
  constant Real twopi = 2.0 * Modelica.Constants.pi;
  parameter Boolean useSupportR = false "= true, if rotational support flange enabled, otherwise implicitly grounded" annotation(Evaluate = true, HideResult = true, choices(__Dymola_checkBox = true));
  parameter Modelica.SIunits.Distance start_radius(start = 0.3) "Wheel start radius";
  parameter Real tape_thickness = 0 "Tape thickness";
  parameter Real b = tape_thickness / twopi;
  Rotational.Interfaces.Flange_a flangeR "Flange of rotational shaft" annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
  Interfaces.StringConnector string_conn annotation(Placement(visible = true, transformation(origin = {99, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {91.0569, 1.62602}, extent = {{-27.5, -27.5}, {27.5, 27.5}}, rotation = 0)));
  Real radius;
equation
  assert(radius > 0, "Spool radius < 0.0");
  radius = start_radius + b * flangeR.phi;
  string_conn.dL = sqrt(radius^2 + b^2) * der(flangeR.phi);
  flangeR.tau = radius * string_conn.T;
  annotation(Documentation(info = "<html>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>"), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}), graphics), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(fillColor = {255, 255, 0}, fillPattern = FillPattern.Solid, extent = {{-60, -60}, {60, 60}}, endAngle = 360)}));
end Spool;
