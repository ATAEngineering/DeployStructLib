within DeployStructLib.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function CalculatePolyCoeffs "Calculate the coefficients of a polynomial"
input Real x[:];
input Real y[:];
output Real a[size(x,1)];
protected
Real A[size(x,1),size(x,1)];
algorithm
  for i in 1:size(x,1) loop
    A[:,i] := x.^(i-1);
  end for;
  a := Modelica.Math.Matrices.solve(A,y);
//
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));  
end CalculatePolyCoeffs;
