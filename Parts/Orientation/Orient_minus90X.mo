within DeployStructLib.Parts.Orientation;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Orient_minus90X "90 degree fixed rotation of frame_b with respect to frame_a about x-axis"

  import Modelica.Mechanics.MultiBody.Frames;

  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a
    "Coordinate system fixed to the component with one cut-force and cut-torque"
    annotation (Placement(transformation(extent={{-116,-16},{-84,16}},
          rotation=0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b
    "Coordinate system fixed to the component with one cut-force and cut-torque"
    annotation (Placement(transformation(extent={{84,-16},{116,16}}, rotation=
           0)));

  final parameter Frames.Orientation R_rel = Frames.from_nxy({1,0,0}, {0,0,-1}) "Fixed rotation object from frame_a to frame_b";

protected

  parameter Frames.Orientation R_rel_inv=Frames.from_T(transpose(R_rel.T),
      zeros(3)) "Inverse of R_rel (rotate from frame_b to frame_a)";

equation
  Connections.branch(frame_a.R, frame_b.R);
  assert(cardinality(frame_a) > 0 or cardinality(frame_b) > 0,
    "Neither connector frame_a nor frame_b of Orient_minus90X object is connected");

  /* Relationships between quantities of frame_a and frame_b */
  frame_b.r_0 = frame_a.r_0;
  if Connections.rooted(frame_a.R) then
    frame_b.R = Frames.absoluteRotation(frame_a.R, R_rel);
    zeros(3) = frame_a.f + Frames.resolve1(R_rel, frame_b.f);
    zeros(3) = frame_a.t + Frames.resolve1(R_rel, frame_b.t);
  else
    frame_a.R = Frames.absoluteRotation(frame_b.R, R_rel_inv);
    zeros(3) = frame_b.f + Frames.resolve1(R_rel_inv, frame_a.f);
    zeros(3) = frame_b.t + Frames.resolve1(R_rel_inv, frame_a.t);
  end if;

  annotation (
    Documentation(info="<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is a modification of the FixedRotation block in the Mechanics.MultiBody.Parts package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Modeling block for a <b>fixed rotation</b> of frame_b with respect
to frame_a such that the relationship between connectors frame_a and frame_b
remains constant. A family of blocks exist to provide pre-defined modeling blocks
for 90 degree rotations about each axis. These are provided primarily for
convienence and also to ensure that issues with gimbal lock are properly
avoided.
</p>
<p>
The family of blocks consist of:
</p>
<ul>
<li><b>Orient_plus90X</b> - rotate +90 degrees about the x-axis.</li>
<li><b>Orient_minus90X</b> - rotate -90 degrees about the x-axis.</li>
<li><b>Orient_plus90Y</b> - rotate +90 degrees about the y-axis.</li>
<li><b>Orient_minus90Y</b> - rotate -90 degrees about the y-axis.</li>
<li><b>Orient_plus90Z</b> - rotate +90 degrees about the z-axis.</li>
<li><b>Orient_minus90Z</b> - rotate -90 degrees about the z-axis.</li>
</ul>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"),
    Icon(coordinateSystem(
        initialScale = 0.1), graphics={Text(lineColor = {0, 0, 255}, extent = {{-150, 80}, {150, 120}}, textString = "%name"), Rectangle(fillPattern = FillPattern.Solid, extent = {{-100, 5}, {100, -4}}), Line(points = {{80, 20}, {129, 50}}), Line(points = {{80, 20}, {57, 59}}), Polygon(fillPattern = FillPattern.Solid, points = {{144, 60}, {117, 59}, {132, 37}, {144, 60}}), Polygon(fillPattern = FillPattern.Solid, points = {{43, 80}, {46, 50}, {68, 65}, {43, 80}}), Text(extent = {{-150, -50}, {150, -80}}, textString = "minus90X"), Text(lineColor = {128, 128, 128}, extent = {{-117, 51}, {-81, 26}}, textString = "a"), Text(lineColor = {128, 128, 128}, extent = {{84, -24}, {120, -49}}, textString = "b")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-100,-1},{-100,-66}}, color={128,128,128}),
        Line(points={{100,0},{100,-65}}, color={128,128,128}),
        Line(points={{-100,-60},{89,-60}}, color={128,128,128}),
        Text(
          extent={{-22,-36},{16,-60}},
          lineColor={128,128,128},
          textString="r"),
        Rectangle(
          extent={{-100,5},{100,-5}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{69,29},{97,45}},
          color={128,128,128},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{70,27},{55,54}},
          color={128,128,128},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{95,42},{109,31}},
          lineColor={128,128,128},
          textString="x"),
        Text(
          extent={{42,70},{57,58}},
          lineColor={128,128,128},
          textString="y"),
        Line(
          points={{-95,22},{-58,22}},
          color={128,128,128},
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          points={{-94,20},{-94,52}},
          color={128,128,128},
          arrow={Arrow.None,Arrow.Filled}),
        Text(
          extent={{-72,37},{-58,26}},
          lineColor={128,128,128},
          textString="x"),
        Text(
          extent={{-113,59},{-98,47}},
          lineColor={128,128,128},
          textString="y"),
        Polygon(
          points={{88,-56},{88,-65},{100,-60},{88,-56}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Orient_minus90X;
