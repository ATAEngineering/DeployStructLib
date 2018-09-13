within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FanFoldArrayDemo "Example model of fan-fold array"
  extends Modelica.Icons.Example;    
  import DeployStructLib;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.ClothProperty.*;
  final parameter Integer S = 5 "Number of array sections";
  final parameter Integer N = 2 "Blanket discretization in the y-direction";
  final parameter Integer M = 2 "Blanket discretization in the y-direction";
  final parameter Boolean rigid = true;
  parameter Real total_angle = 359.99 "Total angle for deployed array to span";
  parameter Real span_angle = total_angle / S;
  parameter Real start_angle = 5.0 "start angle between spars";
  parameter Real start_angle_rad = start_angle * Modelica.Constants.pi / 180;
  parameter Real[3] R0_loc = {0, 0, 0} "Location of blanket center of radius at initialization";
  parameter Real[3] R0_angles = {0, 0, S * start_angle} "Angles of blanket center of radius at initialization";
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
  parameter DeployStructLib.Properties.ClothProperty clothPropsData(thickness = 0.00015, E = 3.2e9, nu = 0.01, area_density = 1.0, beta = 0.01) annotation(Placement(visible = true, transformation(origin = {77, -67}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData(rho = 2700, E = 69.0e9, alpha = 0.0, beta = 0.01, nu = 0.33) annotation(Placement(visible = true, transformation(origin = {51, -89}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, g = 9.81, animateWorld = true, enableAnimation = true) annotation(Placement(visible = true, transformation(origin = {-72, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false) annotation(Placement(visible = true, transformation(origin = {77, -89}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Replicator replicator(rigid = rigid, clothPropsData = clothPropsData, matPropsData = matPropsData, M = M, N = N, S = S, height = height, width = width, widthEnd = widthEnd, heightEnd = heightEnd, R_outer = R_outer, R_inner = R_inner, widthPanel = widthPanel, heightPanel = heightPanel, start_angle = start_angle, span_angle = span_angle, R0_loc = R0_loc, R0_angles = R0_angles) annotation(Placement(visible = true, transformation(origin = {45, 11}, extent = {{-36.5, -36.5}, {36.5, 36.5}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Hub hub(S = S, damping = hub_damping, phi_start = array((S - i + 1) * start_angle_rad for i in 1:S)) annotation(Placement(visible = true, transformation(origin = {-25, 13}, extent = {{-18.5, -18.5}, {18.5, 18.5}}, rotation = 0)));
  //
  parameter Real forcex = 0;
  parameter Real forcey = 20.0;
  parameter Real forcez = 0;
  Modelica.Mechanics.MultiBody.Forces.Force force1 annotation(Placement(visible = true, transformation(origin = {-4, -68}, extent = {{-8.75, -7.5}, {8.75, 7.5}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(Placement(visible = true, transformation(origin = {-38, -58}, extent = {{-7.5, 7.5}, {7.5, -7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f1(height = forcex, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-74, -32}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f2(height = forcey, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-74, -58}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp f3(height = forcez, duration = 0.1) annotation(Placement(visible = true, transformation(origin = {-72, -86}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  //
equation
  connect(replicator.beamMidPanel[N].frame_b, force1.frame_b) annotation(Line);
  connect(world.frame_b, replicator.beamInnerPanel.frame_a) annotation(Line);
  connect(force1.frame_a, world.frame_b) annotation(Line(points = {{-12, -68}, {-24, -68}, {-24, -20}, {-54, -20}, {-54, 12}, {-62, 12}, {-62, 12}}, color = {95, 95, 95}));
  connect(multiplex31.y, force1.force) annotation(Line(points = {{-30, -58}, {-10, -58}, {-10, -58}, {-10, -58}}, color = {0, 0, 127}));
  connect(multiplex31.u1[1], f3.y) annotation(Line(points = {{-46, -64}, {-54, -64}, {-54, -86}, {-64, -86}, {-64, -86}}, color = {0, 0, 127}));
  connect(f2.y, multiplex31.u2[1]) annotation(Line(points = {{-66, -58}, {-48, -58}, {-48, -58}, {-46, -58}}, color = {0, 0, 127}));
  connect(f1.y, multiplex31.u3[1]) annotation(Line(points = {{-66, -32}, {-58, -32}, {-58, -52}, {-46, -52}, {-46, -52}}, color = {0, 0, 127}));
  for j in 1:S loop
    connect(hub.revolute[j].frame_b, replicator.section[j].frame_inner);
  end for;
  annotation(experiment(StartTime = 0, StopTime = 3.0, Tolerance = 1e-5, Interval = 0.1), Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This example demonstrates the use of a <b>Replicator</b> block and <b>Hub</b> to model a basic fan-fold style array. The array is deployed by a force attached to the front spar. The spars are modeled with rigid beams.
  </html>"), Diagram(coordinateSystem(grid = {0, 0}), graphics = {Line(origin = {37, -46}, points = {{-33, -22}, {21, -22}, {21, 10}, {33, 10}, {33, 22}})}));
end FanFoldArrayDemo;
