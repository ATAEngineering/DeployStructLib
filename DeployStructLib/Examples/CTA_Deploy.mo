within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model CTA_Deploy "Basic deployment model of a linear array"
  extends Modelica.Icons.Example;
  parameter Real dL = 0.0;
  parameter Real L = 16.0 + dL;
  parameter Real w = 6;
  parameter Real L_cloth = 16.0;
  parameter Real w_cloth = 3.0508;
  parameter Real damp_alpha = 0.0;
  parameter Real damp_beta = 0.01;
  parameter Integer F = 3 "Number of folds in z-fold blanket";
  final parameter Integer M = 3;
  final parameter Integer N = 2;
  parameter Boolean rigid = false;
  parameter Real startL = 0.04;
  parameter Real gap = 0.0508;
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, g = 0.0) annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false) annotation(
    Placement(visible = true, transformation(origin = {-82, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam[N] endBeamA(each L = w / 2 / N, each rigid = rigid, each xprop = endBeamXProp, each matProp = endBeamMatProp) annotation(
    Placement(visible = true, transformation(origin = {64, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  parameter DeployStructLib.Properties.BeamXProperties.CircRodProperty endBeamXProp(d = 2 * 0.0762) annotation(
    Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.BeamXProperties.RectTubeProperty trunkBeamXProp(width = 0.1524, height = 0.3048, t = 0.001524) annotation(
    Placement(visible = true, transformation(origin = {-78, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.BeamXProperties.RectTubeProperty mastBeamXProp(width = 0.1016, height = 0.1016, t = 0.00127) annotation(
    Placement(visible = true, transformation(origin = {-22, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty trunkBeamMatProp(alpha = damp_alpha, beta = damp_beta, E = 140e9, nu = 0.32, rho = 1993) annotation(
    Placement(visible = true, transformation(origin = {-78, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty endBeamMatProp(alpha = damp_alpha, beta = damp_beta, E = 140e9, nu = 0.3, rho = 64) annotation(
    Placement(visible = true, transformation(origin = {-50, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty mastBeamMatProp(alpha = damp_alpha, beta = damp_beta, E = 140e9, nu = 0.32, rho = 1993) annotation(
    Placement(visible = true, transformation(origin = {-22, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.ClothProperty clothProperty(area_density = 1281.6 * 0.000762, thickness = 0.000762, E = 3.45e9, nu = 0.3) annotation(
    Placement(visible = true, transformation(origin = {16, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation2A(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, 1, 0}, n_y = {-1, 0, 0}, r = {0, 0.1016 / 2, 0}) annotation(
    Placement(visible = true, transformation(origin = {54, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam[N] trunkBeamA(each L = w / 2 / N, each rigid = rigid, each xprop = trunkBeamXProp, each matProp = trunkBeamMatProp) annotation(
    Placement(visible = true, transformation(origin = {-36, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Beam[N] trunkBeamB(each L = w / 2 / N, each rigid = rigid, each xprop = trunkBeamXProp, each matProp = trunkBeamMatProp) annotation(
    Placement(visible = true, transformation(origin = {-36, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation1B(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, -1, 0}, n_y = {1, 0, 0}, r = {0, -0.1016 / 2, 0}) annotation(
    Placement(visible = true, transformation(origin = {-46, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam[N] endBeamB(each L = w / 2 / N, each rigid = rigid, each xprop = endBeamXProp, each matProp = endBeamMatProp) annotation(
    Placement(visible = true, transformation(origin = {64, -14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DeployStructLib.Parts.VariableLengthBeam[M] mastBeam(each xprop = mastBeamXProp, each matProp = mastBeamMatProp, each L_start = startL / M) annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-22, -22}, {22, 22}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation1A(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, 1, 0}, n_y = {-1, 0, 0}, r = {0, 0.1016 / 2, 0}) annotation(
    Placement(visible = true, transformation(origin = {-48, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation2B(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, -1, 0}, n_y = {1, 0, 0}, r = {0, -0.1016 / 2, 0}) annotation(
    Placement(visible = true, transformation(origin = {54, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Sources.VariableLengthSource variableLengthSource(L(fixed = true), dt = 0.04, maxLength = L / M, minLength = 0.0, startLength = startL / M) annotation(
    Placement(visible = true, transformation(origin = {66, -46}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.cloth clothA(M = M, N = N, P2 = {0, w_cloth, 0}, P3 = {L_cloth, w_cloth, 0}, P4 = {L_cloth, gap, 0}, P2_start = {0, w_cloth, 0}, P3_start = {startL, w_cloth, 0}, P4_start = {startL, gap, 0}, flat = false, clothPropsData = clothProperty, zFold = true, folds = F, P1_start = {0, gap, 0}, m = 1, P1 = {0, gap, 0}) annotation(
    Placement(visible = true, transformation(origin = {20, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.cloth clothB(M = M, N = N, P2 = {0, -w_cloth, 0}, P3 = {L_cloth, -w_cloth, 0}, P4 = {L_cloth, -gap, 0}, P2_start = {0, -w_cloth, 0}, P3_start = {startL, -w_cloth, 0}, P4_start = {startL, -gap, 0}, flat = false, clothPropsData = clothProperty, zFold = true, P1_start = {0, -gap, 0}, folds = F, m = 1, P1 = {0, -gap, 0}) annotation(
    Placement(visible = true, transformation(origin = {14, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(fixedrotation2B.frame_b, endBeamB[1].frame_a) annotation(
    Line(points = {{64, 8}, {64, -4}}, color = {95, 95, 95}));
  connect(trunkBeamA[1].frame_a, fixedrotation1A.frame_b) annotation(
    Line(points = {{-36, 54}, {-36, 43}, {-38, 43}, {-38, 32}}, color = {95, 95, 95}));
  connect(fixedrotation1A.frame_a, world.frame_b) annotation(
    Line(points = {{-58, 32}, {-70.151, 32}, {-70.151, 19.9768}, {-69.6864, 19.9768}}, color = {95, 95, 95}));
  connect(world.frame_b, mastBeam[1].frame_a) annotation(
    Line(points = {{-70, 20}, {-4, 20}, {-4, 18}, {-4, 18}}, color = {95, 95, 95}));
  connect(fixedrotation1B.frame_b, trunkBeamB[1].frame_a) annotation(
    Line(points = {{-36, 10}, {-36, 0}}, color = {95, 95, 95}));
  connect(world.frame_b, fixedrotation1B.frame_a) annotation(
    Line(points = {{-70, 20}, {-56, 20}, {-56, 10}}, color = {95, 95, 95}));
  connect(fixedrotation2A.frame_b, endBeamA[1].frame_a) annotation(
    Line(points = {{64, 40}, {64, 52}}, color = {95, 95, 95}));
//
// Connect beams
  for i in 1:N - 1 loop
    connect(trunkBeamA[i].frame_b, trunkBeamA[i + 1].frame_a);
    connect(trunkBeamB[i].frame_b, trunkBeamB[i + 1].frame_a);
    connect(endBeamA[i].frame_b, endBeamA[i + 1].frame_a);
    connect(endBeamB[i].frame_b, endBeamB[i + 1].frame_a);
  end for;
  for i in 1:M - 1 loop
    connect(mastBeam[i].frame_b, mastBeam[i + 1].frame_a);
    connect(mastBeam[i].dL_in, variableLengthSource.dL);
  end for;
  connect(mastBeam[M].dL_in, variableLengthSource.dL);
  connect(mastBeam[M].frame_b, fixedrotation2A.frame_a);
  connect(mastBeam[M].frame_b, fixedrotation2B.frame_a);
//
// Connect cloth to beams
  for i in 1:N loop
    connect(trunkBeamA[i].frame_a, clothA.sideA[i]);
    connect(trunkBeamB[i].frame_a, clothB.sideA[i]);
    connect(endBeamA[i].frame_a, clothA.sideB[i]);
    connect(endBeamB[i].frame_a, clothB.sideB[i]);
  end for;
  connect(trunkBeamA[N].frame_b, clothA.sideA[N + 1]);
  connect(trunkBeamB[N].frame_b, clothB.sideA[N + 1]);
  connect(endBeamA[N].frame_b, clothA.sideB[N + 1]);
  connect(endBeamB[N].frame_b, clothB.sideB[N + 1]);
//
//
  annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),
    experiment(StartTime = 0, StopTime = 3, Tolerance = 1e-06, Interval = 0.002),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {39, 26}, points = {{-7, -6}, {1, -6}, {1, 6}, {5, 6}, {5, 6}}), Line(origin = {38, 14}, points = {{-6, 6}, {2, 6}, {2, -6}, {6, -6}, {6, -6}})}),
    Documentation(info = "<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This example demonstrates a basic model of a linear array. The array begins in a partially-deployed configuration and deploys fully, using <b>VariableLengthBeams</b> along the mast. At full deployment, the solar blankets are tensioned between the \"trunk\" and \"end\" beams by a length difference between the central \"mast\" beam and the blankets themselves.
  </html>"));
end CTA_Deploy;
