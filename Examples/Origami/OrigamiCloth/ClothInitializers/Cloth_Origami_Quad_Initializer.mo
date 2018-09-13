within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_Origami_Quad_Initializer
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, H, R, J;
  input Real Rad "Inner polygon radius";
  input Real E "Elastic modulus";
  input Real G "Shear modulus";
  input Real nu "Poisson's ratio";
  input Real thickness "thickness";
  input Boolean debug = false;
//  output Real Kq[M, H * R * (R + 1) - R, 6, 10];
  output Real Kq[M, J, 6, 10];
protected
  Real[1, 1, 6, 10] Kqtmp;
  Integer min1, min2;
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
  //
  for k in 1:M loop
  count := 1;
    for g in 0:R - 1 loop
      for i in H * g:N loop
        jj := H * g;
        if min(jj + H, i) > jj then
          min1 := min(jj + H, i);
          min2 := min(jj + H, i + 1);
          tmp1 := OrigamiOpenPoint(i, jj, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(i - 1, jj, k, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(i - 1, min1, k, M, H, R, Rad);
          tmp4 := OrigamiOpenPoint(i, min2, k, M, H, R, Rad);
          Kqtmp := DeployStructLib.Parts.Cloth.Initializers.Cloth_NatQuad_Init(1, 1, E, G, nu, thickness, tmp1, tmp2, tmp3, tmp4, {0,0,0}, {0,0,0}, tmp1, tmp2, tmp3, tmp4);
          Kq[k, count, :, :] := Kqtmp[1, 1, :, :];
          count := count + 1;
        end if;
      end for;
    end for;
//
  // Special handling for g==0
      for j in 1:N loop
        ii := - 1;
        if min(ii + H, j - 2) > ii then
          min1 := min(ii + H, j - 2);
          min2 := min(ii + H, j - 1);
          tmp1 := OrigamiOpenPoint(j, 0, k-1, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(j-1, 0, k-1, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(min1, j - 1, k, M, H, R, Rad);
          tmp4 := OrigamiOpenPoint(min2, j, k, M, H, R, Rad);
          Kqtmp := DeployStructLib.Parts.Cloth.Initializers.Cloth_NatQuad_Init(1, 1, E, G, nu, thickness, tmp1, tmp2, tmp3, tmp4, {0,0,0}, {0,0,0}, tmp1, tmp2, tmp3, tmp4);
          Kq[k, count, :, :] := Kqtmp[1, 1, :, :];
          count := count + 1;
        end if;
      end for;
//
    for g in 1:R - 1 loop
      for j in H * g + 1:N loop
        ii := H * g - 1;
        if min(ii + H, j - 2) > ii then
          min1 := min(ii + H, j - 2);
          min2 := min(ii + H, j - 1);
          tmp1 := OrigamiOpenPoint(ii, j, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(ii, j - 1, k, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(min1, j - 1, k, M, H, R, Rad);
          tmp4 := OrigamiOpenPoint(min2, j, k, M, H, R, Rad);
          Kqtmp := DeployStructLib.Parts.Cloth.Initializers.Cloth_NatQuad_Init(1, 1, E, G, nu, thickness, tmp1, tmp2, tmp3, tmp4, {0,0,0}, {0,0,0}, tmp1, tmp2, tmp3, tmp4);
          Kq[k, count, :, :] := Kqtmp[1, 1, :, :];
          count := count + 1;
        end if;
      end for;
    end for;
  end for;
  //
  //
  //
  //
  //
  //
  //
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_Origami_Quad_Initializer;
