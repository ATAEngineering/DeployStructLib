within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Quadrangle "Interface for 3D animation of quadrangle shape"
  extends Surface;
  final parameter String surfaceType = "Quadrangle" annotation(Evaluate=true);
  final parameter Integer N = 4 annotation(Evaluate=true);

annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));  
end Quadrangle;
