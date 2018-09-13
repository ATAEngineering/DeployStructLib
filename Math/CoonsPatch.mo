within DeployStructLib.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function CoonsPatch
  "Function useful for discretizing a quadrilateral area"
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Real s, t;
  final input Boolean debug = false;
  output Real[3] pos;
algorithm
    pos := P1 * (1 - s) * (1 - t) + P2 * (1 - s) * t + P4 * s * (1 - t) + P3 * s * t;
    if debug then
      print("pos = {" + String(pos[1]) + "," + String(pos[2]) + "," + String(pos[3]) + "}\n");
      print("s=" + String(s) + ", t=" + String(t) + "\n");
    end if;
  annotation(Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>
</HTML>
"));
end CoonsPatch;
