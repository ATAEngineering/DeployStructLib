within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_K2_initializer
  "Initializer for calculating stiffness of K2 springs"
  import Modelica.Math.Vectors;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  input Real E_mod;
  output Real A[M + 1, N];
protected
  Real area;
  Real length;
  Real stiffness;
  Real[M + 1] s = linspace(0, 1, M + 1);
  Real[2 * N + 1] t = linspace(0, 1, 2 * N + 1);
algorithm
  // Initialize A to zero
  for j in 1:N loop
    for i in 1:M + 1 loop
      A[i, j] := 0.0;
    end for;
  end for;
  for i in 1:M loop
    for j in 1:N loop
      area := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i + 1], t[2 * j]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[2 * j]));
      length := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[2 * j + 1]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[2 * j - 1]));
      stiffness := E_mod * area / length/2/2;
      A[i, j] := A[i, j] + stiffness;
      A[i + 1, j] := A[i + 1, j] + stiffness;
    end for;
  end for;
  annotation(Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end Cloth_K2_initializer;
