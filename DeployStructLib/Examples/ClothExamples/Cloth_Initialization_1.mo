within DeployStructLib.Examples.ClothExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/
model Cloth_Initialization_1 "Cloth initialization example"
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;
  parameter Integer M = 3;
  parameter Integer N = 4;
  parameter SI.Length length = 2;
  parameter SI.Length width = 1;
  parameter SI.Length length_start = 1;
  parameter Real angle = 15 "Start angle in degrees";
  parameter SI.Position P1[3] = {0.1 * cos(angle * 3.14 / 180), 0.1 * sin(angle * 3.14 / 180), 0};
  parameter SI.Position P2[3] = {1.1 * cos(angle * 3.14 / 180), 1.1 * sin(angle * 3.14 / 180), 0};
  parameter SI.Position P3[3] = {1.1, 0, 0};
  parameter SI.Position P4[3] = {0.1, 0, 0};
  parameter SI.Position P1_start[3] = {0.1 * cos(angle * 3.14 / 180), 0.1 * sin(angle * 3.14 / 180), 0} "Initial location of P1 in world coordinates";
  parameter SI.Position P2_start[3] = {1.1 * cos(angle * 3.14 / 180), 1.1 * sin(angle * 3.14 / 180), 0} "Initial location of P2 in world coordinates";
  parameter SI.Position P3_start[3] = {1.1, 0, 0} "Initial location of P3 in world coordinates";
  parameter SI.Position P4_start[3] = {0.1, 0, 0} "Initial location of P4 in world coordinates";
  //
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}) annotation(
    Placement(visible = true, transformation(origin = {-130, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = true);
  parameter Properties.ClothProperty clothProps(area_density = 1, E = 1000000.0, thickness = 0.01, nu = 0.01);
  DeployStructLib.Parts.Cloth.cloth cloth1(M = M, N = N, P1 = P1, P1_loc = {0, 0, 0}, P1_start = P1_start, P2 = P2, P2_start = P2_start, P3 = P3, P3_start = P3_start, P4 = P4, P4_start = P4_start, clothPropsData = clothProps, flat = true, m = 0, ref_angles = {0, 0, 0}, useSideBFrame = true) annotation(
    Placement(visible = true, transformation(origin = {-12.346, -10}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox[N + 1] sparA(r = array({i, 0, 0} for i in {0.225, 0.25, 0.25, 0.25, 0.25}), each density = 100) annotation(
    Placement(visible = true, transformation(origin = {-94.3293, 13.2317}, extent = {{-17.5, -17.5}, {17.5, 17.5}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Parts.BodyBox[N + 1] sparB(r = array({i, 0, 0} for i in {0.225, 0.25, 0.25, 0.25, 0.25}), each density = 100) annotation(
    Placement(visible = true, transformation(origin = {20.6707, -81.7683}, extent = {{-17.5, -17.5}, {17.5, 17.5}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation(n = {0, 0, 1}, angle = angle) annotation(
    Placement(visible = true, transformation(origin = {-96.0976, -61.7073}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(sparB[N + 1].frame_b, cloth1.sideB[N + 1]) annotation(
    Line);
  connect(sparA[N + 1].frame_b, cloth1.sideA[N + 1]) annotation(
    Line);
  connect(sparA[1].frame_a, fixedrotation.frame_b) annotation(
    Line(points = {{-94, -4}, {-95, -4}, {-95, -52}, {-96, -52}}, color = {0, 0, 127}));
  connect(fixedrotation.frame_a, world.frame_b) annotation(
    Line(points = {{-96, -72}, {-100, -72}, {-100, -80}, {-120, -80}}, color = {0, 0, 127}));
  connect(sparB[1].frame_a, world.frame_b) annotation(
    Line(points = {{3, -82}, {-65, -82}, {-65, -80}, {-120, -80}}, color = {0, 0, 127}));
  for i in 1:N loop
    connect(sparA[i].frame_b, sparA[i + 1].frame_a);
    connect(sparB[i].frame_b, sparB[i + 1].frame_a);
  end for;
  for i in 1:N loop
    connect(sparA[i].frame_b, cloth1.sideA[i]);
    connect(sparB[i].frame_b, cloth1.sideB[i]);
  end for;
  annotation(
    Diagram(coordinateSystem(extent = {{-148.5, -105.0}, {148.5, 105.0}}, preserveAspectRatio = true, initialScale = 0.1, grid = {5, 5})),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 0.00001),
    Documentation(info = "<HTML>
    <p>
    Copyright &copy; 2018<br>
    ATA ENGINEERING, INC.<br>
    ALL RIGHTS RESERVED
    </p>

     <p>
     Example using the cloth modeling framework with a blanket hanging between two spars fixed at a nearly zero angle to each other. Primarily used to illustrate initialization. Other initialization solvers can take a very long time to solve.
     </HTML>
     "));
end Cloth_Initialization_1;
