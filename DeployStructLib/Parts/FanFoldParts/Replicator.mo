within DeployStructLib.Parts.FanFoldParts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Replicator "Connects several Section blocks to form a fan-fold-style deployable structure"
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;
  import DeployStructLib;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.ClothProperty.*;
  parameter Integer S "Number of array sections";
  parameter Integer N "Blanket discretization in the y-direction";
  parameter Integer M = 3 "Blanket discretization in the x-direction";
  parameter Boolean rigid "Should spars be modeled as rigid?";
  parameter SI.Angle start_angle = 0.0 "start angle between spars";
  parameter SI.Angle span_angle "Undeformed angle (in degrees) that blanket spans, for sizing";
  parameter Real[3] R0_loc = {0, 0, 0} "Location of blanket center of radius at initialization";
  parameter Real[3] R0_angles = {0, 0, 0} "Angles of blanket center of radius at initialization";
  parameter SI.Length height "Spar height at inner-most frame";
  parameter SI.Length width "Spar width at inner-most frame";
  parameter SI.Length heightEnd "Spar height at outer-most frame";
  parameter SI.Length widthEnd "Spar width at outer-most frame";
  parameter SI.Length heightPanel "Panel height";
  parameter SI.Length widthPanel "Panel width";
  //
  parameter DeployStructLib.Properties.ClothProperty clothPropsData;
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData;
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xInnerPanelPropsData(width = widthPanel, height = heightPanel);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xMidPanelPropsData(width = widthPanel, height = heightPanel);
  //
  parameter SI.Distance R0 = 0.0 "Distance from center of radius to start of spar";
  parameter SI.Distance R_inner "Distance from start of spar to start of cloth";
  parameter SI.Distance R_outer "Distance from center of radius to end of spar";
  parameter Real[S, 3] R0_angles_section = array({0, 0, -(i - 1) * start_angle} + R0_angles for i in 1:S);
  //
  Section[S] section(each rigid = rigid, each N = N, each M = M, each R_inner = R_inner, each R_outer = R_outer, each R0_loc = R0_loc, R0_angles = R0_angles_section, each clothPropsData = clothPropsData, each matPropsData = matPropsData, each width = width, each height = height, each widthEnd = widthEnd, each heightEnd = heightEnd, each start_angle = -start_angle, each span_angle = span_angle);
  //
  Beam beamInnerPanel(L = R_inner, rigid = rigid, xprop = xInnerPanelPropsData, matProp = matPropsData);
  Beam[N] beamMidPanel(each L = (R_outer - R_inner) / N, each rigid = rigid, each xprop = xMidPanelPropsData, each matProp = matPropsData);
  //
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b pulleyFrame;
equation
  connect(beamMidPanel[N].frame_b, section[S].frame_blanket[N + 1]);
  for i in 1:N loop
    connect(section[S].frame_blanket[i], beamMidPanel[i].frame_a);
  end for;
//
  for j in 1:S - 1 loop
    for i in 1:N + 1 loop
      connect(section[j + 1].frame_side[i], section[j].frame_blanket[i]);
    end for;
  end for;
  for i in 1:N - 1 loop
    connect(beamMidPanel[i].frame_b, beamMidPanel[i + 1].frame_a);
  end for;
//
  connect(beamInnerPanel.frame_b, beamMidPanel[1].frame_a);
  connect(pulleyFrame, beamMidPanel[N].frame_b);
//
  annotation(Icon(coordinateSystem(initialScale = 0.1), graphics = {Polygon(origin = {-0.331819, 25.1767}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Cross, points = {{-81.6575, 10.6285}, {81.6575, 63.2252}, {84.0885, -26.0566}, {-80.7735, -13.0179}, {-81.6575, 10.6285}}), Line(origin = {3.31, 66.85}, points = {{-89.7238, -28.8397}, {87.2928, 28.6187}}, thickness = 5), Line(origin = {15.5771, 9.95199}, points = {{-99.8895, -1.65743}, {76.6851, -17.3482}}, thickness = 5), Polygon(origin = {-0.444863, -7.4263}, fillColor = {85, 85, 255}, fillPattern = FillPattern.Cross, points = {{-81.4365, 11.2915}, {83.8674, -4.6201}, {69.0608, -78.2112}, {-86.5194, -15.4488}, {-81.4365, 11.2915}}), Line(origin = {-1.44099, -34.913}, points = {{-94.1437, 8.28733}, {77.127, -61.7681}}, thickness = 10), Text(origin = {-10.84, -114.94}, extent = {{-77.35, 43.98}, {-30.62, 29.32}}, textString = "%name", fontName = "MS Shell Dlg 2")}), Documentation(info = "<html>
  <p>
  The <b>Replicator</b> block creates and connects <i>S</i> <b>Section</b> blocks. It also attaches a spar (termed a \"panel\")  to the free blanket of the last <b>Section</b> block. This block requires all of the same parameters as the <b>Section</b> block, as well as \"S\" and dimensions and material properties for the \"panel\".
  </p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

 </html>"));
end Replicator;
