within DeployStructLib.Examples.ClothExamples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/
model BlanketDemo "Basic model of a linear array"
  extends Modelica.Icons.Example;
  import DeployStructLib.Properties.*;
  import DeployStructLib;
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false);
  parameter Boolean rigid = false;
  parameter Real dL = 0.1 "Shortage of blanket";
  parameter Real L1 = 11 "Length of main spar";
  parameter Real width1 = 0.1 "Width of main spar";
  parameter Real height1 = 0.3 "Height of main spar";
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xbar1prop(width = width1, height = height1);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xbar2prop(width = 0.1, height = 0.2);
  parameter DeployStructLib.Properties.BeamXProperties.RectBarProperty xbar3prop(width = 0.1, height = 0.2);
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matProps(rho = 2700, E = 69.0e9, alpha = 0.0, beta = 0.01, nu=0.33);
  parameter Real t = 0.04;
  parameter DeployStructLib.Properties.ClothProperty sp(thickness = t, E = 300000000.0, G = 200000.0, area_density = 1.2, alpha = 1.0, nu = 0.33);
  DeployStructLib.Parts.Cloth.cloth clothLeft(flat = true, clothPropsData = sp, M = 5, N = 2, P1 = {0, 0, 0}, P2 = {0, 1, 0}, P3 = {L1 - dL, 1, 0}, P4 = {L1 - dL, 0, 0}, P1_start = {0, 0, 0}, P2_start = {0, 1, 0}, P3_start = {L1, 1, 0}, P4_start = {L1, 0, 0}, P1_loc = {0, 0, 0}, tangent_vector_sideA = {0, -1, 0}, bending_vector_sideA = {0, 0, 1}, tangent_vector_sideB = {0, 1, 0}, bending_vector_sideB = {0, 0, -1}) annotation(Placement(visible = true, transformation(origin = {20, 60}, extent = {{-43.75, -43.75}, {43.75, 43.75}}, rotation = 0)));
//
  DeployStructLib.Parts.Cloth.cloth clothRight(flat = true, clothPropsData = sp, M = 5, N = 2, P1 = {0, 0, 0}, P2 = {0, -1, 0}, P3 = {L1 - dL, -1, 0}, P4 = {L1 - dL, 0, 0}, P1_start = {0, 0, 0}, P2_start = {0, -1, 0}, P3_start = {L1, -1, 0}, P4_start = {L1, 0, 0}, P1_loc = {0, 0, 0}, tangent_vector_sideA = {0, -1, 0}, bending_vector_sideA = {0, 0, 1}, tangent_vector_sideB = {0, 1, 0}, bending_vector_sideB = {0, 0, -1}) annotation(Placement(visible = true, transformation(origin = {20, -60}, extent = {{-43.75, -43.75}, {43.75, 43.75}}, rotation = 0)));
  //
  DeployStructLib.Parts.Beam flexbeam2e(L = 0.1, rigid = rigid, xprop = xbar3prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam2d(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, -80}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam3b(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, 80}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam3e(L = 0.1, rigid = rigid, xprop = xbar3prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, 40}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation2(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, 1, 0}, n_y = {-1, 0, 0}) annotation(Placement(visible = true, transformation(origin = {80, 15}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 0)));
  DeployStructLib.Parts.Beam flexbeam3f(L = 0.1, rigid = rigid, xprop = xbar3prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, -40}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam3c(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, -60}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam3d(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, -80}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam2a(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, 60}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam2c(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam2f(L = 0.1, rigid = rigid, xprop = xbar3prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, -40}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 90)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation3(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, -1, 0}, n_y = {-1, 0, 0}) annotation(Placement(visible = true, transformation(origin = {-40, -15}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation4(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, -1, 0}, n_y = {-1, 0, 0}) annotation(Placement(visible = true, transformation(origin = {80, -15}, extent = {{-10.0, -10.0}, {10.0, 10.0}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedrotation1(rotationType = Modelica.Mechanics.MultiBody.Types.RotationTypes.TwoAxesVectors, n_x = {0, 1, 0}, n_y = {-1, 0, 0}) annotation(Placement(visible = true, transformation(origin = {-40, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam flexbeam2b(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {-40, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Beam flexbeam3a(L = 0.5, rigid = rigid, xprop = xbar2prop, matProp = matProps) annotation(Placement(visible = true, transformation(origin = {80, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  inner Modelica.Mechanics.MultiBody.World world(n = {0, 0, -1}, animateWorld = true, enableAnimation = true) annotation(Placement(visible = true, transformation(origin = {-80, 15}, extent = {{-8.5, -8.5}, {8.5, 8.5}}, rotation = 0)));
  DeployStructLib.Parts.Beam flexbeam1(L = L1, rigid = rigid, xprop = xbar1prop, matProp = matProps, animation = true) annotation(Placement(visible = true, transformation(origin = {20, 5}, extent = {{-29.2188, -19}, {29.2188, 19}}, rotation = 0)));
equation
  connect(fixedrotation2.frame_b, flexbeam3e.frame_a);
  connect(flexbeam1.frame_b, fixedrotation2.frame_a);
  connect(world.frame_b, flexbeam1.frame_a);
  connect(flexbeam1.frame_b, fixedrotation4.frame_a);
  connect(fixedrotation1.frame_a, world.frame_b);
  connect(flexbeam2e.frame_a, fixedrotation1.frame_b);
  connect(flexbeam2f.frame_a, fixedrotation3.frame_b);
  connect(fixedrotation3.frame_a, world.frame_b);
  connect(flexbeam3f.frame_a, fixedrotation4.frame_b);
  //
  connect(flexbeam2e.frame_b, clothLeft.sideA[1]);
  connect(flexbeam2a.frame_b, clothLeft.sideA[2]);
  connect(flexbeam2b.frame_b, clothLeft.sideA[3]);
  //
  connect(flexbeam2f.frame_b, clothRight.sideA[1]);
  connect(flexbeam2c.frame_b, clothRight.sideA[2]);
  connect(flexbeam2d.frame_b, clothRight.sideA[3]);
  //
  connect(flexbeam3a.frame_a, clothLeft.sideB[1]);
  connect(flexbeam3a.frame_b, clothLeft.sideB[2]);
  connect(flexbeam3b.frame_b, clothLeft.sideB[3]);
  //
  connect(flexbeam3c.frame_a, clothRight.sideB[1]);
  connect(flexbeam3c.frame_b, clothRight.sideB[2]);
  connect(flexbeam3d.frame_b, clothRight.sideB[3]);
  //
  connect(flexbeam2b.frame_a, flexbeam2a.frame_b);
  connect(flexbeam2d.frame_a, flexbeam2c.frame_b);
  connect(flexbeam3b.frame_a, flexbeam3a.frame_b);
  connect(flexbeam3d.frame_a, flexbeam3c.frame_b);
  //
  connect(flexbeam2e.frame_b, flexbeam2a.frame_a);
  connect(flexbeam3e.frame_b, flexbeam3a.frame_a);
  connect(flexbeam3f.frame_b, flexbeam3c.frame_a);
  connect(flexbeam2f.frame_b, flexbeam2c.frame_a);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), experiment(StartTime = 0, StopTime = 1, Tolerance = 0.00001, Interval = 0.01), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {-26.08, 89.72}, points = {{-13.9227, 0}, {13.9227, 0}}, thickness = 2), Line(origin = {-56.02, 71.49}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {-55.9095, 47.7331}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {-6.08, 109.72}, points = {{-13.9227, 0}, {13.9227, 0}}, thickness = 2), Line(origin = {24.643, 90.0535}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {44.864, 111.159}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {44.864, 111.159}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {44.864, 111.159}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {59.447, 69.725}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {60.2205, 47.073}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {44.643, 110.054}, points = {{16.0221, -0.994475}, {56.2431, -0.994475}}, thickness = 2), Line(origin = {59.668, -32.5955}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {62.3199, -50.054}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {61.215, -71.0485}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {-19.227, -32.3745}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {-18.785, -49.833}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {-20.111, -70.8275}, points = {{-20.3315, 0.110497}, {20.3315, -0.110497}}, thickness = 2), Line(origin = {-60.5664, 15.3452}, points = {{-11.9198, -0.317604}, {11.2846, -0.317604}, {11.5056, -0.0966095}}), Line(origin = {-28.1815, 23.9779}, points = {{-1.87371, -8.72926}, {4.53513, -8.72926}, {4.53513, 8.50831}, {-11.5975, 8.50831}}), Line(origin = {91.487, 23.8674}, points = {{-1.87371, -8.72926}, {4.53513, -8.72926}, {4.53513, 8.50831}, {-11.5975, 8.50831}}), Line(origin = {-61.105, 0.552486}, points = {{-11.6022, 14.4751}, {-0.331492, 14.4751}, {-0.331492, -14.4751}, {11.6022, -14.4751}}), Line(origin = {-33.0609, -23.8896}, points = {{3.00561, 8.64097}, {6.76252, 8.64097}, {6.76252, -3.73472}, {-6.49715, -3.73472}, {-6.71814, -8.5966}}), Line(origin = {59.4475, 10.2762}, points = {{10.6077, 5.19337}, {-10.6077, 5.19337}, {-10.6077, -5.19337}}), Line(origin = {59.4417, -5.18752}, points = {{-10.3809, 9.38642}, {-10.1599, -9.39811}, {10.3926, -9.39811}}), Line(origin = {-35.3591, 4.64088}, points = {{26.0773, 0}, {-26.0773, 0}}), Line(origin = {87.4916, -23.7791}, points = {{3.00561, 8.64097}, {6.76252, 8.64097}, {6.76252, -3.73472}, {-6.49715, -3.73472}, {-6.71814, -8.5966}})}), 
  Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>
<p>
This example demonstrates a basic model of a linear array. The array is modeled in a deployed configuration. The solar blankets are tensioned between the \"trunk\" and \"end\" beams by a length difference between the central \"mast\" beam and the blankets themselves. This example uses a different modeling method from <b>GRA_demo</b>.
  </html>"));
end BlanketDemo;
