within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_G1_bend_initializer
  "Initializer for calculating stiffness of G1_bend springs"
  import Modelica.Math.Vectors;
  import Modelica.Utilities.Streams.print;
  input Real[3] P1, P2, P3, P4;
  input Integer M, N;
  input Integer[:] M_ind;
  input Integer[:] N_ind;
  input Real D;
  input Boolean debug = false;
  input Integer size_M_ind = size(M_ind, 1);
  input Integer size_N_ind = size(N_ind, 1);
  output Real[size(M_ind,1), size(N_ind,1)] k;

  external "C" Cloth_G1_bend_Init(P1,P2,P3,P4,M,N,M_ind,size_M_ind,N_ind,size_N_ind,D,debug,k) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init", __iti_dll="ITI_cloth_init.dll");

  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_G1_bend_initializer;
