within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model DoubleDoor_Deploy "Deployment model of a hinged, three-panel mechanism"
  extends Modelica.Icons.Example;
  import pi = Modelica.Constants.pi;
  import DeployStructLib.Properties.BeamXProperties.*;
  import DeployStructLib.Properties.MaterialProperties.*;
  //
  parameter Real cpos = 0.05;
  parameter Real c_stop = 1000.0;
  parameter Real damping = 0.03;
  parameter Real E = 7.0e8;
  parameter Real panel_beta = 0.001;
  parameter Boolean rigid = false;
  Real hinge1f, hinge2f;
  parameter isotropicMaterialProperty matProp1(E=E,rho=340.0,alpha=0.0,beta=panel_beta,nu=0.33);
  parameter isotropicMaterialProperty matProp2(E=E,rho=195.1,alpha=0.0,beta=panel_beta,nu=0.33);
  parameter isotropicMaterialProperty matProp3(E=E,rho=193.2,alpha=0.0,beta=panel_beta,nu=0.33);
//
  parameter RectBarProperty panel1props(width = 0.014, height = 0.3);
  parameter RectBarProperty panel2props(width = 0.007, height = 0.6);
  parameter RectBarProperty panel3props(width = 0.007, height = 0.5);
  //
  inner Modelica.Mechanics.MultiBody.World world(g = 0.0, animateGravity = false) annotation(Placement(visible = true, transformation(origin = {-80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam panel1(L = 0.15, xprop = panel1props, matProp = matProp1,  rigid = rigid) annotation(Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam panel2(L = 0.30, xprop = panel2props, matProp = matProp2 , rigid = rigid) annotation(Placement(visible = true, transformation(origin = {20, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Beam panel3(L = 0.15, xprop = panel3props, matProp = matProp3 , rigid = rigid) annotation(Placement(visible = true, transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute hinge1(useAxisFlange = true, phi(start = pi / 2, fixed = true), w(start = 0.0, fixed = true), stateSelect = StateSelect.always) annotation(Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Revolute hinge2(useAxisFlange = true, phi(start = pi / 2, fixed = true), w(start = 0.0, fixed = true), stateSelect = StateSelect.always) annotation(Placement(visible = true, transformation(origin = {60, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.SpringDamper springdamper1(c = cpos, d = damping, phi_rel0 = -pi / 2) annotation(Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Components.SpringDamper springdamper2(c = cpos, d = damping, phi_rel0 = -pi / 2) annotation(Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false) annotation(Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Springs.Rotational.RotationalStop rotationalstop1(c_stop = c_stop, ignore_events = false) annotation(Placement(visible = true, transformation(origin = {0, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Springs.Rotational.RotationalStop rotationalstop2(c_stop = c_stop, ignore_events = false) annotation(Placement(visible = true, transformation(origin = {60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Parts.Body hingemass1a(m = 0.05, I_11 = 6.0e-4, I_22 = 6.0e-4, I_33 = 1.0e-6, r_CM = {-0.02, 0, 0}) annotation(Placement(visible = true, transformation(origin = {-20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.Body hingemass2a(m = 0.05, I_11 = 0.0015, I_22 = 0.0015, I_33 = 1.0e-6, r_CM = {-0.02, 0, 0}) annotation(Placement(visible = true, transformation(origin = {40, -60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.Body hingemass2b(m = 0.05, I_11 = 0.0015, I_22 = 0.0015, I_33 = 1.0e-6, r_CM = {0.02, 0, 0}) annotation(Placement(visible = true, transformation(origin = {60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Mechanics.MultiBody.Parts.Body hingemass1b(m = 0.05, I_11 = 6.0e-4, I_22 = 6.0e-4, I_33 = 1.0e-6, r_CM = {0.02, 0, 0}) annotation(Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
equation
  hinge1f = sqrt(hinge1.frame_a.f[1] ^ 2 + hinge1.frame_a.f[2] ^ 2);
  hinge2f = sqrt(hinge2.frame_a.f[1] ^ 2 + hinge2.frame_a.f[2] ^ 2);
  connect(hingemass1b.frame_a, panel2.frame_a) annotation(Line(points = {{1.83691e-15, -50}, {10.1572, -50}, {10, 0.241838}, {10, 0}}, color = {95, 95, 95}));
  connect(hingemass2b.frame_a, panel3.frame_a) annotation(Line(points = {{60, -50}, {69.4075, -50}, {70, 0.241838}, {70, 0}}, color = {95, 95, 95}));
  connect(hingemass2a.frame_a, panel2.frame_b) annotation(Line(points = {{40, -50}, {29.7461, -50}, {30, 0.725514}, {30, 0}}, color = {95, 95, 95}));
  connect(hingemass1a.frame_a, panel1.frame_b) annotation(Line(points = {{-20, -50}, {-29.9879, -50}, {-30, -0.483676}, {-30, 0}}, color = {95, 95, 95}));
  connect(panel2.frame_b, hinge2.frame_a) annotation(Line(points = {{30, 0}, {43.0472, 0}, {43.0472, 20.0726}, {50.3023, 20}, {50, 20}}, color = {95, 95, 95}));
  connect(panel1.frame_b, hinge1.frame_a) annotation(Line(points = {{-30, 0}, {-23.2164, 0}, {-23.2164, 19.8307}, {-9.67352, 20}, {-10, 20}}, color = {95, 95, 95}));
  connect(world.frame_b, panel1.frame_a) annotation(Line(points = {{-70, -20}, {-50.0605, -20}, {-50.0605, -20.3144}, {-50.0605, -20.3144}}, color = {95, 95, 95}));
  connect(rotationalstop2.flange_b, hinge2.axis) annotation(Line(points = {{70, 80}, {84.1596, 80}, {84.1596, 30.2297}, {59.9758, 30.2297}, {59.9758, 30.2297}}));
  connect(rotationalstop2.flange_a, hinge2.support) annotation(Line(points = {{50, 80}, {37.4849, 80}, {37.4849, 29.9879}, {54.4135, 29.9879}, {54.4135, 29.9879}}));
  connect(rotationalstop1.flange_b, hinge1.axis) annotation(Line(points = {{10, 80}, {22.0073, 80}, {22.0073, 30.2297}, {0.241838, 30.2297}, {0.241838, 30.2297}}));
  connect(rotationalstop1.flange_a, hinge1.support) annotation(Line(points = {{-10, 80}, {-23.4583, 80}, {-23.4583, 29.5042}, {-6.52963, 29.5042}, {-6.52963, 29.5042}}));
  connect(springdamper2.flange_b, hinge2.axis) annotation(Line(points = {{70, 60}, {77.63, 60}, {77.63, 30.3023}, {60.2177, 30}, {60, 30}}));
  connect(springdamper2.flange_a, hinge2.support) annotation(Line(points = {{50, 60}, {43.289, 60}, {43.289, 30.0605}, {53.9299, 30}, {54, 30}}));
  connect(springdamper1.flange_b, hinge1.axis) annotation(Line(points = {{10, 60}, {14.7521, 60}, {14.7521, 29.5768}, {0, 30}, {0, 30}}));
  connect(springdamper1.flange_a, hinge1.support) annotation(Line(points = {{-10, 60}, {-15.9613, 60}, {-15.9613, 29.3349}, {-5.80411, 30}, {-6, 30}}));
  connect(hinge2.frame_b, panel3.frame_a) annotation(Line(points = {{70, 20}, {70.3748, 20}, {70, 0.725514}, {70, 0}}, color = {95, 95, 95}));
  connect(hinge1.frame_b, panel2.frame_a) annotation(Line(points = {{10, 20}, {10.6409, 20}, {10, 1.45103}, {10, 0}}, color = {95, 95, 95}));
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-05, Interval = 0.001), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
This example models a hinged, three-panel mechanism. Rotational springs are connected across each of the two hinges to actuate them. Additionally,  <b>RotationalStop</b> blocks are used to prevent each hinge from opening beyond 90&deg.
  </html>"));
end DoubleDoor_Deploy;
