within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model CADvisualization
import SI = Modelica.SIunits;
parameter Boolean animation = true;

parameter String CAD_filename;
parameter Real CAD_scale = 1.0 "CAD scale factor";
parameter SI.Position[3] CAD_r_0 = zeros(3) "CAD to Frame_A position vector";
parameter Real[3] CAD_angles = zeros(3) "CAD to Frame_A orientation angles (X,Y,Z)";

input SI.Position[3] r_0 = zeros(3) "Position vector from origin of world frame to Frame_A, resolved in world frame" annotation(Dialog);
input Real[3,3] T = zeros(3,3) "Frame_A orientation";

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
end CADvisualization;
