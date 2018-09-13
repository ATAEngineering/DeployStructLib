within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_Mass_Origami_Initializer
  import Modelica.Math.Vectors;
  import DeployStructLib;
  input Integer M, H, R, J;
  input Real Rad "Inner polygon radius";
  input Real area_density;
  input Boolean debug = false;
//  output Real mass[M, (H*R+1)*(H*R+1)];
  output Real mass[M, J];
protected
  Integer min1, min2;
  Integer N;
  Integer count;
  Real[3] tmp1;
  Real[3] tmp2;
  Real[3] tmp3;
  Integer ii, jj;
  Real tmpmass;
  Real a,b,c,s;
  Integer section;
algorithm
  //

for kk in 1:M loop
//for j in 1:(H*R+1)*(H*R+1) loop
for j in 1:size(mass,2) loop
mass[kk,j] := 1.0e-6;
	if debug then
  	  print("kk,j,mass[kk,j]: "+String(kk)+","+String(j)+","+String(mass[kk,j])+"\n");
	end if;
end for;
end for;

//

  N := R * H;
  //
  // Quads
  //
  for k in 1:M loop
  count := 1;

    for g in 0:R - 1 loop
      for i in H * g:N loop
        jj := H * g;
	if debug then
  	  print("k,g,i,jj: "+String(k)+","+String(g)+","+String(i)+","+String(jj)+","+String(count)+"\n");
	end if;
        if min(jj + H, i) > jj then
          min1 := min(jj + H, i);
          min2 := min(jj + H, i + 1);
          tmp1 := OrigamiOpenPoint(i - 1, min1, k, M, H, R, Rad) - OrigamiOpenPoint(i, jj, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(i - 1, jj, k, M, H, R, Rad) - OrigamiOpenPoint(i, min2, k, M, H, R, Rad);
          tmp3 := cross(tmp1, tmp2);
          tmpmass := 0.125 * area_density * Vectors.norm(tmp3);
          mass[k, jj*(H*R+1)+(i+1)] := mass[k, jj*(H*R+1)+(i+1)] + tmpmass;
          mass[k, min2*(H*R+1)+(i+1)] := mass[k, min2*(H*R+1)+(i+1)] + tmpmass;
          mass[k, min1*(H*R+1)+(i+0)] := mass[k, min1*(H*R+1)+(i+0)] + tmpmass;
          mass[k, jj*(H*R+1)+(i+0)] := mass[k, jj*(H*R+1)+(i+0)] + tmpmass;
          count := count + 1;
        end if;
      end for;
    end for;

  // Special handling for g==0
      for j in 1:N loop
        ii := - 1;
        if min(ii + H, j - 2) > ii then
          section := k-1;
          if section < 1 then
            section := M;
          end if;
          min1 := min(ii + H, j - 2);
          min2 := min(ii + H, j - 1);
          tmp1 := OrigamiOpenPoint(min1, j - 1, k, M, H, R, Rad) - OrigamiOpenPoint(j+1, 0, section, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(j, 0, section, M, H, R, Rad) - OrigamiOpenPoint(min2, j, k, M, H, R, Rad);
          tmp3 := cross(tmp1, tmp2);
          tmpmass := 0.125 * area_density * Vectors.norm(tmp3);
          mass[section, 0*(H*R+1)+(j+1)] := mass[section, 0*(H*R+1)+(j+1)] + tmpmass;
          mass[k, j*(H*R+1)+(min2+1)] := mass[k, j*(H*R+1)+(min2+1)] + tmpmass;
          mass[k, (j-1)*(H*R+1)+(min1+1)] := mass[k, (j-1)*(H*R+1)+(min1+1)] + tmpmass;
          mass[section, 0*(H*R+1)+(j)] := mass[section, 0*(H*R+1)+(j)] + tmpmass;
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
          tmp1 := OrigamiOpenPoint(min1, j - 1, k, M, H, R, Rad) - OrigamiOpenPoint(ii, j, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(ii, j - 1, k, M, H, R, Rad) - OrigamiOpenPoint(min2, j, k, M, H, R, Rad);
          tmp3 := cross(tmp1, tmp2);
          tmpmass := 0.125 * area_density * Vectors.norm(tmp3);
          mass[k, j*(H*R+1)+(ii+1)] := mass[k, j*(H*R+1)+(ii+1)] + tmpmass;
          mass[k, j*(H*R+1)+(min2+1)] := mass[k, j*(H*R+1)+(min2+1)] + tmpmass;
          mass[k, (j-1)*(H*R+1)+(min1+1)] := mass[k, (j-1)*(H*R+1)+(min1+1)] + tmpmass;
          mass[k, (j-1)*(H*R+1)+(ii+1)] := mass[k, (j-1)*(H*R+1)+(ii+1)] + tmpmass;
          count := count + 1;
        end if;
      end for;
    end for;

  end for;

  //
  // Tris
  //
  for k in 1:M loop
  count := 1;
    for g in 0:R - 1 loop
      for i in H * g:N loop
        jj := H * g;
        if min(jj + H, i) == jj then
          section := k-1;
          if section < 1 then
            section := M;
          end if;
          min1 := min(jj + H, i + 1);
          tmp1 := OrigamiOpenPoint(i, jj, k, M, H, R, Rad);
          tmp2 := OrigamiOpenPoint(i - 1, jj, k, M, H, R, Rad);
          tmp3 := OrigamiOpenPoint(i, min1, k, M, H, R, Rad);
          a := Modelica.Math.Vectors.length(tmp1 - tmp2);
          b := Modelica.Math.Vectors.length(tmp2 - tmp3);
          c := Modelica.Math.Vectors.length(tmp3 - tmp1);
          s := (a+b+c)/2;
          tmpmass := 1/12 * area_density * sqrt(s*(s-a)*(s-b)*(s-c));
          mass[k, jj*(H*R+1)+(i+1)] := mass[k, jj*(H*R+1)+(i+1)] + tmpmass;
          if i < 1 then
            mass[section, 1] := mass[section, 1] + tmpmass;
          else
            mass[k, jj*(H*R+1)+(i)] := mass[k, jj*(H*R+1)+(i)] + tmpmass;
          end if;
          mass[k, min1*(H*R+1)+(i+1)] := mass[k, min1*(H*R+1)+(i+1)] + tmpmass;
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
          a := Modelica.Math.Vectors.length(tmp1 - tmp2);
          b := Modelica.Math.Vectors.length(tmp2 - tmp3);
          c := Modelica.Math.Vectors.length(tmp3 - tmp1);
          s := (a+b+c)/2;
          tmpmass := 1/12 * area_density * sqrt(s*(s-a)*(s-b)*(s-c));
          if ii < 0 then
            mass[section, 2] := mass[section, 2] + tmpmass;
            mass[section, 1] := mass[section, 1] + tmpmass;
          else
            mass[k, j*(H*R+1)+(ii+1)] := mass[k, j*(H*R+1)+(ii+1)] + tmpmass;
            mass[k, (j-1)*(H*R+1)+(ii+1)] := mass[k, (j-1)*(H*R+1)+(ii+1)] + tmpmass;
          end if;
          mass[k, j*(H*R+1)+(min1+1)] := mass[k, j*(H*R+1)+(min1+1)] + tmpmass;
          count := count + 1;
        end if;
      end for;
    end for;
  end for;
//
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_Mass_Origami_Initializer;
