within DeployStructLib.Parts.Cloth.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Extension
  "Spring for modeling extensional stiffness of a cloth block."
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Forces;
  import Modelica.Mechanics.MultiBody.Visualizers;
  Interfaces.Location location_a annotation(Placement(transformation(extent = {{-116, -16}, {-84, 16}}, rotation = 0)));
  Interfaces.Location location_b annotation(Placement(transformation(extent = {{84, -16}, {116, 16}}, rotation = 0)));
  parameter Boolean animation = true "= true, if animation shall be enabled";
  parameter SI.Position s_small = 0.000001 " Prevent zero-division if relative distance s=0" annotation(Dialog(tab = "Advanced"));
  SI.Force f "Line force acting on frame_a and on frame_b (positive, if acting on frame_b and directed from frame_a to frame_b)";
  //  Real fdot,fdotdot;
  SI.Position s(start = s_0) "(Guarded) distance between the origin of frame_a and the origin of frame_b (>= s_small))";
  Real e_a[3](each final unit = "1") "Unit vector on the line connecting the origin of frame_a with the origin of frame_b resolved in frame_a (directed from frame_a to frame_b)";
  SI.Position r_rel_a[3] "Position vector from origin of frame_a to origin of frame_b, resolved in frame_a";
  parameter SI.Length s_0 = 1.0 "Unstretched spring length";
  parameter SI.TranslationalSpringConstant k "Spring stiffness";
  parameter Real d = 0.01 "Damping";
  input SI.Distance width = world.defaultForceWidth " Width of spring" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input SI.Distance coilWidth = width / 10 " Width of spring coil" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  parameter Integer numberOfWindings = 5 " Number of spring windings" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Types.Color color = Modelica.Mechanics.MultiBody.Types.Defaults.SpringColor " Color of spring" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(tab = "Animation", group = "if animation = true", enable = animation));
  parameter Boolean steadyState = false;
protected
  outer Modelica.Mechanics.MultiBody.World world;
  Visualizers.Advanced.Shape lineShape(shapeType = "spring", color = color, specularCoefficient = specularCoefficient, length = s, width = width, height = coilWidth * 2, lengthDirection = e_a, widthDirection = cross(e_a, {0, 0, 1}), extra = numberOfWindings, r = location_a.r_0) if world.enableAnimation and animation;
//
initial equation
  if steadyState then
    s = s_0;
  end if;
//
equation
  r_rel_a = location_b.r_0 - location_a.r_0;
  s = noEvent(max(Modelica.Math.Vectors.length(r_rel_a), s_small));
  e_a = r_rel_a / s;
  location_a.f = -e_a * f;
  location_b.f = e_a * f;
  f = k * (s - s_0) + d * der(s);
//  
  annotation(Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}, initialScale = 0.1, grid = {10, 10}), graphics = {Line(visible = true, points = {{-100.0, 0.0}, {-58.0, 0.0}, {-43.0, -30.0}, {-13.0, 30.0}, {17.0, -30.0}, {47.0, 30.0}, {62.0, 0.0}, {100.0, 0.0}}), Text(visible = true, lineColor = {0, 0, 255}, extent = {{-130.0, 49.0}, {132.0, 109.0}}, textString = "%name", fontName = "Arial"), Text(visible = true, fillPattern = FillPattern.Solid, extent = {{-141.0, -92.0}, {125.0, -51.0}}, textString = "k=%k", fontName = "Arial")}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics), Documentation(info = "<HTML>
     <p>
     Spring for modeling extensional stiffness in the spring/mass formulation of the cloth block.
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>"));
end Extension;
