within DeployStructLib.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function asinh "Inverse hyperbolic sine"

  input Real x;
  output Real y;
algorithm
  y := Modelica.Math.log(x + sqrt(x ^ 2 + 1));
  annotation(Inline = true, Documentation(info = "<HTML>
     <p>
     This function returns y = asinh(x).
     </p>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>
     "));
end asinh;
