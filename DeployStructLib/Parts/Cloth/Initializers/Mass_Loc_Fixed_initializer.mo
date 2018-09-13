within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Mass_Loc_Fixed_initializer
"Function for determining which mass locations should be fixed in space."
//
input Integer M, N;
output Boolean[M+1, N+1] B;
//
algorithm
for i in 1:M+1 loop
  for j in 1:N+1 loop
    //if (i == 1) or (i == M+1) or (j == 1) or (j == N+1) then
    if (i == 1) or (i == M+1) then
      B[i,j] := true;
    else
      B[i, j] := false;
    end if;
  end for;
end for;

annotation(Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Mass_Loc_Fixed_initializer;
