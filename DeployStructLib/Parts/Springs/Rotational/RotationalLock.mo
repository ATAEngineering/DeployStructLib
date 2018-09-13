within DeployStructLib.Parts.Springs.Rotational;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model RotationalLock "Linear 1D rotational spring acting as a lock to stop reverse rotation"
  import SI = Modelica.SIunits;
  parameter SI.RotationalSpringConstant c_lock(final min = 0, start = 1.0e5) "Spring constant of lock";
  parameter SI.Angle phi_lock = 0 "Equilibrium spring angle where lock is engaged (rad)";
  final parameter Boolean freeplay_dir_pos = false "Is direction of lock free-play in positive angle?" annotation(Evalutate=true);
  extends Modelica.Mechanics.Rotational.Interfaces.PartialCompliant;
  Boolean locked(start = false);
algorithm
  if freeplay_dir_pos then
    if phi_rel > phi_lock then
	locked := true;
    else
        locked := locked;
    end if;
  else
    if phi_rel < phi_lock then
	locked := true;
    else
        locked := locked;
    end if;
  end if;
equation
  if freeplay_dir_pos then
    if locked then
      tau = if(phi_rel - phi_lock) > 0 then 0.0 else c_lock * (phi_rel - phi_lock);
    else
      tau = 0.0;
    end if;
  else
    if locked then
      tau = if(phi_rel - phi_lock) > 0 then c_lock * (phi_rel - phi_lock) else 0.0;
    else
      tau = 0.0;
    end if;
  end if;
  //
  annotation(Documentation(info = "<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.Rotational.Components package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
A <b>spring</b> element acting only in one direction as a rotational lock to stop rotation in the reverse direction.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-80, 32}, {-58, 32}, {-43, 2}, {-13, 62}, {17, 2}, {47, 62}, {62, 32}, {80, 32}}, color = {0, 0, 0}, thickness = 0.5), Line(points = {{-68, 32}, {-68, 97}}, color = {128, 128, 128}), Line(points = {{72, 32}, {72, 97}}, color = {128, 128, 128}), Line(points = {{-68, 92}, {72, 92}}, color = {128, 128, 128}), Polygon(points = {{62, 95}, {72, 92}, {62, 89}, {62, 95}}, lineColor = {128, 128, 128}, fillColor = {128, 128, 128}, fillPattern = FillPattern.Solid), Text(extent = {{-44, 79}, {29, 91}}, lineColor = {0, 0, 255}, textString = "phi_rel"), Rectangle(extent = {{-50, -20}, {40, -80}}, lineColor = {0, 0, 0}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid), Line(points = {{-50, -80}, {68, -80}}, color = {0, 0, 0}), Line(points = {{-50, -20}, {68, -20}}, color = {0, 0, 0}), Line(points = {{40, -50}, {80, -50}}, color = {0, 0, 0}), Line(points = {{-80, -50}, {-50, -50}}, color = {0, 0, 0}), Line(points = {{-80, 32}, {-80, -50}}, color = {0, 0, 0}), Line(points = {{80, 32}, {80, -50}}, color = {0, 0, 0}), Line(points = {{-96, 0}, {-80, 0}}, color = {0, 0, 0}), Line(points = {{96, 0}, {80, 0}}, color = {0, 0, 0})}), Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Line(origin = {-19.9768, 1.39373}, points = {{-79.0941, 0}, {-58, 0}, {-43, -30}, {-13, 30}, {17, -30}, {47, 30}, {62, 0}, {82.8107, 0}}), Text(lineColor = {0, 0, 255}, extent = {{-150, 56}, {150, 96}}, textString = "%name"), Text(extent = {{-150, -80}, {150, -50}}, textString = "c_lock=%c_lock"), Ellipse(visible = false, lineColor = {255, 0, 0}, extent = {{-70, 30}, {-130, -30}}, endAngle = 360), Text(visible = false, lineColor = {255, 0, 0}, extent = {{-62, 50}, {-140, 30}}, textString = "R=0"), Ellipse(visible = false, lineColor = {255, 0, 0}, extent = {{70, 30}, {130, -30}}, endAngle = 360), Text(visible = false, lineColor = {255, 0, 0}, extent = {{62, 50}, {140, 30}}, textString = "R=0"), Line(origin = {-18.5202, 33.2056}, points = {{74.8362, 28}, {15.331, 0}}, thickness = 5), Line(origin = {-17.4215, 57.1429}, points = {{80.6039, 0}, {80.3717, -107.549}}, thickness = 5)}));
end RotationalLock;
