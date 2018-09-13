within DeployStructLib.Examples;
/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FanFoldArrayDemo_DrivenHub "Example model of fan-fold array"
  extends Modelica.Icons.Example;    
  import DeployStructLib;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.ClothProperty.*;
  final parameter Integer S = 5 "Number of array sections";
  final parameter Integer N = 2 "Blanket discretization in the y-direction";
  final parameter Integer M = 2 "Blanket discretization in the y-direction";
  final parameter Boolean rigid = false;
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
  parameter DeployStructLib.Properties.ClothProperty clothPropsData(thickness = 0.00015, E = 3.2e9, nu = 0.01, area_density = 1.0, beta = 0.01);
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matPropsData(rho = 2700, E = 69.0e9, alpha = 0.0, beta = 0.01, nu = 0.33);
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, g = 0.0, animateWorld = true, enableAnimation = true) annotation(Placement(visible = true, transformation(origin = {-50, 28}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false) annotation(Placement(visible = true, transformation(origin = {84, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Replicator replicator(rigid = rigid, clothPropsData = clothPropsData, matPropsData = matPropsData, M = M, N = N, S = S, height = height, width = width, widthEnd = widthEnd, heightEnd = heightEnd, R_outer = R_outer, R_inner = R_inner, widthPanel = widthPanel, heightPanel = heightPanel, start_angle = start_angle, span_angle = span_angle, R0_loc = R0_loc, R0_angles = R0_angles) annotation(Placement(visible = true, transformation(origin = {66, 26}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  DeployStructLib.Parts.FanFoldParts.Hub hub(S = S, damping = hub_damping, phi_start = array((S - i + 1) * start_angle_rad for i in 1:S), driven = true, driven_speed = 0.125) annotation(Placement(visible = true, transformation(origin = {0, 26}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //
equation
  connect(world.frame_b, replicator.beamInnerPanel.frame_a);
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
This example demonstrates the use of a <b>Replicator</b> block and <b>Hub</b> to model a basic fan-fold style array. The array is deployed by driving the first hinge in the <b>Hub</b>. Additionally, the model uses flexible spars in the array, and the array is simulated in 0 g. 
  </html>"));
end FanFoldArrayDemo_DrivenHub;
