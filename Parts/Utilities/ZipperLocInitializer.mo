within DeployStructLib.Parts.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function ZipperLocInitializer "Calculates the initial position and orientation angle of a free-floating beam"
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
  input Real[3] P_ref "Center of arc in which P1, P2, etc. are defined";
  input Frames.Orientation P_R "Absolute orientation of P_ref in space";
  final input Boolean debug = false;
  output Real[3, 3] B;
protected
  Frames.Orientation zipperR;
  Real[3] P3_start;
  Real[3] P4_start;
  Real[3] tmpvec1;
  Real[3] tmpvec2;
  Real[3] P5, P6;
  Real a, h, d, x, y, P5angle, P6angle, asdf;
  Real d5, d6;
  Real[3] zipperStart;
  Real[3] zipper_xdir;
  Real[3] zipper_ydir;
  Real[2 * N + 1] t = linspace(0, 1, 2 * N + 1);
algorithm
  if debug then
    print("P1={" + String(P1[1]) + "," + String(P1[2]) + "," + String(P1[3]) + "}\n");
    print("P2={" + String(P2[1]) + "," + String(P2[2]) + "," + String(P2[3]) + "}\n");
    print("P3={" + String(P3[1]) + "," + String(P3[2]) + "," + String(P3[3]) + "}\n");
    print("P4={" + String(P4[1]) + "," + String(P4[2]) + "," + String(P4[3]) + "}\n");
  end if;
  // Find P3_start and P4_start
  P4_start := Vectors.norm(P1 - P_ref) * {cos(start_angle), sin(start_angle), 0};
  P3_start := Vectors.norm(P2 - P_ref) * {cos(start_angle), sin(start_angle), 0};
  if debug then
    print("P4_start={" + String(P4_start[1]) + "," + String(P4_start[2]) + "," + String(P4_start[3]) + "}\n");
    print("P3_start={" + String(P3_start[1]) + "," + String(P3_start[2]) + "," + String(P3_start[3]) + "}\n");
  end if;
  // Find P5 and P6
  P5 := 0.5 * (P1 + P4);
  P6 := 0.5 * (P2 + P3);
  if debug then
    print("P5={" + String(P5[1]) + "," + String(P5[2]) + "," + String(P5[3]) + "}\n");
    print("P6={" + String(P6[1]) + "," + String(P6[2]) + "," + String(P6[3]) + "}\n");
  end if;
  tmpvec1 := P5 - P1 - (P5 - P1) .* {1, 0, 0};
  d5 := Vectors.norm(tmpvec1);
  tmpvec2 := P6 - P2 - (P6 - P2) .* {1, 0, 0};
  d6 := Vectors.norm(tmpvec2);
  if debug then
    print("tmpvec1={" + String(tmpvec1[1]) + "," + String(tmpvec1[2]) + "," + String(tmpvec1[3]) + "}\n");
    print("tmpvec2={" + String(tmpvec2[1]) + "," + String(tmpvec2[2]) + "," + String(tmpvec2[3]) + "}\n");
    print("d5=" + String(d5) + "\n");
    print("d6=" + String(d6) + "\n");
  end if;
  //
  P5[2] := P5[1] * tan(start_angle / 2);
  P6[2] := P6[1] * tan(start_angle / 2);
  P5[3] := if noEvent(d5 ^ 2 - P5[2] ^ 2 > 0.0) then -sqrt(d5 ^ 2 - P5[2] ^ 2) else 0.0;
  P6[3] := if noEvent(d6 ^ 2 - P6[2] ^ 2 > 0.0) then -sqrt(d6 ^ 2 - P6[2] ^ 2) else 0.0;
  if debug then
    print("P5={" + String(P5[1]) + "," + String(P5[2]) + "," + String(P5[3]) + "}\n");
    print("P6={" + String(P6[1]) + "," + String(P6[2]) + "," + String(P6[3]) + "}\n");
  end if;
  P5 := Frames.resolve1(P_R, P_ref + P5);
  P6 := Frames.resolve1(P_R, P_ref + P6);
  if debug then
    print("P_R.T[1,1]=" + String(P_R.T[1, 1]) + "\n");
    print("P5new={" + String(P5[1]) + "," + String(P5[2]) + "," + String(P5[3]) + "}\n");
    print("P6new={" + String(P6[1]) + "," + String(P6[2]) + "," + String(P6[3]) + "}\n");
  end if;
  B[1, :] := P5;
  B[2, :] := P6;
  zipperStart := P5 + {t[2] * (P6[1] - P5[1]), 0, 0};
  //
  zipper_xdir := P6 - P5;
  zipper_ydir := P4_start - P1;
  zipperR := Frames.from_nxy(zipper_xdir, zipper_ydir);
  B[3, :] := Frames.axesRotationsAngles(zipperR, {1, 2, 3});
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info = "<HTML>
<p>
A function to calculate the initial position and orientation angle of a free-floating beam. The beam is assumed to hang at the bottom intersection  between two cloths. The function takes in the four points that would be used to define a \"bent cloth\" of the same configuration and uses the algorithm developed to calculate the positions of the outside bottom points of a hanging cloth (see <b>cloth_bend</b> documentation). These points are taken to be the end points of the beam. The orientation angles are calculated from these end points.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end ZipperLocInitializer;
