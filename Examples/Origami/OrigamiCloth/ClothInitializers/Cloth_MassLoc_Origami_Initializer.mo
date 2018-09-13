within DeployStructLib.Examples.Origami.OrigamiCloth.ClothInitializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_MassLoc_Origami_Initializer
  import Modelica.Math.Vectors;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Utilities.Streams.print;
  import Modelica.Constants.pi;
  import SI = Modelica.SIunits;
  import DeployStructLib;
  input Integer M, H, R, J;
  input Real Rad "Inner polygon radius";
  input Boolean start_closed = true;
  input Boolean debug = false;
//  output Real massLoc[M, (H*R+1)*(H*R+1), 3];
  output Real massLoc[M, J, 3];
algorithm
  //
  for k in 1:M loop
    for j in 0:H*R loop
      for i in 0:H*R loop
        if start_closed then
          massLoc[k, j*(H*R+1)+(i+1), :] := OrigamiClosedPoint.OrigamiClosedPoint(i, j, k, M, H, R, Rad);
        else
          massLoc[k, j*(H*R+1)+(i+1), :] := OrigamiClosedPoint.OrigamiOpenPoint(i, j, k, M, H, R, Rad);
        end if;
      end for;
    end for;
  end for;
annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_MassLoc_Origami_Initializer;
