within DeployStructLib.Examples.ClothExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model StretchedBlanketDemo "Example demonstrating a Cloth block being stretched length-wise between two parallel beams."
  extends Modelica.Icons.Example;
  parameter Real cloth_w = 1.0;
  parameter Real cloth_L = 1.0;
  parameter Integer N = 2;
  parameter Integer M = 4;
  parameter Real rampDur = 5.0;
  parameter Real forcey = 1000.0;
  //
  parameter Boolean rigid = true;
  //
  import DeployStructLib;
  import DeployStructLib.Properties.*;
  //
  DeployStructLib.Parts.Beam beam3(L = cloth_w / N, rigid = rigid, xprop = xprop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-2, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam beam4(L = cloth_w / N, rigid = rigid, xprop = xprop, matProp = matProps, frame_a.r_0(start = {0, cloth_L, 0}, each fixed = true)) annotation(Placement(visible = true, transformation(origin = {-38, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Forces.WorldForce force annotation(Placement(visible = true, transformation(origin = {44, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  inner Modelica.Mechanics.MultiBody.World world(g = 0, n = {0, 0, -1}) annotation(Placement(visible = true, transformation(origin = {-74, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam beam2(L = cloth_w / N, rigid = rigid, xprop = xprop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-34, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam beam1(L = cloth_w / N, rigid = rigid, xprop = xprop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {0, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Prismatic prismatic1(s(start = cloth_L), animation = false, n = {0, 1, 0}) annotation(Placement(visible = true, transformation(origin = {-76, 16}, extent = {{19, 19}, {-19, -19}}, rotation = -90)));
  DeployStructLib.Parts.Cloth.cloth cloth1(tri = true, clothPropsData = clothProperty, flat = true, M = M, N = N, P1 = {0, 0, 0}, P2 = {cloth_w, 0, 0}, P3 = {cloth_w, cloth_L, 0}, P4 = {0, cloth_L, 0}, P1_start = {0, 0, 0}, P2_start = {cloth_w, 0, 0}, P3_start = {cloth_w, cloth_L, 0}, P4_start = {0, cloth_L, 0}, start_angle = 0.0, P1_loc = {0, 0, 0}) annotation(Placement(visible = true, transformation(origin = {-19, 9}, extent = {{-38, -38}, {38, 38}}, rotation = 0)));
  Modelica.Blocks.Routing.Multiplex3 multiplex31 annotation(Placement(visible = true, transformation(origin = {84, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Ramp step1(height = 0, startTime = 0.1, duration = rampDur) annotation(Placement(visible = true, transformation(origin = {62, 14}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp step2(height = forcey, startTime = 0.1, duration = rampDur) annotation(Placement(visible = true, transformation(origin = {62, -12}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp step3(height = 0, startTime = 0.1, duration = rampDur) annotation(Placement(visible = true, transformation(origin = {62, -38}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xprop(width = 0.1, height = 0.05) annotation(Placement(visible = true, transformation(origin = {-32, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.ClothProperty clothProperty(area_density = 1.0, thickness = 0.001, E = 1e7, G = 3.846153846e6, damping_bend = 0.0, D = 1e3, alpha = 0.01, beta = 0.01) annotation(Placement(visible = true, transformation(origin = {0, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matProps(alpha = 0.0, beta = 0.01, E = 69.0e9, rho = 1, nu = 0.33) annotation(Placement(visible = true, transformation(origin = {30, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = true) annotation(Placement(visible = true, transformation(origin = {72, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Utilities.LocationForce locationforce1(force = {0, 0, 3}) annotation(Placement(visible = true, transformation(origin = {-14, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(step3.y, multiplex31.u3[1]) annotation(Line(points = {{70.25, -38}, {92, -38}, {92, 28}, {91.25, 28}}, color = {0, 0, 127}));
  connect(step2.y, multiplex31.u2[1]) annotation(Line(points = {{70.25, -12}, {84, -12}, {84, 28}, {84.25, 28}}, color = {0, 0, 127}));
  connect(step1.y, multiplex31.u1[1]) annotation(Line(points = {{70.25, 14}, {75.25, 14}, {75.25, 21}, {77.25, 21}, {77.25, 28}}, color = {0, 0, 127}));
  connect(multiplex31.y, force.force) annotation(Line(points = {{84, 51}, {44, 51}, {44, 60}}, color = {0, 0, 127}));
  connect(force.frame_b, beam3.frame_b) annotation(Line(points = {{44, 82}, {18, 82}, {18, 60}, {8, 60}}, color = {95, 95, 95}));
  connect(locationforce1.location, cloth1.clothInstanceFlatTri.mass[2, 2].location);
  connect(cloth1.sideA[1], beam2.frame_a);
  connect(cloth1.sideA[2], beam2.frame_b);
  connect(cloth1.sideA[3], beam1.frame_b);
  connect(cloth1.sideB[1], beam4.frame_a);
  connect(cloth1.sideB[2], beam4.frame_b);
  connect(cloth1.sideB[3], beam3.frame_b);
  connect(prismatic1.frame_b, beam4.frame_a) annotation(Line(points = {{-76, 35}, {-76, 60}, {-48, 60}}, color = {95, 95, 95}));
  connect(prismatic1.frame_a, beam2.frame_a) annotation(Line(points = {{-76, -3}, {-76, -32}, {-44, -32}}, color = {95, 95, 95}));
  connect(beam2.frame_b, beam1.frame_a) annotation(Line(points = {{-24, -32}, {-10, -32}}, color = {95, 95, 95}));
  connect(beam2.frame_a, world.frame_b) annotation(Line(points = {{-44, -32}, {-44, -32}, {-44, -32}, {-46, -32}, {-46, -32}, {-50, -32}, {-50, -52}, {-56, -52}, {-56, -52}, {-64, -52}}, color = {95, 95, 95}));
  connect(beam4.frame_b, beam3.frame_a) annotation(Line(points = {{-28, 60}, {-12, 60}}, color = {95, 95, 95}));
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), experiment(StartTime = 0, StopTime = 3.0, Tolerance = 1e-6, Interval = 0.002), Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

  <p>
  This example demonstrates a <b>Cloth</b> block being stretched length-wise between two parallel beams.
  </html>"));
end StretchedBlanketDemo;
