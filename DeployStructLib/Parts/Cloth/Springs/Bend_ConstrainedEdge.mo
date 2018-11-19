within DeployStructLib.Parts.Cloth.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Bend_ConstrainedEdge
  "Spring for modeling bending stiffness of a constrained edge of a cloth block."
  import SI = Modelica.SIunits;
  import pi = Modelica.Constants.pi;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Math.Vectors;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a ref_frame annotation(Placement(transformation(extent = {{-116, -16}, {-84, 16}}, rotation = 0)));
  Interfaces.Location location_b annotation(Placement(transformation(extent = {{84, -16}, {116, 16}}, rotation = 0)));
  //
  parameter SI.TranslationalSpringConstant k "Spring stiffness";
  parameter Real d = 0.01 "Damping";
  parameter Real[3] tangent_vector = {0, 1, 0} "Tangent vector w.r.t. (local) ref_frame at which cloth angle is contrained, points in direction of cloth";
  parameter Real[3] bending_vector = {0, 0, 1} "Vector w.r.t. ref_frame that (with tangent_vector) defines the plane in which bending occurs";
  //
  Real[3] rcb;
  Real[3] normal "vector normal to tangent-bending plane (=tangentXbending) in world frame";
  Real[3] proj_b "projection of location_b onto tangent-bending plane";
  Real a, xb, yb;
  //
  SI.Torque m, mf, md;
  SI.Force[3] f_b "Line force acting on frame_a and on frame_b (positive, if acting on frame_b and directed from frame_a to frame_b)";
  Frames.Orientation R_bend;
  //
equation
  //
  rcb = Frames.resolve2(ref_frame.R, location_b.r_0 - ref_frame.r_0);
  normal = Vectors.normalize(cross(tangent_vector, bending_vector));
  R_bend = Frames.from_nxy(tangent_vector, bending_vector);
  //
  proj_b = Frames.resolve2(R_bend, rcb);
  //
  xb=proj_b[1];
  yb=proj_b[2];
  //
  a = yb / xb^2;
  mf = k * a;
  md = d * 0.0;//der(a);
  m = mf + md;
  //
  f_b = m * cross(normal, proj_b);
  //
  location_b.f = Frames.resolve1(ref_frame.R, f_b);
  ref_frame.f = -f_b;
  ref_frame.t = -m * normal;
  //
  annotation(Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}, initialScale = 0.1, grid = {10, 10}), graphics = {Line(visible = true, points = {{-100.0, 0.0}, {-58.0, 0.0}, {-43.0, -30.0}, {-13.0, 30.0}, {17.0, -30.0}, {47.0, 30.0}, {62.0, 0.0}, {100.0, 0.0}}), Text(visible = true, lineColor = {0, 0, 255}, extent = {{-130.0, 49.0}, {132.0, 109.0}}, textString = "%name", fontName = "Arial"), Text(visible = true, fillPattern = FillPattern.Solid, extent = {{-141.0, -92.0}, {125.0, -51.0}}, textString = "k=%k", fontName = "Arial")}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics), Documentation(info = "<HTML>
          <p> A spring modeling bending in the spring/mass cloth formulation.
          </p>
          <p>
          Copyright &copy; 2018<br>
          ATA ENGINEERING, INC.<br>
          ALL RIGHTS RESERVED
          </p>

          </HTML>"));
end Bend_ConstrainedEdge;
