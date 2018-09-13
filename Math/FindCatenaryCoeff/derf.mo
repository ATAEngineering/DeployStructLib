within DeployStructLib.Math.FindCatenaryCoeff;
/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/
function derf "Calculate the derivative"
  input Real a, s, h;
  output Real val;
algorithm
  val := 2 * sinh(0.5 * h / a) - h / a * cosh(0.5 * h / a);
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end derf;
