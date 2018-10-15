within DeployStructLib.Examples.Origami.OrigamiCloth;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model ClothOrigami
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Interfaces;
  import Modelica.Mechanics.MultiBody.Forces;
  import Modelica.Math.Vectors;
  import DeployStructLib;
  //
  parameter Real Rad = 1.0 "Inner polygon radius";
  parameter Integer M = 3 annotation(Evaluate = true);
  parameter Integer H = 2 annotation(Evaluate = true);
  parameter Integer R(min=2) = 2 annotation(Evaluate = true); //Cannot be less than 2 in current implementation
  parameter Integer N = R * H;
  parameter Boolean steadyState_mass = DSLglb.SteadyState;
  parameter DeployStructLib.Properties.ClothProperty clothPropsData;
  //
  parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 0, 224} "Color of cloth" annotation(Dialog(enable = animation and not multiColoredSurface, colorSelector = true, group = "Material properties"));
  //
  //
  DeployStructLib.Parts.Cloth.Springs.NaturalQuad[M, H * R * (R + 1) - R] quad(Kqin = ClothInitializers.Cloth_Origami_Quad_Initializer(M, H, R, H * R * (R + 1) - R, Rad, clothPropsData.E, clothPropsData.G, clothPropsData.nu, clothPropsData.thickness), each beta = clothPropsData.beta, each color = color, each animation = true);
  DeployStructLib.Parts.Cloth.Springs.NaturalTriangle[M, 2 * R] tri(Kqin = ClothInitializers.Cloth_Origami_Tri_Initializer(M, H, R, 2 * R, Rad, clothPropsData.E, clothPropsData.G, clothPropsData.nu, clothPropsData.thickness), each beta = clothPropsData.beta, each color = color, each animation = true);
  //
  DeployStructLib.Parts.Cloth.Utilities.Mass[M, (H*R+1)*(H*R+1)] mass(m = ClothInitializers.Cloth_Mass_Origami_Initializer(M, H, R, (H*R+1)*(H*R+1), Rad, clothPropsData.area_density), each enforceStates = true, each steadyState = steadyState_mass, each isCoincident = false, r_0(start = ClothInitializers.Cloth_MassLoc_Origami_Initializer(M, H, R, (H*R+1)*(H*R+1), Rad)), each alpha = clothPropsData.alpha, each animation = true);
  //
parameter Integer[M, H * R * (R + 1) - R, 4, 2] QuadNodeInd = ClothInitializers.Cloth_Origami_QuadNodeInd_Initializer(M,H,R,H * R * (R + 1) - R);
parameter Integer[M, 2 * R, 3, 2] TriNodeInd = ClothInitializers.Cloth_Origami_TriNodeInd_Initializer(M,H,R,2 * R);
  //
  //
protected
  outer DeployStructLib.DSL_Globals DSLglb;
  //
equation
  //
  // Connect quads to their respective masses

  for k in 1:M loop
    for j in 1:H * R * (R + 1) - R loop
      for i in 1:4 loop
        connect(quad[k, j].location[i], mass[QuadNodeInd[k,j,i,2], QuadNodeInd[k,j,i,1]].location);
      end for;
    end for;
    for j in 1:2 * R loop
      for i in 1:3 loop
        connect(tri[k, j].location[i], mass[TriNodeInd[k,j,i,2], TriNodeInd[k,j,i,1]].location);
      end for;
    end for;
  end for;

  //
  //
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end ClothOrigami;
