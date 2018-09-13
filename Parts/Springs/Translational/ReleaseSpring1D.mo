within DeployStructLib.Parts.Springs.Translational;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model ReleaseSpring1D
  "Linear 1D translational spring that exerts no force when release condition is true"
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliantWithRelativeStates;
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;
  parameter SI.TranslationalSpringConstant c(final min = 0) "Compression spring constant";
  parameter SI.Position s_rel0 = 0 "Unstretched spring length";
  parameter SI.TranslationalDampingConstant d(final min = 0) = 0 "Damping constant";
  Boolean released(start = false);
protected
  Modelica.SIunits.Force f_d "Damping force";
equation
  f_d = d * der(s_rel);
  f = if released then 0.0 else c * (s_rel - s_rel0) + f_d;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info = "<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.Translational.Components package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

     </HTML>"));
end ReleaseSpring1D;
