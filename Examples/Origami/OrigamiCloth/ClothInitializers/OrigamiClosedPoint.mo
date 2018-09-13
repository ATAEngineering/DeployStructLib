within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

package OrigamiClosedPoint
function OrigamiClosedPoint
  import pi = Modelica.Constants.pi;
  input Integer i, j, k;
  input Integer M, H, R;
  input Real Rad "Inner polygon radius";
  input Boolean debug = false;
  output Real[3] pt;
protected
  Real[3, 3] Rot;
  Real x, y, z;
algorithm
  x := 0.5 / tan(pi / M);
  y := 0.5;
  z := ht(i,j,H)*tan(pi/M);
  Rot := calcRot(k+rot(i,j), M);
  pt[1] := x;
  pt[2] := y;
  pt[3] := z;
  pt := Rad * Rot * pt;
  if debug then
    print("pt: " + String(pt[1]) + "," + String(pt[2]) + "," + String(pt[3]) + "\n");
  end if;
end OrigamiClosedPoint;

function rot
  input Integer i,j;
  output Integer ret;
algorithm
  if j <= i+1 then
    ret := i+1;
  else
    ret := j;
  end if;
end rot;

function ht
  input Integer i,j;
  input Integer H;
  output Integer ret;
algorithm
  ret:=mod(min(i+1,j)-H,2*H)-H;
  if ret < 0 then
    ret := -ret;
  end if;
end ht;

function calcRot
  import pi = Modelica.Constants.pi;
  input Integer k;
  input Integer M;
  output Real[3,3] Rot;
algorithm
  Rot := {{cos(2 * pi * k / M), -sin(2 * pi * k / M), 0}, {sin(2 * pi * k / M), cos(2 * pi * k / M), 0},{0,0,1}};
end calcRot;
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end OrigamiClosedPoint;
