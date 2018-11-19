within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_G1_initializer
  "Initializer for calculating stiffness of G1 springs"
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

  external "C" Cloth_G1_Init(P1, P2, P3, P4, M, N, G_xy, thickness, debug, A) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");

  annotation(Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_G1_initializer;
