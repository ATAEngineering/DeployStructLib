within DeployStructLib.Parts.Cloth.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model NaturalTriangle
  "Spring employing natural strain formulation, triangle element"
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  parameter Real[3, 7] Kqin;
  parameter Real[3, 3] Kq = Kqin[:,1:3];
  parameter Real[3] L = Kqin[:,4];
  parameter Real beta = 0.0;
  parameter Boolean animation = true;
  DeployStructLib.Parts.Cloth.Interfaces.Location[3] location;
  Real[3] d12(start = Kqin[:,5], min = -2.0*L[3]*{1,1,1}, max = 2.0*L[3]*{1,1,1}), d23(start = Kqin[:,6], min = -2.0*L[1]*{1,1,1}, max = 2.0*L[1]*{1,1,1}), d31(start = Kqin[:,7], min = -2.0*L[2]*{1,1,1}, max = 2.0*L[2]*{1,1,1});
  Real[3] fq(each start = 0);
  Real[3] q(each start = 0);
  Real[3] ftot;
  Real[3] ESEtmp;
  Real[3] Wtmp;
  Real ESE;
  Real W;
  Real[3] Dtmp;
  Real D,E;
  //
  parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 0, 224} "Color of surface" annotation(Dialog(enable = animation and not multiColoredSurface, colorSelector = true, group = "Material properties"));
  parameter Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = 0.7 "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(group = "Surface properties"));
  parameter Real transparency = 0 "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)" annotation(Dialog(group = "Surface properties"));
//
  DeployStructLib.Visualization.Triangle shape(r_0 = {location[1].r_0, location[2].r_0, location[3].r_0}, color = color, specularCoefficient = specularCoefficient, transparency = transparency) if world.enableAnimation and animation;
protected
  outer Modelica.Mechanics.MultiBody.World world;
equation
  d12 = location[1].r_0 - location[2].r_0;
  d23 = location[2].r_0 - location[3].r_0;
  d31 = location[3].r_0 - location[1].r_0;
  q = {Vectors.length(d23)-L[1], Vectors.length(d31)-L[2], Vectors.length(d12)-L[3]};
  Kq * q + beta * Kq * der(q) = fq;
  -location[1].f = fq[2] * Vectors.normalize(d31) - fq[3] * Vectors.normalize(d12);
  -location[2].f = fq[3] * Vectors.normalize(d12) - fq[1] * Vectors.normalize(d23);
  -location[3].f = fq[1] * Vectors.normalize(d23) - fq[2] * Vectors.normalize(d31);
  ftot=location[1].f+location[2].f+location[3].f;
  ESEtmp=q.*(Kq*q);
  ESE=sum(ESEtmp[i] for i in 1:3);
  Dtmp=q.*(beta*Kq*der(q));
  D=sum(Dtmp[i] for i in 1:3);
  Wtmp=q.*fq;
  E=ESE+D-W;
  W=sum(Wtmp[i] for i in 1:3);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end NaturalTriangle;
