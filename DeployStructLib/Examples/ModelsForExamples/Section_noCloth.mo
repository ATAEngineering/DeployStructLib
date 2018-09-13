within DeployStructLib.Examples.ModelsForExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Section_noCloth "Section block with solar blankets removed"
  import Modelica.Mechanics.MultiBody.Frames;
  import DeployStructLib;
  import DeployStructLib.Properties.*;
  import SI = Modelica.SIunits;
  parameter Integer N "Blanket discretization in the y-direction";
  final parameter Integer M = 3 "Blanket discretization in the x-direction";
  final parameter Boolean rigid;
  parameter Real start_angle = 0.0 "Start angle between spars";
  parameter Real base_angle = 0.0 "Initial orientation angle at base of first spar";
  parameter Real yoffset;
  parameter Real alpha;
  parameter Real height;
  parameter Real width;
  parameter Real heightEnd;
  parameter Real widthEnd;
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xInnerPropsData(width = width, height = height);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xMidPropsData(width = width, height = height);
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData;
  parameter Real R0 = 0.0;
  parameter Real R_inner;
  parameter Real R_outer;
  DeployStructLib.Parts.Beam beamInner(L = R_inner - R0, rigid = rigid, xprop = xInnerPropsData, matProp = matPropsData);
  DeployStructLib.Parts.Beam[N - 1] beamMid(each L = (R_outer - R_inner) / N, each rigid = rigid, each xprop = xMidPropsData, each matProp = matPropsData);
  DeployStructLib.Parts.Beam beamOuter(L = R_inner - R0, rigid = rigid, xprop = xInnerPropsData, matProp = matPropsData);
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b[N] frame_side annotation(Placement(visible = true, transformation(origin = {-2.55517, -82.1022}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {0, -98}, extent = {{-16, -16}, {16, 16}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_inner annotation(Placement(visible = true, transformation(origin = {-98.1417, -6.03949}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

equation
  connect(frame_inner, beamInner.frame_a) annotation(Line(points = {{-179.118, -3.83279}, {-164.445, -2.43906}, {-90, 4.4134}, {-90, 0}}));
  //
  connect(beamOuter.frame_a, frame_side[N]);
  for j in 1:N - 1 loop
    connect(frame_side[j], beamMid[j].frame_a);
  end for;
  for j in 1:N - 2 loop
    connect(beamMid[j].frame_b, beamMid[j + 1].frame_a);
  end for;
  connect(beamInner.frame_b, beamMid[1].frame_a);
  connect(beamOuter.frame_a, beamMid[N - 1].frame_b);
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
Model of a section of a fan-fold-style deployable structure, with the blankets between the beams replaced by tension-only springs.
</p>
</html>"));
end Section_noCloth;
