within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_Origami_TriNodeInd_Initializer
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, H, R, J;
  input Boolean debug = false;
  output Integer Ind[M, J, 3, 2];
protected
  Integer min1;
  Integer N;
  Integer count;
  Integer ii, jj;
  Integer section;
algorithm
  //
  N := R * H;
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
          Ind[k, count, 1, 1] := jj*(H*R+1) + (i+1);
          Ind[k, count, 1, 2] := k;
          if i < 1 then
            Ind[k, count, 3, 1] := 1;
            Ind[k, count, 3, 2] := section;
          else
            Ind[k, count, 3, 1] := jj*(H*R+1) + (i);
            Ind[k, count, 3, 2] := k;
          end if;
          Ind[k, count, 2, 1] := min1*(H*R+1) + (i+1);
          Ind[k, count, 2, 2] := k;
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
          section := k-1;
          if section < 1 then
            section := M;
          end if;
          min1 := min(ii + H, j - 1);
          if ii < 0 then
            Ind[k, count, 1, 1] := 2;
            Ind[k, count, 1, 2] := section;
            Ind[k, count, 3, 1] := 1;
            Ind[k, count, 3, 2] := section;
          else
            Ind[k, count, 1, 1] := j*(H*R+1) + (ii+1);
            Ind[k, count, 1, 2] := k;
            Ind[k, count, 3, 1] := (j-1)*(H*R+1) + (ii+1);
            Ind[k, count, 3, 2] := k;
          end if;
          Ind[k, count, 2, 1] := j*(H*R+1) + (min1+1);
          Ind[k, count, 2, 2] := k;
          if debug then
            print("g,j,ii,Ind[1:3]: "+String(g)+","+String(j)+","+String(ii)+","+String(Ind[k, count, 1, 1])+","+String(Ind[k, count, 2, 1])+","+String(Ind[k, count, 3, 1])+"\n");
          end if;
          count := count + 1;
        end if;
      end for;
    end for;
  end for;
  //
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_Origami_TriNodeInd_Initializer;
