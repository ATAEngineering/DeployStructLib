within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_NatQuad_Init
  import SI=Modelica.SIunits;
  input Integer M, N;
  input Real E "Elastic modulus";
  input Real G "Shear modulus";
  input Real nu "Poisson's ratio";
  input Real thickness "thickness";
  input SI.Position[3] P1;
  input SI.Position[3] P2;
  input SI.Position[3] P3;
  input SI.Position[3] P4;
  input SI.Position P1_loc[3] = {0, 0, 0} "Relative location of P1_start for initialization reference";
  input Real[3] ref_angles = {0, 0, 0} "Angles to describe orientation of P1 in space";
  input SI.Position[3] P1_start;
  input SI.Position[3] P2_start;
  input SI.Position[3] P3_start;
  input SI.Position[3] P4_start;
  input Boolean debug = false;
  output Real Kq[M, N, 6, 10];

  external "C" Cloth_NatQuad_Init(M,N,E,G,nu,thickness,P1,P2,P3,P4,P1_loc,ref_angles,P1_start,P2_start,P3_start,P4_start,debug,Kq) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");
  annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));

end Cloth_NatQuad_Init;

