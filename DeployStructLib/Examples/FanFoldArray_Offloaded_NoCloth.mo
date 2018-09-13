within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FanFoldArray_Offloaded_NoCloth "Example of offloaded fan-fold array, solar blankets removed"
  extends Modelica.Icons.Example;  
  import DeployStructLib;
  import DeployStructLib.Properties.*;
  final parameter Integer S = 3 "Number of array sections";
  final parameter Integer N = 3 "Blanket discretization in the y-direction";
  final parameter Boolean rigid = false;
  parameter Real total_angle = Modelica.Constants.pi * 2 "Total angle for deployed array to span";
  parameter Real alpha = total_angle / S;
  parameter Real start_angle = 1.0 * Modelica.Constants.pi / 180 "start angle between spars";
  parameter Real height = 0.1;
  parameter Real width = 0.05;
  parameter Real heightEnd = 0.2;
  parameter Real widthEnd = 0.1;
  parameter Real heightPanel = 0.5;
  parameter Real widthPanel = 0.1;
  parameter Real R_outer = 5.0;
  parameter Real R_inner = 0.7;
  parameter Real hub_damping = 0.0;
  //
  parameter Real connDist = 113 * 0.0254;
  parameter Real offloaderHt = 262 * 0.0254;
  parameter Real offloader_c = 8.25 * 39.37 * 4.448;
  parameter Real offloader_mass = 0.0 "massless";
  final parameter Integer offloaderConnFrame = 2 "Spar frame number at which offloader connects";
  //
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData(rho = 2700, E = 69.0e9, alpha = 0.0, beta = 0.01, nu = 0.33);
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, g = 9.81, animateWorld = true, enableAnimation = true) annotation(Placement(visible = true, transformation(origin = {-84, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = true);
  DeployStructLib.Examples.ModelsForExamples.Replicator_noCloth replicator(rigid = rigid, matPropsData = matPropsData, N = N, S = S, height = height, width = width, widthEnd = widthEnd, heightEnd = heightEnd, R_outer = R_outer, R_inner = R_inner, widthPanel = widthPanel, heightPanel = heightPanel, start_angle = start_angle) annotation(Placement(visible = true, transformation(origin = {61.5, -1}, extent = {{-26.25, -22.5}, {26.25, 22.5}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Hub hub(S = S, damping = hub_damping, each phi_start = array(i * start_angle for i in 1:S)) annotation(Placement(visible = true, transformation(origin = {9, 7.10543e-15}, extent = {{-18.0833, -15.5}, {18.0833, 15.5}}, rotation = 0)));
  DeployStructLib.Examples.ModelsForExamples.Offloader offloader(S = S, connDist = connDist, height = offloaderHt, c = offloader_c, mass = offloader_mass) annotation(Placement(visible = true, transformation(origin = {55.5, 65.5714}, extent = {{-25.5833, -21.9286}, {25.5833, 21.9286}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation offloaderAttach(r = {0, 0, offloaderHt}, animation = false) annotation(Placement(visible = true, transformation(origin = {-51.4286, 61}, extent = {{-11.75, -10.0714}, {11.75, 10.0714}}, rotation = 90)));
  //
  parameter Real forcex = 0;
  parameter Real forcey = 60.0;
  parameter Real forcez = 0;
  Modelica.Mechanics.MultiBody.Forces.Force force1 annotation(Placement(visible = true, transformation(origin = {-8, -76}, extent = {{-8.75, -7.5}, {8.75, 7.5}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(Placement(visible = true, transformation(origin = {-44, -68}, extent = {{-7.5, 7.5}, {7.5, -7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f1(height = forcex, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-92, -92}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f2(height = forcey, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-92, -68}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f3(height = forcez, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-92, -44}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  //
equation
  connect(force1.frame_b, replicator.section[S].beamOuter.frame_b) annotation(Line);
  connect(world.frame_b, replicator.beamInnerPanel.frame_a) annotation(Line);
  connect(offloaderAttach.frame_b, offloader.frame_Top) annotation(Line(points = {{-51, 73}, {-53.75, 73}, {-53.75, 84}, {56, 84}}, color = {0, 0, 127}));
  connect(force1.frame_a, world.frame_b) annotation(Line(points = {{-17, -76}, {-17, -33}, {-35, -33}, {-35, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(offloaderAttach.frame_a, world.frame_b) annotation(Line(points = {{-51, 49}, {-53.5, 49}, {-53.5, 0}, {-74, 0}}, color = {0, 0, 127}));
  connect(f3.y, multiplex31.u3[1]) annotation(Line(points = {{-84, -44}, {-84, -43.5}, {-64, -43.5}, {-64, -45}, {-63.5, -45}, {-63.5, -63}, {-53, -63}}, color = {0, 0, 127}));
  connect(multiplex31.y, force1.force) annotation(Line(points = {{-36, -68}, {-36, -66.5}, {-14, -66.5}, {-14, -67}, {-13, -67}}, color = {0, 0, 127}));
  connect(f2.y, multiplex31.u2[1]) annotation(Line(points = {{-84, -68}, {-53, -68}}, color = {0, 0, 127}));
  connect(f1.y, multiplex31.u1[1]) annotation(Line(points = {{-84, -92}, {-84, -91.5}, {-64, -91.5}, {-64, -73}, {-53, -73}}, color = {0, 0, 127}));
  for j in 1:S loop
    connect(hub.revolute[j].frame_b, replicator.section[j].frame_inner);
    connect(offloader.strings[j].frame_sideSpar, replicator.section[j].frame_side[offloaderConnFrame]);
  end for;
//
  annotation(experiment(StartTime = 0, StopTime = 3.0, Tolerance = 1e-5, Interval = 0.1), Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This example demonstrates the use of a <b>Replicator</b> block and <b>Hub</b> to model a fan-fold style array. The solar blankets have been removed and replaced by strings (modeled as <b>TensionSprings</b>). The array is deployed by a force attached to the front spar. The array is offloaded by a basic <b>Offloader</b> block.
  </html>"));
end FanFoldArray_Offloaded_NoCloth;
