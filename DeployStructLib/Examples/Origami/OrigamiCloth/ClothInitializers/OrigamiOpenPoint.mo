within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function OrigamiOpenPoint
  import pi = Modelica.Constants.pi;
  import Modelica.Utilities.Streams.print;
  input Integer i, j, k;
  input Integer M, H, R;
  input Real Rad "Inner polygon radius";
  input Boolean debug = false;
  output Real[3] pt;
protected
  Real[2, 2] Rot;
  Real x, y;
  Real[2] tmp;
algorithm
  if i + 1 >= j then
    x := 0.5 / tan(pi / M) + (i + 1) * cos(pi / 2 + 2 * pi / M) + j * tan(pi / M) * cos(2 * pi / M);
    y := 0.5 + (i + 1) * sin(pi / 2 + 2 * pi / M) + j * tan(pi / M) * sin(2 * pi / M);
  else
    x := 0.5 / tan(pi / M) + j * cos(pi / 2) - (i + 1) * tan(pi / M);
    y := 0.5 + j * sin(pi / 2);
  end if;
  Rot := {{cos(2 * pi * k / M), -sin(2 * pi * k / M)}, {sin(2 * pi * k / M), cos(2 * pi * k / M)}};
  tmp[1] := x;
  tmp[2] := y;
  tmp := Rad * Rot * tmp;
  pt[1] := tmp[1];
  pt[2] := tmp[2];
  pt[3] := 0;
  if debug then
    print("pt: " + String(pt[1]) + "," + String(pt[2]) + "\n");
  end if;
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));	
end OrigamiOpenPoint;

