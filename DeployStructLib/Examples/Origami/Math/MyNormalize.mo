within DeployStructLib.Examples.Origami.Math;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function MyNormalize
  "Calculate normalized vector such that length = 1 and prevent zero-division for zero vector and return only value at requested index"
  extends Modelica.Icons.Function;
  import Modelica.Math.Vectors;
  input Real v[:] "Real vector";
  input Integer ind "Index of output vector to return"; 
  output Real result "Input vector v normalized to length=1, at index provided";
  protected
  Real[size(v,1)] vecResult;

algorithm
  vecResult := Modelica.Math.Vectors.normalize(v);
  result := vecResult[ind];
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end MyNormalize;
