within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_K1_initializer
  "Initializer for calculating stiffness of K1 springs"
  import Modelica.Math.Vectors;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  input Real E_mod;
  input Boolean debug = false;
  output Real A[M, N + 1];
protected
  Real area;
  Real length;
  Real stiffness;
  Real[2 * M + 1] s = linspace(0, 1, 2 * M + 1);
  Real[N + 1] t = linspace(0, 1, N + 1);
algorithm
  // Initialize A to zero
  for j in 1:N + 1 loop
    for i in 1:M loop
      A[i, j] := 0.0;
    end for;
  end for;
  for j in 1:N loop
    for i in 1:M loop
      area := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[2 * i], t[j + 1]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[2 * i], t[j]));
      length := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[2 * i + 1], t[j]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[2 * i - 1], t[j]));
      stiffness := E_mod * area / length/2/2;
      A[i, j] := A[i, j] + stiffness;
      A[i, j + 1] := A[i, j + 1] + stiffness;
      if debug then
        print("area = " + String(area) + "\n");
        print("length = " + String(length) + "\n");
        print("stiffness = " + String(stiffness) + "\n");
        print("k[" + String(i) + "," + String(j) + "] = " + String(A[i,j]) + "\n");
        print("k[" + String(i) + "," + String(j+1) + "] = " + String(A[i,j+1]) + "\n");
      end if;
    end for;
  end for;
  annotation(Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_K1_initializer;
