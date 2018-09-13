within DeployStructLib.Examples.ClothExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Cloth_Initialization_2 "Cloth initialization example"
  extends Modelica.Icons.Example;  
  import SI = Modelica.SIunits;
  parameter Integer M = 3;
  parameter Integer N = 4;
  parameter SI.Length length = 2;
  parameter SI.Length width = 1;
  parameter SI.Length length_start = 1;
  parameter Real angle = 25 "Start angle in degrees";
  parameter SI.Position P1[3] = {0.1, 0.1, 0};
  parameter SI.Position P2[3] = {1.1, 0.1, 0};
  parameter SI.Position P3[3] = {1.1, 0, 0};
  parameter SI.Position P4[3] = {0.1, 0, 0};
  parameter SI.Position P1_start[3] = {0.1 * cos(angle * 3.14 / 180), 0.1 * sin(angle * 3.14 / 180), 0} "Initial location of P1 in world coordinates";
  parameter SI.Position P2_start[3] = {1.1 * cos(angle * 3.14 / 180), 1.1 * sin(angle * 3.14 / 180), 0} "Initial location of P2 in world coordinates";
  parameter SI.Position P3_start[3] = {1.1, 0, 0} "Initial location of P3 in world coordinates";
  parameter SI.Position P4_start[3] = {0.1, 0, 0} "Initial location of P4 in world coordinates";
  //
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}) annotation(Placement(visible = true, transformation(origin = {-105, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = true);
  parameter Properties.ClothProperty clothProps(area_density = 1, E = 1000000.0, alpha = 1, thickness = 0.01, nu = 0.01);
  DeployStructLib.Parts.Cloth.cloth cloth1(flat = true, M = M, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, ref_angles = {0, 0, 0}, clothPropsData = clothProps) annotation(Placement(visible = true, transformation(origin = {7.654, -15}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox[N + 1] sparA(r = array({i, 0, 0} for i in {0.225, 0.25, 0.25, 0.25, 0.25}), each density = 100) annotation(Placement(visible = true, transformation(origin = {-69.3293, 33.2317}, extent = {{-17.5, -17.5}, {17.5, 17.5}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox[N + 1] sparB(r = array({i, 0, 0} for i in {0.225, 0.25, 0.25, 0.25, 0.25}), each density = 100) annotation(Placement(visible = true, transformation(origin = {88.1707, -79.2683}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute(phi(start = Modelica.Constants.D2R * angle, fixed = true), w(start = 0, fixed = true)) annotation(Placement(visible = true, transformation(origin = {-71.8293, -50.3658}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(sparB[1].frame_a, world.frame_b) annotation(Line(points = {{68, -79}, {10, -79}, {10, -80}, {-95, -80}}, color = {0, 0, 127}));
  connect(sparB[N + 1].frame_b, cloth1.sideB[N + 1]) annotation(Line);
  connect(revolute.frame_a, world.frame_b) annotation(Line(points = {{-72, -60}, {-75, -60}, {-75, -80}, {-95, -80}}, color = {0, 0, 127}));
  connect(sparA[N + 1].frame_b, cloth1.sideA[N + 1]) annotation(Line);
  connect(sparA[1].frame_a, revolute.frame_b) annotation(Line(points = {{-69, 16}, {-70, 16}, {-70, -35}, {-71, -35}, {-71, -40}, {-72, -40}}, color = {0, 0, 127}));
  for i in 1:N loop
    connect(sparA[i].frame_b, sparA[i + 1].frame_a);
    connect(sparB[i].frame_b, sparB[i + 1].frame_a);
  end for;
  for i in 1:N loop
    connect(sparA[i].frame_b, cloth1.sideA[i]);
    connect(sparB[i].frame_b, cloth1.sideB[i]);
  end for;
  annotation(Diagram(coordinateSystem(extent = {{-148.5, -105.0}, {148.5, 105.0}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})), experiment(StartTime = 0, StopTime = 1, Tolerance = 0.00001), Documentation(info = "<HTML>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     <p>
     Example using the cloth modeling framework with a blanket hanging between a fixed spar and a hinged spar starting at a relative angle of 25 degrees to each other. Gravity acting on the blanket pulls the spars together.
     </HTML>
     "));
end Cloth_Initialization_2;
