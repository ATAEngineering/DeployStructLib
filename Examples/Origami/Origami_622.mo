within DeployStructLib.Examples.Origami;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Origami_622 "Model of an origami blanket with M = 6"
  extends Modelica.Icons.Example;
  import pi = Modelica.Constants.pi;
  parameter Real Rad = 1.0 "Inner polygon radius";
  parameter Integer M = 6;
  parameter Integer H = 2;
  parameter Integer R = 2;
  parameter Real f_rad = 1.0;
  parameter Real f_tan = -1.0;
  parameter Real[M, 3] r_fixed = array(OrigamiCloth.ClothInitializers.OrigamiClosedPoint.OrigamiClosedPoint(0, 0, k, M, H, R, Rad) for k in 1:M);
  Real[M, 3] raddir1, raddir2;
  Real[M, 3] tandir1, tandir2;
  OrigamiCloth.ClothOrigami clothorigami(M = M, H = H, R = R, Rad = Rad, clothPropsData = clothProperty) annotation(Placement(visible = true, transformation(origin = {-6, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner Modelica.Mechanics.MultiBody.World world(g = 0.0) annotation(Placement(visible = true, transformation(origin = {-66, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  inner DeployStructLib.DSL_Globals DSLglb(SteadyState = false) annotation(Placement(visible = true, transformation(origin = {-46, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter DeployStructLib.Properties.ClothProperty clothProperty(area_density = 1.0, thickness = 0.001, E = 1e6, nu = 0.3) annotation(Placement(visible = true, transformation(origin = {-46, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Utilities.LocationForce[M] locationforce1 annotation(Placement(visible = true, transformation(origin = {42, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Utilities.LocationForce[M] locationforce2 annotation(Placement(visible = true, transformation(origin = {42, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DeployStructLib.Parts.Cloth.Utilities.FixedLocation[M] fixedlocation(r = r_fixed) annotation(Placement(visible = true, transformation(origin = {10, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  for i in 1:M loop
    connect(fixedlocation[i].location, clothorigami.mass[i, 1].location);
    connect(locationforce1[i].location, clothorigami.mass[i, (H * R + 1) * (H * R + 1)].location);
    connect(locationforce2[i].location, clothorigami.mass[i, H * R + 1].location);
    //
    // Hack to deal with weird OpenModelica array access issues
    for j in 1:3 loop
      raddir1[i,j] = Math.MyNormalize(locationforce1[i].location.r_0,j);
      tandir1[i,j] = Math.MyCross({0, 0, 1}, Modelica.Math.Vectors.normalize(locationforce1[i].location.r_0),j);
      raddir2[i,j] = Math.MyNormalize(locationforce2[i].location.r_0,j);
      tandir2[i,j] = Math.MyCross({0, 0, 1}, Modelica.Math.Vectors.normalize(locationforce2[i].location.r_0),j);
    end for;
    //
    locationforce1[i].force = f_rad * {raddir1[i, 1], raddir1[i, 2], 0} + f_tan * {tandir1[i, 1], tandir1[i, 2], 0};
    locationforce2[i].force = f_rad * {raddir2[i, 1], raddir2[i, 2], 0} + f_tan * {tandir2[i, 1], tandir2[i, 2], 0};
  end for;
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Origami_622;
