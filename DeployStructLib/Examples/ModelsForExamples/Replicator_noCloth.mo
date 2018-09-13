within DeployStructLib.Examples.ModelsForExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Replicator_noCloth "Replicator block with solar blankets removed"
  import Modelica.Mechanics.MultiBody.Frames;
  import DeployStructLib;
  import DeployStructLib.Properties.*;
  final parameter Integer S "Number of array sections";
  final parameter Integer N "Blanket discretization in the y-direction";
  final parameter Boolean rigid;
  parameter Real[S] yoffset;
  parameter Real start_angle = 0.0 "start angle between spars";
  parameter Real alpha;
  parameter Real height;
  parameter Real width;
  parameter Real heightEnd;
  parameter Real widthEnd;
  parameter Real heightPanel;
  parameter Real widthPanel;
  //
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData;
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xInnerPanelPropsData(width = widthPanel, height = heightPanel * 0.1);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xMidPanelPropsData(width = widthPanel, height = heightPanel * 0.1);
  //
  parameter Real R0 = 0.0;
  parameter Real R_inner;
  parameter Real R_outer;
  parameter Real[S, 3] P1_ref = zeros(S, 3);
  parameter Frames.Orientation[S] P1_R = array(Frames.axisRotation(3, i * start_angle, 0.0) for i in 0:S - 1);
  //
  Section_noCloth[S] section(each rigid = rigid, each N = N, each R_inner = R_inner, each R_outer = R_outer, each matPropsData = matPropsData, each width = width, each height = height, each widthEnd = widthEnd, each heightEnd = heightEnd, each alpha = alpha);
  //
  DeployStructLib.Parts.Beam beamInnerPanel(L = R_inner - R0, rigid = rigid, xprop = xInnerPanelPropsData, matProp = matPropsData);
  DeployStructLib.Parts.Beam[N - 1] beamMidPanel(each L = (R_outer - R_inner) / N, each rigid = rigid, each xprop = xMidPanelPropsData, each matProp = matPropsData);
  DeployStructLib.Parts.Beam beamOuterPanel(L = R_inner - R0, rigid = rigid, xprop = xInnerPanelPropsData, matProp = matPropsData);
  //
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b pulleyFrame;
equation
  for i in 1:N - 2 loop
    connect(beamMidPanel[i].frame_b, beamMidPanel[i + 1].frame_a);
  end for;
  connect(beamOuterPanel.frame_a, beamMidPanel[N - 1].frame_b);
//-----------------
  connect(beamInnerPanel.frame_b, beamMidPanel[1].frame_a);
  connect(pulleyFrame, section[S].beamOuter.frame_b);
  annotation(Icon(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-6.84, -110.94}, extent = {{-77.35, 43.98}, {-38.62, 33.32}}, textString = "%name", fontName = "MS Shell Dlg 2"), Line(origin = {3.31, 66.85}, points = {{-89.7238, -28.8397}, {87.2928, 28.6187}}, thickness = 5), Line(origin = {71.8211, 26.412}, points = {{-2.65193, 56.0227}, {-3.31491, 35.9122}, {9.28177, 24.6415}, {-13.0387, 16.9067}, {9.50272, 9.61388}, {-2.43094, 0.111158}, {-2.65193, -22.4304}}, thickness = 3), Line(origin = {15.5771, 9.95199}, points = {{-99.8895, -1.65743}, {76.6851, -17.3482}}, thickness = 5), Line(origin = {66.8491, -57.235}, points = {{5.08288, 43.868}, {1.54696, 28.8404}, {9.72376, 19.5587}, {-14.1437, 16.2437}, {5.30382, 2.76306}, {-5.96685, 1.21613}, {-9.94475, -16.0215}}, thickness = 3), Line(origin = {-1.44099, -34.913}, points = {{-94.1437, 8.28733}, {77.127, -61.7681}}, thickness = 10)}), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This model replicates sections of a fan-fold deployable structure, with strings between the beams instead of blankets.
</p>
</html>"));
end Replicator_noCloth;
