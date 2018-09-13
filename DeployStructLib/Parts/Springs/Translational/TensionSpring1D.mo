within DeployStructLib.Parts.Springs.Translational;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model TensionSpring1D
  "Linear 1D translational spring that only exerts force when in tension"
  extends Modelica.Mechanics.Translational.Interfaces.PartialCompliantWithRelativeStates;
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;
  parameter SI.TranslationalSpringConstant c(final min = 0) "Tension spring constant";
  parameter SI.Position s_rel0 = 0 "Unstretched spring length";
  parameter SI.TranslationalDampingConstant d(final min = 0) = 0 "Damping constant";
  parameter Boolean use_events = true "=true, if an event should be used to find changes in tension state" annotation(Evaluate=true);
protected
  Boolean compression "=true, if in compression, otherwise in tension";
  Modelica.SIunits.Force f_d "Damping force";
equation
  if use_events then
    compression = s_rel < s_rel0;
  else
    compression = noEvent(s_rel < s_rel0);
  end if;
  f_d = noEvent(if compression then 0.0 else d * der(s_rel));
  f = semiLinear(s_rel - s_rel0, c, 0.0) + f_d;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info = "<HTML>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Spring block in the Mechanics.Translation.Components package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</HTML>"));
end TensionSpring1D;
