within DeployStructLib.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function atan2_positive "Inverse tangent"
  import SI = Modelica.SIunits;
  input Real u1;
  input Real u2;
  output SI.Angle y;
algorithm
  y := atan2(u1 , u2);
  if y < 0 then
    y := y + 2*Modelica.Constants.pi;
  else
    y := y;
  end if;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),   Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),  
  Documentation(info="<html>
  <p>
  This function calculates y = atan2(u1, u2). If y < 0, this function returns y = y+2pi. Otherwise, it returns y.
  </p>
  <p>
  Copyright &copy; 2018<br>
  ATA ENGINEERING, INC.<br>
  ALL RIGHTS RESERVED
  </p>

  </html>"));
end atan2_positive;
