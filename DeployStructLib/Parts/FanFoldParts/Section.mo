within DeployStructLib.Parts.FanFoldParts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Section "Basic building block of a fan-fold-style deployable structure"
  import Modelica.Mechanics.MultiBody.Frames;
  import DeployStructLib;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.ClothProperty.*;
  import SI = Modelica.SIunits;
  parameter Integer N "Blanket discretization in the y-direction";
  parameter Integer M = 3 "Blanket discretization in the x-direction";
  parameter Boolean rigid;
  parameter Real start_angle = 0.0 "Start angle between spars";
  parameter Real span_angle "Undeformed angle (in degrees) that blanket spans, for sizing";
  parameter Real[3] R0_loc = {0, 0, 0} "Location of blanket center of radius at initialization";
  parameter Real[3] R0_angles = {0, 0, 0} "Angles of blanket center of radius at initialization";
  parameter Integer[3] axes_sequence = {1, 2, 3} "Sequence of axes of 'ref_angles' to describe orientation of P1 in space" annotation(Evaluate = true);
//
  parameter Real height;
  parameter Real width;
  parameter Real heightEnd;
  parameter Real widthEnd;
//
  parameter DeployStructLib.Properties.ClothProperty clothPropsData;
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xInnerPropsData(width = width, height = height);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xMidPropsData(width = width, height = height);
//
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData;
  parameter Real R0 = 0.0;
  parameter Real R_inner;
  parameter Real R_outer;
//
  // Calculated parameters
  //
  parameter Real span_angle_rad = span_angle * Modelica.Constants.pi / 180 "Undeformed angle that blanket spans, for sizing";
  parameter Real start_angle_rad = start_angle * Modelica.Constants.pi / 180 "Start angle between section spars at initialization";
  parameter Real[3] R0_angles_rad = R0_angles * Modelica.Constants.pi / 180 "Angles of blanket center of radius at initialization";
//
  parameter Real rotate_angle = -acos((1 + cos(span_angle_rad)) / sin(span_angle_rad) * tan(start_angle_rad / 2)) "Blanket rotation angle about spar for initialization";
  parameter SI.Position P1[3] = {R_inner, 0, 0};
  parameter SI.Position P2[3] = {R_outer, 0, 0};
  parameter SI.Position P3A[3] = 0.5 * R_outer * {1 + cos(span_angle_rad), sin(span_angle_rad), 0};
  parameter SI.Position P4A[3] = 0.5 * R_inner * {1 + cos(span_angle_rad), sin(span_angle_rad), 0};
  parameter SI.Position P3B[3] = 0.5 * R_outer * {1 + cos(-span_angle_rad), sin(-span_angle_rad), 0};
  parameter SI.Position P4B[3] = 0.5 * R_inner * {1 + cos(-span_angle_rad), sin(-span_angle_rad), 0};
  parameter SI.Position P1_startA[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), {R_inner, 0, 0}) "Initial location of P1 in world coordinates";
  parameter SI.Position P2_startA[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), {R_outer, 0, 0}) "Initial location of P1 in world coordinates";
  parameter SI.Position P3_start[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), {0.5 * R_outer * (1 + cos(span_angle_rad)), 0.5 * R_outer * sin(span_angle_rad) * cos(rotate_angle), 0.5 * R_outer * sin(span_angle_rad) * sin(rotate_angle)}) "Initial location of P3 in world coordinates";
  parameter SI.Position P4_start[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), {0.5 * R_inner * (1 + cos(span_angle_rad)), 0.5 * R_inner * sin(span_angle_rad) * cos(rotate_angle), 0.5 * R_inner * sin(span_angle_rad) * sin(rotate_angle)}) "Initial location of P4 in world coordinates";
  parameter SI.Position P1_startB[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), R_inner * {cos(start_angle_rad), sin(start_angle_rad), 0}) "Initial location of P1 in world coordinates";
  parameter SI.Position P2_startB[3] = R0_loc + Frames.resolve1(Frames.axesRotations(axes_sequence, R0_angles_rad, zeros(3)), R_outer * {cos(start_angle_rad), sin(start_angle_rad), 0}) "Initial location of P2 in world coordinates";
  //
  DeployStructLib.Parts.Cloth.cloth blanketA(M = M, N = N, P1 = P1, P2 = P2, P3 = P3A, P4 = P4A, P1_start = P1_startA, P2_start = P2_startA, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = {0, 0, 0}, ref_angles = {0, 0, 0}, useSideBFrame=false);
  DeployStructLib.Parts.Cloth.cloth blanketB(M = M, N = N, P1 = P1, P2 = P2, P3 = P3B, P4 = P4B, P1_start = P1_startB, P2_start = P2_startB, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = {0, 0, 0}, ref_angles = {0, 0, 0}, useSideBFrame=false);
  //
  Beam beamInner(L = R_inner, rigid = rigid, xprop = xInnerPropsData, matProp = matPropsData);
  Beam[N] beamMid(each L = (R_outer - R_inner) / N, each rigid = rigid, each xprop = xMidPropsData, each matProp = matPropsData);
//
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_inner annotation(Placement(visible = true, transformation(origin = {-98.1417, -6.03949}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_outer annotation(Placement(visible = true, transformation(origin = {98.1417, -6.03949}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b[N+1] frame_blanket annotation(Placement(visible = true, transformation(origin = {-0.696864, 96}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b[N+1] frame_side annotation(Placement(visible = true, transformation(origin = {-2.55517, -82.1022}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
//
//
protected
  outer Modelica.Mechanics.MultiBody.World world;
//
equation

  for j in 1:N+1 loop
    connect(frame_blanket[j], blanketB.sideA[j]);
  end for;

  connect(frame_inner, beamInner.frame_a); 
  connect(frame_outer, beamMid[N].frame_b);
  //
  connect(blanketA.sideA[N+1], beamMid[N].frame_b);
  connect(beamMid[N].frame_b, frame_side[N+1]);
  for j in 1:N loop
    connect(blanketA.sideA[j], beamMid[j].frame_a);
    connect(frame_side[j], beamMid[j].frame_a);
    connect(blanketB.sideBloc[j], blanketA.sideBloc[j]);
  end for;
  for j in 1:N - 1 loop
    connect(beamMid[j].frame_b, beamMid[j + 1].frame_a);
  end for;
  connect(beamInner.frame_b, beamMid[1].frame_a);
  connect(blanketB.sideBloc[N + 1], blanketA.sideBloc[N + 1]);

  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Text(origin = {-54.5829, 81.9869}, extent = {{-41.55, 15.91}, {133.042, -18.7829}}, textString = "Panel Section"), Polygon(origin = {15.58, -2.01}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Cross, points = {{-81.6575, 10.6285}, {81.6575, 63.2252}, {81.6575, -63.1836}, {-81.6575, -24.0676}, {-81.6575, 10.6285}})}), Documentation(info = "<html>
  <p>
  The <b>Section</b> block is the basic building block of a fan fold array. It includes one spar (created from <b>Beam</b> blocks) and one blanket, which can then be connected to another <b>Section</b> block or another spar. 
  </p>
  <p>
  The <b>Section</b> block requires several parameters. These parameters include the discretization for the blanket (\"M\" and \"N\"), whether the spar should be rigid or flexible. It also requires the dimensions of the spar (the widths and heights at each end) as well as the material properties of the spar, and a <b>ClothProperty</b> block that passes the material properties of the cloth to the internal <b>Cloth</b> block. Two of the parameters, \"R_inner,\" and \"R_outer\", set up the size the array by setting the inner and outer diametrical dimensions of the annulus-shaped blanket. These in turn dictate the values of the \"P1,\" \"P2,\" \"P3,\" and \"P4\" parameters that determine the fabric shape within the internal <b>Cloth</b> block. Starting positions for the <b>Cloth</b> are also dictated by start parameters defined within the Section block. 
  </p>
  <p>
  Use an <b>DeployStructLib.Parts.Replicator</b> to create and connect multiple <b>Section</b> blocks.
  </p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

 </html>"));
end Section;
