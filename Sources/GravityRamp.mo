within DeployStructLib.Sources;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function GravityRamp "Function to ramp the gravitational acceleration, for quasi-static analysis"
  extends Modelica.Mechanics.MultiBody.Interfaces.partialGravityAcceleration;
  import SI = Modelica.SIunits;
  input Real g_level = 1.0;
  input Real offset = 0.5;
  input Real ramp_duration = 2.0;
  input Real[3] n "Gravity normal" annotation(Dialog);
  input Real t;
algorithm
  if t < offset then
    gravity := 0 * n;
  elseif t > offset + ramp_duration then
    gravity := g_level * n;
  else
    gravity := g_level * n * (t - offset) / ramp_duration;
  end if;

annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));	
end GravityRamp;
