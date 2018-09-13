within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_G1s0_initializer
  "Initializer for calculating length of G1s0 springs"
  import Modelica.Math.Vectors;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  final input Boolean debug = true;
  output Real A[M, N];

  external "C" Cloth_G1s0_Init(P1, P2, P3, P4, M, N, debug, A) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init");
//
  annotation(Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end Cloth_G1s0_initializer;
