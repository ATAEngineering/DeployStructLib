within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model FixedLocation
  "Block for setting applying a fixed location to a cloth mass's location."
  DeployStructLib.Parts.Cloth.Interfaces.Location location annotation(Placement(visible = true, transformation(origin = {-38, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-38, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Real r[3] = {0, 0, 0} "Position vector from world frame to frame_b, resolved in world frame";
  //
equation
  location.r_0 = r;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end FixedLocation;
