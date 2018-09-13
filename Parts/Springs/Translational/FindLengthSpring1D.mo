within DeployStructLib.Parts.Springs.Translational;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FindLengthSpring1D "Linear 1D translational spring with unstretched length initialization"
  import Modelica.Mechanics.Translational.Interfaces;
  import SI = Modelica.SIunits;
  parameter SI.TranslationalSpringConstant c(final min = 0, start = 1) "Spring constant for a 1m spring (units in N, equivalent to EA)";
  parameter SI.Length Ls = 1.0 "Initial stretched spring length";
  parameter SI.Length L0 = Ls - dL0 "Unstretched spring length";
  parameter SI.Distance dL0(fixed = false, start = 0.0, min = 0.0) "Difference between unstretched spring length and Ls";
  Interfaces.Flange_a flange_a "Left flange of compliant 1-dim. translational component" annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}}, rotation = 0)));
  Interfaces.Flange_b flange_b "Right flange of compliant 1-dim. translational component" annotation(Placement(transformation(extent = {{90, -10}, {110, 10}}, rotation = 0)));
  SI.Position s_rel(fixed = true, start = Ls) "Relative distance (= flange_b.s - flange_a.s)";
  SI.Force f "Force between flanges (positive in direction of flange axis R)";
equation
  s_rel = flange_b.s - flange_a.s;
  flange_b.f = f;
  flange_a.f = -f;
  f = c * (s_rel / (Ls - dL0) - 1);
  annotation(Documentation(info = "<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.Translational.Components package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
A <i>linear 1D translational spring with unstretched length initialization</i>. 
</p>
<p>
The initial stretched spring length is given by parameter <i>Ls</i> and the unstretched spring length <i>L0</i> is determined during intialization.
Parameter <i>dL0</i> is the difference between <i>Ls</i> and <i>L0</i>, which can be used to make a better starting guess for initialization (the default is 0.0).
</p>
<p>
The spring constant <i>c</i> is defined as the stiffness of a 1m spring. This is because the length of the spring is unknown until after initialization (i.e., 
the stiffness k=E*A/L cannot be determined until later). Therefore, the spring constant <i>c</i> is equivalent to c=E*A.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-60, -90}, {20, -90}}, color = {0, 0, 0}), Polygon(points = {{50, -90}, {20, -80}, {20, -100}, {50, -90}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", lineColor = {0, 0, 255}), Line(points = {{-98, 0}, {-60, 0}, {-44, -30}, {-16, 30}, {14, -30}, {44, 30}, {60, 0}, {100, 0}}, color = {0, 0, 0}), Text(extent = {{-150, -45}, {150, -75}}, lineColor = {0, 0, 0}, textString = "c=%c")}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-100, 0}, {-100, 65}}, color = {128, 128, 128}), Line(points = {{100, 0}, {100, 65}}, color = {128, 128, 128}), Line(points = {{-100, 60}, {100, 60}}, color = {128, 128, 128}), Polygon(points = {{90, 63}, {100, 60}, {90, 57}, {90, 63}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid), Text(extent = {{-56, 66}, {36, 81}}, lineColor = {0, 0, 255}, textString = "s_rel"), Line(points = {{-86, 0}, {-60, 0}, {-44, -30}, {-16, 30}, {14, -30}, {44, 30}, {60, 0}, {84, 0}}, color = {0, 0, 0})}));
end FindLengthSpring1D;

