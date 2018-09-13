within DeployStructLib.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function atanh "Inverse hyperbolic tangent"

  input Real x;
  output Real y;
algorithm
  y := 0.5 * Modelica.Math.log((1 + x) / (1 - x));
  annotation(Inline = true, Documentation(info = "<HTML>
     <p>
     This function returns y = atanh(x).
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>
     "));
end atanh;
