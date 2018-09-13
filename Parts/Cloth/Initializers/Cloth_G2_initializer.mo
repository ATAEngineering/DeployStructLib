within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_G2_initializer
  "Initializer for calculating stiffness of G2 springs"
  import Modelica.Math.Vectors;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  input Real G_xy;
  input Real thickness;
  final input Boolean debug = false;
  output Real A[M, N];
protected
  Real[M + 1] s = linspace(0, 1, M + 1);
  Real[N + 1] t = linspace(0, 1, N + 1);
  Real h, w, k;
//  
algorithm
  for j in 1:N loop
    for i in 1:M loop
     h := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[j+1]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[j]));
     w := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i+1], t[j]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[j]));
     k := G_xy * thickness *(2*(h/w)/(1+(h/w)^2));
     A[i, j] := k;
      if debug then
        print("h = " + String(h) + "\n");
        print("w = " + String(w) + "\n");
        print("A[" + String(i) + "," + String(j) + "]=" + String(A[i, j]));
      end if;
    end for;
  end for;
//
  annotation(Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end Cloth_G2_initializer;
