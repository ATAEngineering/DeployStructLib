within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

partial model Surface "Interface for 3D animation of surface"
  import SI = Modelica.SIunits;
  parameter Integer N = 4 annotation(Evaluate=true);
  input Real transparency = 0 "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)" annotation(Dialog(group = "Surface properties"));
  input Real color[3] = {0, 0, 224} "Color of shape" annotation(Dialog(colorSelector = true));
  input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.3 "Reflection of ambient light (= 1: light is completely absorbed)";
  input SI.Position r_0[N,3] = zeros(N,3) "Position vector from origin of world frame to node frame r_0, resolved in world frame" annotation(Dialog);

annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Surface;
