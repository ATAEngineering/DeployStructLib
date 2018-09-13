within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model SEvisualization
import SI = Modelica.SIunits;
parameter String file;
parameter Boolean animation = true;
parameter Integer M "Number of modes";

input SI.Position r_0[3] = zeros(3) "Position vector from origin of world frame to node frame r_0, resolved in world frame" annotation(Dialog);
input Real[3,3] T = zeros(3,3) "SE orientation";
input Real[M] qf "Modal dof";

input Real[3] color = {64, 0, 128} "Color of shape";
input Real transparency = 0 "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)" annotation(Dialog(group = "Surface properties"));
input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7 "Reflection of ambient light (= 0: light is completely absorbed)";

annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end SEvisualization;
