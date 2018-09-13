within DeployStructLib.Examples;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model SolarSail "A model of a lightweight solar blanket deploying"
  extends Modelica.Icons.Example;
  //
  parameter Integer N = 3;
  inner Modelica.Mechanics.MultiBody.World world(g = 0) annotation(
    Placement(visible = true, transformation(origin = {-200, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.VariableLengthBeam variableLengthBeam1(L_start = 0.5, angles_start(displayUnit = "rad"), matProp = matprop, phi(displayUnit = "rad"), rho(displayUnit = "kg/m3"), xprop = xprop) annotation(
    Placement(visible = true, transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb annotation(
    Placement(visible = true, transformation(origin = {-88, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.BeamXProperties.RectTubeProperty xprop annotation(
    Placement(visible = true, transformation(origin = {-56, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.MaterialProperties.isotropicMaterialProperty matprop(E = 70e9, beta = 0.01, nu = 0.33, rho(displayUnit = "kg/m3") = 2700) annotation(
    Placement(visible = true, transformation(origin = {-26, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step1(height = 0.1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-82, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Utilities.Body body1(angles_start(displayUnit = "rad"), m = 1, phi(displayUnit = "rad"), r_CM = {0, 0, 0}) annotation(
    Placement(visible = true, transformation(origin = {10, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.VariableLengthBeam variableLengthBeam2(L_start = 0.5, angles_start(displayUnit = "rad"), matProp = matprop, phi(displayUnit = "rad"), rho(displayUnit = "kg/m3"), xprop = xprop) annotation(
    Placement(visible = true, transformation(origin = {-2, -68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DeployStructLib.Parts.VariableLengthBeam variableLengthBeam3(L_start = 0.5, angles_start(displayUnit = "rad"), matProp = matprop, phi(displayUnit = "rad"), rho(displayUnit = "kg/m3"), xprop = xprop) annotation(
    Placement(visible = true, transformation(origin = {-2, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.VariableLengthBeam variableLengthBeam4(L_start = 0.5, angles_start(displayUnit = "rad"), matProp = matprop, phi(displayUnit = "rad"), rho(displayUnit = "kg/m3"), xprop = xprop) annotation(
    Placement(visible = true, transformation(origin = {-74, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Mechanics.MultiBody.Parts.Fixed fixed1 annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Orientation.Orient_plus90Z orient_plus90Z1 annotation(
    Placement(visible = true, transformation(origin = {-4, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Orientation.Orient_minus90Z orient_minus90Z1 annotation(
    Placement(visible = true, transformation(origin = {-4, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.MultiBody.Parts.FixedRotation fixedRotation1(angle = 180, n = {0, 0, 1}) annotation(
    Placement(visible = true, transformation(origin = {-36, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.cloth sail(M = N, N = N, P1 = {0.5, 0, 0}, P1_start = {0.5, 0, 0}, P2 = {0, 0.5, 0}, P2_start = {0, 0.5, 0}, P3 = {-0.5, 0, 0}, P3_start = {-0.5, 0, 0}, P4 = {0, -0.5, 0}, P4_start = {0, -0.5, 0}, clothPropsData = clothprop, m = 1, useSideAFrame = false, useSideBFrame = false) annotation(
    Placement(visible = true, transformation(origin = {60, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.ClothProperty clothprop(E = 1e1, area_density = 0.01, nu = 0, thickness = 1e-4) annotation(
    Placement(visible = true, transformation(origin = {52, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Interfaces.Location2Frame location2Frame1 annotation(
    Placement(visible = true, transformation(origin = {102, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Interfaces.Location2Frame location2Frame2 annotation(
    Placement(visible = true, transformation(origin = {-2, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Cloth.Interfaces.Location2Frame location2Frame3 annotation(
    Placement(visible = true, transformation(origin = {-100, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  DeployStructLib.Parts.Cloth.Interfaces.Location2Frame location2Frame4 annotation(
    Placement(visible = true, transformation(origin = {-2, -96}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  DeployStructLib.Parts.Cloth.Springs.Extension extension1(k = 1000, s_0 = 0.01) annotation(
    Placement(visible = true, transformation(origin = {134, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Springs.Extension extension2(k = 1000, s_0 = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-2, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  DeployStructLib.Parts.Cloth.Springs.Extension extension3(k = 1000, s_0 = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-130, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  DeployStructLib.Parts.Cloth.Springs.Extension extension4(k = 1000, s_0 = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-2, -124}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(location2Frame4.location, extension4.location_a) annotation(
    Line(points = {{-2, -106}, {-2, -106}, {-2, -114}, {-2, -114}}, color = {95, 95, 95}));
  connect(location2Frame3.location, extension3.location_a) annotation(
    Line(points = {{-110, 6}, {-120, 6}, {-120, 6}, {-120, 6}}, color = {95, 95, 95}));
  connect(extension1.location_a, location2Frame1.location) annotation(
    Line(points = {{124, 0}, {112, 0}, {112, 0}, {112, 0}}, color = {95, 95, 95}));
  connect(extension2.location_a, location2Frame2.location) annotation(
    Line(points = {{-2, 114}, {-2, 114}, {-2, 104}, {-2, 104}, {-2, 104}, {-2, 104}}, color = {95, 95, 95}));
  connect(variableLengthBeam2.frame_b, location2Frame4.frame_a) annotation(
    Line(points = {{-2, -78}, {-2, -78}, {-2, -86}, {-2, -86}}, color = {95, 95, 95}));
  connect(location2Frame1.frame_a, variableLengthBeam1.frame_b) annotation(
    Line(points = {{92, 0}, {84, 0}, {84, 0}, {84, 0}}, color = {95, 95, 95}));
  connect(location2Frame2.frame_a, variableLengthBeam3.frame_b) annotation(
    Line(points = {{-2, 84}, {-2, 84}, {-2, 78}, {-2, 78}}, color = {95, 95, 95}));
  connect(location2Frame3.frame_a, variableLengthBeam4.frame_b) annotation(
    Line(points = {{-90, 6}, {-84, 6}, {-84, 6}, {-84, 6}}, color = {95, 95, 95}));
  connect(fixed1.frame_b, body1.frame_a) annotation(
    Line(points = {{-20, -20}, {-20, 4}, {0, 4}}, color = {95, 95, 95}));
  connect(fixedRotation1.frame_b, variableLengthBeam4.frame_a) annotation(
    Line(points = {{-46, 8}, {-64, 8}, {-64, 6}, {-64, 6}}, color = {95, 95, 95}));
  connect(body1.frame_a, fixedRotation1.frame_a) annotation(
    Line(points = {{0, 4}, {-26, 4}, {-26, 8}, {-26, 8}}, color = {95, 95, 95}));
  connect(body1.frame_a, variableLengthBeam1.frame_a) annotation(
    Line(points = {{0, 4}, {64, 4}, {64, 0}, {64, 0}}, color = {95, 95, 95}));
  connect(orient_minus90Z1.frame_b, variableLengthBeam2.frame_a) annotation(
    Line(points = {{-4, -32}, {-2, -32}, {-2, -58}}, color = {95, 95, 95}));
  connect(step1.y, variableLengthBeam2.dL_in) annotation(
    Line(points = {{-70, -42}, {-8, -42}, {-8, -56}}, color = {0, 0, 127}));
  connect(body1.frame_a, orient_minus90Z1.frame_a) annotation(
    Line(points = {{0, 4}, {-4, 4}, {-4, -12}, {-4, -12}}, color = {95, 95, 95}));
  connect(orient_plus90Z1.frame_b, variableLengthBeam3.frame_a) annotation(
    Line(points = {{-4, 38}, {-2, 38}, {-2, 58}, {-2, 58}}, color = {95, 95, 95}));
  connect(body1.frame_a, orient_plus90Z1.frame_a) annotation(
    Line(points = {{0, 4}, {0, 11}, {-4, 11}, {-4, 18}}, color = {95, 95, 95}));
  connect(step1.y, variableLengthBeam3.dL_in) annotation(
    Line(points = {{-70, -42}, {4, -42}, {4, 56}}, color = {0, 0, 127}));
  connect(step1.y, variableLengthBeam4.dL_in) annotation(
    Line(points = {{-70, -42}, {-62, -42}, {-62, 12}, {-62, 12}}, color = {0, 0, 127}));
  connect(step1.y, variableLengthBeam1.dL_in) annotation(
    Line(points = {{-71, -42}, {62, -42}, {62, -6}}, color = {0, 0, 127}));
//
  connect(extension1.location_b, sail.sideAloc[1]) annotation(
    Line);
  connect(extension2.location_b, sail.sideAloc[N + 1]) annotation(
    Line);
  connect(extension3.location_b, sail.sideBloc[N + 1]) annotation(
    Line);
  connect(extension4.location_b, sail.sideBloc[1]) annotation(
    Line);
//
  annotation(
    uses(Modelica(version = "3.2.2")),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    version = "",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "dassl", emit_protected = "()"), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end SolarSail;
