within DeployStructLib.Math.FindCatenaryCoeff;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function f "Calculate the function"
  input Real a, s, h;
  output Real val;
algorithm
  val := 2 * a * sinh(0.5 * h / a) - s;
  annotation(Inline = true);
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end f;
