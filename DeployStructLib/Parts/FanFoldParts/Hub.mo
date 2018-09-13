within DeployStructLib.Parts.FanFoldParts;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Hub "Basic model of a hub for a fan-fold array"
  import SI = Modelica.SIunits;
  parameter Integer S "Number of hinges";
  parameter Real damping = 0.0 "Damping to be applied to each hinge";
  parameter SI.Angle[S] phi_start = zeros(S);
  parameter Boolean fix_phi_start = true;
  parameter Boolean driven = false "Should the first revolute joint be driven?";
  parameter SI.AngularVelocity driven_speed = 1.0 "If driven, speed at which to drive";
  Modelica.Mechanics.MultiBody.Joints.Revolute[S] revolute(phi(start = phi_start, each fixed = fix_phi_start), each w(start = 0, fixed = true), each useAxisFlange = true);
  Modelica.Mechanics.Rotational.Components.Damper[S] damper(each d = damping, each phi_rel(start = 0.0));
  outer Modelica.Mechanics.MultiBody.World world;
  Modelica.Mechanics.Rotational.Sources.ConstantSpeed speedSource(w_fixed = driven_speed) if driven;
equation
  if revolute[1].angle >= 2*Modelica.Constants.pi then
    terminate("Angle of revolute[1] is greater than 2pi.");
  end if;
  for j in 1:S loop
    connect(revolute[j].frame_a, world.frame_b);
    connect(revolute[j].axis, damper[j].flange_b);
    connect(revolute[j].support, damper[j].flange_a);
  end for;
  if driven then
    connect(revolute[1].axis, speedSource.flange);
  end if;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Ellipse(origin = {-10.28, -10.17}, fillPattern = FillPattern.Solid, lineThickness = 10, extent = {{34.14, 32.71}, {-17.57, -19.45}}, endAngle = 360), Line(origin = {-2.43, 54.7}, points = {{-0.220994, -22.6519}, {-0.220994, 20.884}}, thickness = 5), Line(origin = {-1.66, -55.91}, points = {{-0.220994, -22.6519}, {-0.220994, 20.884}}, thickness = 5), Line(origin = {56.02, -1.77}, rotation = -90, points = {{-0.220994, -22.6519}, {-0.220994, 20.884}}, thickness = 5), Line(origin = {-60.44, -0.88}, rotation = 90, points = {{-0.220994, -22.6519}, {-0.220994, 20.884}}, thickness = 5), Text(origin = {-50.83, -60.44}, extent = {{-30.72, 11.16}, {30.72, -11.16}}, textString = "Hub")}),
  Documentation(info="<html>
  <p>
  This block models a hub for a fan-fold solar array. It consists of <i>S</i> concentric <b>Revolute</b> joints. Damping can be applied to the joints by setting a value for the \"damping\" parameter. The starting angle of each hinge can be set through the \"phi_start\" array; the units of the angles should be radians. 
  </p>
  <p>
  Optionally, the first hinge of the hub can be driven at a constant speed. This behavior can be activated by setting the \"driven\" flag to true and by specifying a speed at which to drive the hinge through the \"driven_speed\" parameter (units of rad/s).
  </p>
  <p>
  This block also contains a terminate condition. When the angle of the first hinge reaches an angle >= 2pi, the \"terminate\" statement will be called.
  </p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Hub;
