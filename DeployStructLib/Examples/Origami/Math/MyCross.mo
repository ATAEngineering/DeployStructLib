within DeployStructLib.Examples.Origami.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function MyCross "Compute the cross product of two vectors and return only the value at the specified index"
input Real[:] v1,v2;
input Integer ind "Return value of output vector at index ind";
output Real result;

protected
Real[size(v1,1)] outputVector;

algorithm
  outputVector := cross(v1,v2);
  result := outputVector[ind];
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end MyCross;
