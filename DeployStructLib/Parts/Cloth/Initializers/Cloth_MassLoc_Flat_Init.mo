within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_MassLoc_Flat_Init
  "Initializer for calculating location of individual, distributed masses in flat cloth"
  import SI=Modelica.SIunits;
  input Integer M, N;
  input SI.Position[3] P1_start;
  input SI.Position[3] P2_start;
  input SI.Position[3] P3_start;
  input SI.Position[3] P4_start;
  input Integer M_act;
  input Boolean isEdge = false;
  input Boolean isEdgeB = false;
  input Boolean debug = false;
  output Real A[M_act, N + 1, 3];

  external "C" Cloth_MassLoc_Flat_Init(M,N,P1_start,P2_start,P3_start,P4_start,M_act,isEdge,isEdgeB,debug,A) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");
  annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));

end Cloth_MassLoc_Flat_Init;

