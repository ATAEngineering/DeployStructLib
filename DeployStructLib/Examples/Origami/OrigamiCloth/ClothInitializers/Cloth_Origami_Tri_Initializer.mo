within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_Origami_Tri_Initializer
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, H, R, J;
  input Real Rad "Inner polygon raidus";
  input Real E "Elastic modulus";
  input Real G "Shear modulus";
  input Real nu "Poisson's ratio";
  input Real thickness "thickness";
  input Boolean debug = false;
  output Real Kq[M, J, 3, 7];
protected
  Real[1, 1, 3, 7] Kqtmp;
  Integer min1;
  Integer N;
  Integer count;
  Integer ii, jj;
  Real[3] tmp1;
  Real[3] tmp2;
  Real[3] tmp3;
  Real[3] tmp4;
algorithm
  //
  N := R * H;
  tmp4 := {0,0,0};
  //
  for k in 1:M loop
  count := 1;
    for g in 0:R - 1 loop
      for i in H * g:N loop
        jj := H * g;
        if min(jj + H, i) == jj then
          min1 := min(jj + H, i + 1);
          tmp1 := OrigamiOpenPoint(i, jj, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(i - 1, jj, k, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(i, min1, k, M, H, R, Rad);
          Kqtmp := DeployStructLib.Parts.Cloth.Initializers.Cloth_NatTri_Init(1, 1, E, G, nu, thickness, 1, tmp1, tmp2, tmp4, tmp3);
          Kq[k, count, :, :] := Kqtmp[1, 1, :, :];
          count := count + 1;
        end if;
      end for;
    end for;
//
//
    for g in 0:R - 1 loop
      for j in H * g + 1:N loop
        ii := H * g - 1;
        if min(ii + H, j - 2) == ii then
          min1 := min(ii + H, j - 1);
          tmp1 := OrigamiOpenPoint(ii, j, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(ii, j - 1, k, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(min1, j, k, M, H, R, Rad);
          Kqtmp := DeployStructLib.Parts.Cloth.Initializers.Cloth_NatTri_Init(1, 1, E, G, nu, thickness, 1, tmp1, tmp2, tmp4, tmp3);
          Kq[k, count, :, :] := Kqtmp[1, 1, :, :];
          count := count + 1;
        end if;
      end for;
    end for;
  end for;
  //
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_Origami_Tri_Initializer;
