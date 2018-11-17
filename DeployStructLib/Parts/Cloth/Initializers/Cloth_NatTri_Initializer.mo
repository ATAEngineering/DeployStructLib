within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_NatTri_Initializer "Initializer for Natural Triangle springs, outputs Kq"
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, N;
  input Real E "Elastic modulus";
  input Real G "Shear modulus";
  input Real nu "Poisson's ratio";
  input Real thickness "thickness";
  input Integer index "Which triangle is being created? (BL=1, UL=2, UR=3, BR=4)";
  input SI.Position[3] P1;
  input SI.Position[3] P2;
  input SI.Position[3] P3;
  input SI.Position[3] P4;
  input SI.Position P1_loc[3] = {0, 0, 0} "Relative location of P1_start for initialization reference";
  input Real[3] ref_angles = {0, 0, 0} "Angles to describe orientation of P1 in space";
  input Integer[3] axes_sequence = {1, 2, 3} "Sequence of axes of 'ref_angles' to describe orientation of P1 in space";
  input Boolean debug = false;
  output Real Kq[M, N, 3, 7];

  external "C" Cloth_NatTri_Init(M,N,E,G,nu,thickness,index,P1,P2,P3,P4,P1_loc,ref_angles,axes_sequence,debug,Kq) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");
  annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_NatTri_Initializer;
