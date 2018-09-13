within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Triangle "Interface for 3D animation of triangle surface"
  extends Surface;
  final parameter String surfaceType = "Triangle" annotation(Evaluate=true);
  final parameter Integer N = 3 annotation(Evaluate=true);
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Triangle;
