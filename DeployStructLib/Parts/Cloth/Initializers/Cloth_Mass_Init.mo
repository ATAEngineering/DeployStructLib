within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_Mass_Init
  "Initializer for calculating mass of individual, distributed masses in cloth"
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  input Real density;
  input Integer M_act;
  input Boolean debug = false;
  input Boolean isEdge = false;
  input Boolean isEdgeB = false;
  output Real A[M_act, N + 1];

  external "C" Cloth_Mass_Init(P1,P2,P3,P4,M,N,density,M_act,debug,isEdge,isEdgeB,A) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init");
  annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));

end Cloth_Mass_Init;
