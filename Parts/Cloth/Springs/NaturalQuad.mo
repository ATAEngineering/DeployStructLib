within DeployStructLib.Parts.Cloth.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model NaturalQuad
  "Spring employing natural strain formulation, quad element"
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  parameter Real[6, 10] Kqin;
  parameter Real[6, 6] Kq = Kqin[:,1:6];
  parameter Real[6] L = Kqin[:,7];
  parameter Real beta = 0.0;
  parameter Boolean animation = true;
  DeployStructLib.Parts.Cloth.Interfaces.Location[4] location;
  Real[3] d12(start = Kqin[1:3,8], min = -2.0*L[1]*{1,1,1}, max = 2.0*L[1]*{1,1,1}), d23(start = Kqin[4:6,8], min = -2.0*L[2]*{1,1,1}, max = 2.0*L[2]*{1,1,1}), d34(start = Kqin[1:3,9], min = -2.0*L[3]*{1,1,1}, max = 2.0*L[3]*{1,1,1}), d41(start = Kqin[4:6,9], min = -2.0*L[4]*{1,1,1}, max = 2.0*L[4]*{1,1,1}), d13(start = Kqin[1:3,10], min = -2.0*L[5]*{1,1,1}, max = 2.0*L[5]*{1,1,1}), d24(start = Kqin[4:6,10], min = -2.0*L[6]*{1,1,1}, max = 2.0*L[6]*{1,1,1});
  Real[6] fq(each start = 0);
  Real[6] q(each start = 0);
  //
  parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 0, 224} "Color of surface" annotation(Dialog(enable = animation and not multiColoredSurface, colorSelector = true, group = "Material properties"));
  parameter Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7 "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group = "Surface properties"));
  parameter Real transparency = 0 "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)" annotation(Dialog(group = "Surface properties"));
  //
DeployStructLib.Visualization.Quadrangle shape(r_0 = {location[1].r_0,
location[2].r_0, location[3].r_0, location[4].r_0}, color = color, specularCoefficient = specularCoefficient, transparency = transparency) if world.enableAnimation and animation;
protected
  outer Modelica.Mechanics.MultiBody.World world;
//  DeployStructLib.Visualization.Quadrangle shape(r_0 = {location[1].r_0,
//location[2].r_0, location[3].r_0, location[4].r_0}, color = color, specularCoefficient = specularCoefficient, transparency = transparency) if world.enableAnimation and animation;
//
equation
  d12 = location[1].r_0 - location[2].r_0;
  d23 = location[2].r_0 - location[3].r_0;
  d34 = location[3].r_0 - location[4].r_0;
  d41 = location[4].r_0 - location[1].r_0;
  d13 = location[1].r_0 - location[3].r_0;
  d24 = location[2].r_0 - location[4].r_0;
  q = {Vectors.length(d12)-L[1], Vectors.length(d23)-L[2], Vectors.length(d34)-L[3], Vectors.length(d41)-L[4], Vectors.length(d13)-L[5], Vectors.length(d24)-L[6]};
  Kq * q + beta * Kq * der(q) = fq;
  -location[1].f = fq[4] * Vectors.normalize(d41) - fq[1] * Vectors.normalize(d12) - fq[5] * Vectors.normalize(d13);
  -location[2].f = fq[1] * Vectors.normalize(d12) - fq[2] * Vectors.normalize(d23) - fq[6] * Vectors.normalize(d24);
  -location[3].f = fq[2] * Vectors.normalize(d23) - fq[3] * Vectors.normalize(d34) + fq[5] * Vectors.normalize(d13);
  -location[4].f = fq[3] * Vectors.normalize(d34) - fq[4] * Vectors.normalize(d41) + fq[6] * Vectors.normalize(d24);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<html>"));
end NaturalQuad;
