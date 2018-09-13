within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FanFoldArray_Offloaded "Example of offloaded fan-fold array"
  extends Modelica.Icons.Example;
  import DeployStructLib;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.ClothProperty.*;
  final parameter Integer S = 3 "Number of array sections";
  final parameter Integer N = 2 "Blanket discretization in the y-direction";
  final parameter Integer M = 2 "Blanket discretization in the x-direction";
  final parameter Boolean rigid = true;
  parameter Real total_angle = 180 "Total angle for deployed array to span";
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
  parameter Real connDist = 2.87;
  parameter Real offloaderHeight = 6.65;
  parameter Real offloader_c = 8.25 * 39.37 * 4.448;
  parameter Real offloader_mass = 1e-3 "massless";
  final parameter Integer offloaderConnFrame = 2 "Spar frame number at which offloader connects";
  //
  parameter DeployStructLib.Properties.ClothProperty clothPropsData(thickness = 0.0002, E = 300000000.0, G = 200000.0, alpha = 1.0, nu = 0.33, area_density = 1.2);
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData(rho = 2700, E = 130.0e9, alpha = 0.0, beta = 0.01, nu = 0.33);
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, g = 9.81, animateWorld = true, enableAnimation = true) annotation(Placement(visible = true, transformation(origin = {-82, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = true);
  DeployStructLib.Parts.FanFoldParts.Replicator replicator(rigid = rigid, clothPropsData = clothPropsData, matPropsData = matPropsData, M = M, N = N, S = S, height = height, width = width, widthEnd = widthEnd, heightEnd = heightEnd, R_outer = R_outer, R_inner = R_inner, widthPanel = widthPanel, heightPanel = heightPanel, start_angle = start_angle, span_angle = alpha) annotation(Placement(visible = true, transformation(origin = {54, 14}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Hub hub(S = S, damping = hub_damping, phi_start = array((S - i + 1) * start_angle for i in 1:S)) annotation(Placement(visible = true, transformation(origin = {6, 14}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  DeployStructLib.Examples.ModelsForExamples.Offloader offloader(S = S, connDist = connDist, height = offloaderHeight, c = offloader_c, mass = offloader_mass) annotation(Placement(visible = true, transformation(origin = {24, 72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedTranslation offloaderAttach(r = {0, 0, offloaderHeight}, animation = false) annotation(Placement(visible = true, transformation(origin = {-48, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  //
  parameter Real forcex = 0;
  parameter Real forcey = 60.0;
  parameter Real forcez = 0;
  Modelica.Mechanics.MultiBody.Forces.Force force1 annotation(Placement(visible = true, transformation(origin = {-14, -32}, extent = {{-8.75, 7.5}, {8.75, -7.5}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(Placement(visible = true, transformation(origin = {-42, -40}, extent = {{-7.5, 7.5}, {7.5, -7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f1(height = forcex, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-90, -62}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f2(height = forcey, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f3(height = forcez, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-90, -16}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  //
equation
  connect(force1.frame_b, replicator.section[1].beamMid[N].frame_b) annotation(Line);
  connect(world.frame_b, replicator.beamInnerPanel.frame_a) annotation(Line);
  connect(offloaderAttach.frame_b, offloader.frame_Top) annotation(Line(points = {{-48, 66}, {-48, 89}, {24, 89}}, color = {0, 0, 127}));
  connect(f3.y, multiplex31.u3[1]) annotation(Line(points = {{-82, -16}, {-82, -18.2696}, {-59.75, -18.2696}, {-59.75, -35}, {-51, -35}}, color = {0, 0, 127}));
  connect(offloaderAttach.frame_a, world.frame_b) annotation(Line(points = {{-48, 46}, {-48, 22}, {-72, 22}}, color = {0, 0, 127}));
  connect(f2.y, multiplex31.u2[1]) annotation(Line(points = {{-81.75, -40}, {-51, -40}}, color = {0, 0, 127}));
  connect(f1.y, multiplex31.u1[1]) annotation(Line(points = {{-81.75, -62}, {-81.75, -57.2892}, {-60.3261, -57.2892}, {-60.3261, -45}, {-51, -45}}, color = {0, 0, 127}));
  connect(multiplex31.y, force1.force) annotation(Line(points = {{-34, -40}, {-34, -41}, {-18.75, -41}}, color = {0, 0, 127}));
  connect(force1.frame_a, world.frame_b) annotation(Line(points = {{-23, -32}, {-23, 22}, {-72, 22}}, color = {0, 0, 127}));
  for j in 1:S loop
    connect(hub.revolute[j].frame_b, replicator.section[j].frame_inner);
    connect(offloader.strings[j].frame_sideSpar, replicator.section[j].frame_side[offloaderConnFrame]);
  end for;
  annotation(experiment(StartTime = 0, StopTime = 3.0, Tolerance = 1e-5, Interval = 0.01), Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This example demonstrates the use of a <b>Replicator</b> block and <b>Hub</b> to model a fan-fold style array. The array is deployed by a force attached to the front spar. The array is offloaded by a basic <b>Offloader</b> block.
  </html>"), Diagram(coordinateSystem(grid = {0, 0}, initialScale = 0.1)));
end FanFoldArray_Offloaded;
