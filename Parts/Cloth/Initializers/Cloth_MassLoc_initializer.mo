within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

encapsulated function Cloth_MassLoc_initializer
  "Initializer for calculating location of individual, distributed masses in cloth"
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  input Real[3] P1;
  input Real[3] P2;
  input Real[3] P3;
  input Real[3] P4;
  input Integer M, N;
  input Real start_angle;
  input Real[3] P_ref "Absolute location of P1 in space";
  input Frames.Orientation P_R "Absolute orientation of P1 in space";
  final input Boolean debug = true;
  output Real A[M, N, 3];

  protected
  Real T[3,3] = P_R.T;
  Real w[3] = P_R.w;

  external "C" Cloth_MassLoc_Init(P1,P2,P3,P4,M,N,start_angle,P_ref,T,w,A,debug) annotation(Include = "#include \"cloth_init.h\" ", Library="cloth_init");

  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>
</html>"));
end Cloth_MassLoc_initializer;

