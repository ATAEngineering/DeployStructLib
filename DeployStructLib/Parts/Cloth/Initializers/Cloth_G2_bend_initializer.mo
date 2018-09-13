within DeployStructLib.Parts.Cloth.Initializers;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function Cloth_G2_bend_initializer
  "Initializer for calculating stiffness of G2_bend springs"
  import Modelica.Math.Vectors;
  import Modelica.Utilities.Streams.print;
  input Real[3] P1, P2, P3, P4;
  input Integer M, N;
  input Integer[:] M_ind;
  input Integer[:] N_ind;
  input Real D;
  input Boolean debug = false;
  output Real[size(M_ind,1), size(N_ind,1)] k;
protected
  Real width;
  Real[M + 1] s = linspace(0, 1, M + 1);
  Real[N + 1] t = linspace(0, 1, N + 1);
algorithm
  for i in 1:size(M_ind, 1) loop
    for j in 1:size(N_ind, 1) loop
      if M_ind[i] == 1 then
        width := 0.5 * Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i] + 1], t[N_ind[j]]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i]], t[N_ind[j]]));
      elseif M_ind[i] == M + 1 then
        width := 0.5 * Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i]], t[N_ind[j]]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i] - 1], t[N_ind[j]]));
      else
        width := 0.5 * Vectors.norm(DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i] + 1], t[N_ind[j]]) - DeployStructLib.Math.CoonsPatch(P1, P2, P3, P4, s[M_ind[i] - 1], t[N_ind[j]]));
      end if;
      k[i, j] := D * width;
      if debug then
        print("D = " + String(D) + "\n");
        print("width = " + String(width) + "\n");
        print("M_ind = " + String(M_ind[i]) + "\n");
        print("N_ind = " + String(N_ind[j]) + "\n");
        print("k[" + String(i) + "," + String(j) + "] = " + String(k[i,j]) + "\n");
      end if;
    end for;
  end for;
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Cloth_G2_bend_initializer;
