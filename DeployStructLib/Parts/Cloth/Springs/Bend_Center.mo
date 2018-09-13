within DeployStructLib.Parts.Cloth.Springs;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Bend_Center
  "Spring for modeling bending stiffness in the interior of a cloth block."
  import SI = Modelica.SIunits;
  import pi = Modelica.Constants.PI;
  import Modelica.Math.Vectors;
  Interfaces.Location location_a annotation(Placement(transformation(extent = {{-116, -16}, {-84, 16}}, rotation = 0)));
  Interfaces.Location location_b annotation(Placement(transformation(extent = {{84, -16}, {116, 16}}, rotation = 0)));
  Interfaces.Location location_c annotation(Placement(transformation(extent = {{-16, -16}, {16, 16}}, rotation = 90)));
  Interfaces.Location location_d annotation(Placement(transformation(extent = {{-16, -116}, {16, -84}}, rotation = 90)));
  Interfaces.Location location_e annotation(Placement(transformation(extent = {{-16, 116}, {16, 84}}, rotation = 90)));
  //
  Real[3] rca, rcb, rab, rcd, rce;
  Real[3] normal_dca, normal_bcd, normal_ecb, normal_ace;
  Real[3] normal, ipnormal;
  Real[3] proj_a, proj_b;
  Real rca_len, rcb_len;
  Real a, xa, xb, ya, yb;
  //
  SI.Torque m, mf, md;
  SI.Force[3] f_a, f_b "Line force acting on frame_a and on frame_b (positive, if acting on frame_b and directed from frame_a to frame_b)";
  parameter SI.TranslationalSpringConstant k "Spring stiffness";
  parameter Real d = 0.01 "Damping";
  //
equation
  //
  rab = location_b.r_0 - location_a.r_0;
  rca = location_a.r_0 - location_c.r_0;
  rcb = location_b.r_0 - location_c.r_0;
  rcd = location_d.r_0 - location_c.r_0;
  rce = location_e.r_0 - location_c.r_0;
  normal_dca = cross(rcd,rca);
  normal_bcd = cross(rcb,rcd);
  normal_ecb = cross(rce,rcb);
  normal_ace = cross(rca,rce);
  ipnormal = Vectors.normalize(cross(0.25*(normal_dca + normal_bcd + normal_ecb + normal_ace), rab));
  //
  proj_a = rca - rca.*ipnormal;
  proj_b = rcb - rcb.*ipnormal;
  //
  normal = Vectors.normalize(cross(proj_b, proj_a));
  f_a = m * cross(proj_a, normal);
  f_b = m * cross(normal, proj_b);
  //
  rca_len = Vectors.length(proj_a);
  rcb_len = Vectors.length(proj_b);
  //
  xb = Vectors.length(proj_b - proj_a * rcb_len/rca_len)/2.0;
  xa = -xb * rca_len/rcb_len;
  ya = if noEvent((rca_len^2 - xa^2) > 0.0) then sqrt(rca_len^2 - xa^2) else 0.0;
  yb = if noEvent((rcb_len^2 - xb^2) > 0.0) then sqrt(rcb_len^2 - xb^2) else 0.0;
  //
  a = (ya / xa - yb / xb) / (xa - xb);
  mf = k * a;
  md = d * 0.0;//der(a);
  m = mf + md;
  //
  location_a.f = f_a;
  location_b.f = f_b;
  zeros(3) = location_c.f + f_a + f_b ;
  location_d.f = zeros(3);
  location_e.f = zeros(3);
  //
  annotation(Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100.0, -100.0}, {100.0, 100.0}}, initialScale = 0.1, grid = {10, 10}), graphics = {Line(visible = true, points = {{-100.0, 0.0}, {-58.0, 0.0}, {-43.0, -30.0}, {-13.0, 30.0}, {17.0, -30.0}, {47.0, 30.0}, {62.0, 0.0}, {100.0, 0.0}}), Text(visible = true, lineColor = {0, 0, 255}, extent = {{-130.0, 49.0}, {132.0, 109.0}}, textString = "%name", fontName = "Arial"), Text(visible = true, fillPattern = FillPattern.Solid, extent = {{-141.0, -92.0}, {125.0, -51.0}}, textString = "k=%k", fontName = "Arial")}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics), Documentation(info = "<HTML>
          <p>
          A spring modeling the bending of springs, used in the spring/mass formulation. </p>
          <p>
          Copyright &copy; 2018<br>
          ATA ENGINEERING, INC.<br>
          ALL RIGHTS RESERVED
          </p>

          </HTML>"));
end Bend_Center;
