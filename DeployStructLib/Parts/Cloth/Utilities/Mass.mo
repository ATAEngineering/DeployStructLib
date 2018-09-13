within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Mass
  "Block for modeling cloth mass"
  Interfaces.Location location annotation(Placement(visible = true, transformation(origin = {-120.0, -0.0}, extent = {{-16.0, -16.0}, {16.0, 16.0}}, rotation = 0), iconTransformation(origin = {-87.0196, 0.3652}, extent = {{-16.0, -16.0}, {16.0, 16.0}}, rotation = 0)));
  import SI = Modelica.SIunits;
  import C = Modelica.Constants;
  import Modelica.Math.*;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Visualizers;
  parameter Boolean animation = true "= true, if animation shall be enabled (show cylinder and sphere)";
  parameter Modelica.SIunits.Mass m(min = 0, start = 1) "Mass of rigid body";
  parameter Modelica.SIunits.Mass mass = if DSLglb.quasiStatic then DSLglb.quasiStaticFactor * m else m;
  parameter Real alpha = 0.0 "Mass proportional damping";
  Modelica.SIunits.Position r_0[3](each fixed = if isCoincident then false else not steadyState, each stateSelect = if isCoincident then StateSelect.never else if enforceStates then StateSelect.always else StateSelect.avoid) "Position vector from origin of world frame to origin of frame_a" annotation(Dialog(tab = "Initialization", __Dymola_initialDialog = true));
  Modelica.SIunits.Velocity v_0[3](start = {0, 0, 0}, each fixed = not isCoincident, each stateSelect = if isCoincident then StateSelect.never else if enforceStates then StateSelect.always else StateSelect.avoid) "Absolute velocity of frame_a, resolved in world frame (= der(r_0))" annotation(Dialog(tab = "Initialization", __Dymola_initialDialog = true));
  Modelica.SIunits.Acceleration a_0[3](start = {0, 0, 0}, each fixed = if isCoincident then false else steadyState) "Absolute acceleration of frame_a resolved in world frame (= der(v_0))" annotation(Dialog(tab = "Initialization", __Dymola_initialDialog = true));
  parameter Boolean enforceStates = false " = true, if absolute variables of body object shall be used as states (StateSelect.always)" annotation(Evaluate = true, Dialog(tab = "Advanced"));
  parameter Boolean isCoincident = false " = true, if mass is coincident with another body and enforce states and fixed status should be false (isCoincident flag overrides enforceStates and steadyState flags)";
  parameter Modelica.SIunits.Diameter sphereDiameter = world.defaultBodyDiameter "Diameter of sphere" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Modelica.Mechanics.MultiBody.Types.Color sphereColor = Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor "Color of sphere" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Modelica.Mechanics.MultiBody.Types.Color cylinderColor = sphereColor "Color of cylinder" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Modelica.Mechanics.MultiBody.Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  Modelica.SIunits.Acceleration g_0[3] "Gravity acceleration resolved in world frame";
  parameter Boolean steadyState = false;
protected
  outer Modelica.Mechanics.MultiBody.World world;
  outer DeployStructLib.DSL_Globals DSLglb;
  Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape sphere(shapeType = "sphere", color = sphereColor, specularCoefficient = specularCoefficient, length = sphereDiameter, width = sphereDiameter, height = sphereDiameter, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, r_shape = -{1, 0, 0} * sphereDiameter / 2, r = location.r_0) if world.enableAnimation and animation and sphereDiameter > 0;
//
equation
  r_0 = location.r_0;
  //Take this out when omc bug #3202 is fixed
  if DSLglb.useDSgravity then
    g_0 = world.g * Modelica.Math.Vectors.normalizeWithAssert(world.n);
  else
    g_0 = world.gravityAcceleration(r_0);
  end if;
  v_0 = der(location.r_0);
  a_0 = der(v_0);
  location.f = mass * a_0 - m * g_0 + alpha * mass * v_0;
  annotation(Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 30}, {-3, -31}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.HorizontalCylinder, fillColor = {0, 127, 255}), Text(extent = {{131, -123}, {-129, -73}}, lineColor = {0, 0, 0}, textString = "m=%m"), Text(extent = {{-128, 132}, {132, 72}}, textString = "%name", lineColor = {0, 0, 255}), Ellipse(extent = {{-20, 60}, {100, -60}}, lineColor = {0, 0, 0}, fillPattern = FillPattern.Sphere, fillColor = {0, 127, 255})}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}), graphics), Documentation(info = "<HTML>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end Mass;

