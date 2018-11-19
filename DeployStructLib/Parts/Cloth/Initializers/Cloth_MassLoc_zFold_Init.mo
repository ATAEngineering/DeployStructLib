within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_MassLoc_zFold_Init
  "Initializer for calculating locations of individual, distributed masses in z-fold cloth"
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, N;
  input SI.Position[3] P1_start;
  input SI.Position[3] P2_start;
  input SI.Position[3] P3_start;
  input SI.Position[3] P4_start;
  input Integer M_act;
  input SI.Length L;
  input Integer folds;
  input Boolean isEdge = false;
  input Boolean isEdgeB = false;
  input Boolean dir_pos;
  input Boolean debug = false;
  output Real A[M_act, N + 1, 3];

  external "C" Cloth_MassLoc_zFold_Init(M,N,P1_start,P2_start,P3_start,P4_start,L,folds,isEdge,isEdgeB,dir_pos,debug,A) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");
  annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));

end Cloth_MassLoc_zFold_Init;
