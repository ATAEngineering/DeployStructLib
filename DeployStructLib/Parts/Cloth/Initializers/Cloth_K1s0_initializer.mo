within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_K1s0_initializer
  "Initializer for calculating length of K1s0 springs"
  import Modelica.Math.Vectors;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  output Real A[M, N + 1];
protected
  Real length;
  Real[M + 1] s = linspace(0, 1, M + 1);
  Real[N + 1] t = linspace(0, 1, N + 1);
algorithm
  for j in 1:N + 1 loop
    for i in 1:M loop
      length := Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i + 1], t[j]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[i], t[j]));
      A[i, j] := length;
    end for;
  end for;
  annotation(Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end Cloth_K1s0_initializer;
