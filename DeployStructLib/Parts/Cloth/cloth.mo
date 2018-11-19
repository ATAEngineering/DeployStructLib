within DeployStructLib.Parts.Cloth;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth
  "Block for modeling flexible blankets, such as solar blankets"
  import Modelica.Mechanics.MultiBody.Frames;
  import SI = Modelica.SIunits;
  import Modelica.Math.Vectors;
  parameter Boolean flat = true;
  parameter Boolean FEcloth = true;
  parameter Boolean tri = false;
  parameter Boolean zFold = false;
  parameter Boolean addMass = true;
  parameter Integer M annotation(Evaluate = true);
  parameter Integer N annotation(Evaluate = true);
  parameter Integer m "For z-fold blanket, discretization per fold";
  parameter SI.Position P1[3] = {0, 0, 0};
  parameter SI.Position P2[3] = {0, 1, 0};
  parameter SI.Position P3[3] = {1, 1, 0};
  parameter SI.Position P4[3] = {1, 0, 0};
  parameter SI.Position P1_start[3] = {0, 0, 0} "Initial location of P1 in world coordinates";
  parameter SI.Position P2_start[3] = {0, 1, 0} "Initial location of P2 in world coordinates";
  parameter SI.Position P3_start[3] = {1, 1, 0} "Initial location of P3 in world coordinates";
  parameter SI.Position P4_start[3] = {1, 0, 0} "Initial location of P4 in world coordinates";
  parameter Real start_angle = 0.0;
  parameter SI.Position P1_loc[3] = {0, 0, 0} "Relative location of P1_start for initialization reference";
  parameter Real[3] ref_angles = {0, 0, 0} "Angles to describe orientation of P1 in space";
  parameter Integer[3] axes_sequence = {1, 2, 3} "Sequence of axes of 'ref_angles' to describe orientation of P1 in space";
  parameter Integer folds = 1 "Number of folds for z-fold array";
  parameter Properties.ClothProperty clothPropsData;
  //
  parameter Boolean useSideAFrame = true;
  parameter Boolean useSideBFrame = true;
  parameter Boolean dir_pos = false "If using zFold, should the folds point in the positive direction?";
  //
  final parameter Boolean constrainEdges = false;
  parameter Real[3] tangent_vector_sideA = {0, 1, 0} "Tangent vector w.r.t. ref_frame at which cloth angle is constrained";
  parameter Real[3] bending_vector_sideA = {0, 0, 1} "Vector w.r.t. ref_frame that (with tangent_vector) defines the plane in which bending occurs";
  parameter Real[3] tangent_vector_sideB = {0, -1, 0} "Tangent vector w.r.t. ref_frame at which cloth angle is constrained";
  parameter Real[3] bending_vector_sideB = {0, 0, -1} "Vector w.r.t. ref_frame that (with tangent_vector) defines the plane in which bending occurs";
  //
  parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 0, 224} "Color of cloth" annotation(Dialog(enable = animation and not multiColoredSurface, colorSelector = true, group = "Material properties"));
  //
  Utilities.cloth_flat clothInstanceFlat(M = M, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence) if flat and not tri and not FEcloth and not zFold;
  Utilities.cloth_flat_tri clothInstanceFlatTri(M = M, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence, useSideAFrame = useSideAFrame, useSideBFrame = useSideBFrame) if flat and tri and FEcloth and not zFold;
  Utilities.cloth_flat_quad clothInstanceFlatQuad(M = M, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence, useSideAFrame = useSideAFrame, useSideBFrame = useSideBFrame) if flat and not tri and FEcloth and not zFold;
  Utilities.cloth_bend clothInstanceBend(M = M, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence, start_angle = start_angle) if not flat and not tri and not FEcloth and not zFold;
  Utilities.cloth_zFold_quad clothInstanceZfoldQuad(M = 2*folds*m, N = N, P1 = P1, P2 = P2, P3 = P3, P4 = P4, P1_start = P1_start, P2_start = P2_start, P3_start = P3_start, P4_start = P4_start, clothPropsData = clothPropsData, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence, useSideBFrame = useSideBFrame, folds = folds, dir_pos=dir_pos) if zFold and FEcloth and not flat and not tri;
  //
  Parts.Cloth.Springs.Bend_ConstrainedEdge[1, N + 1] bend1sA(k = Initializers.Cloth_G1_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = {1}, N_ind = 1:N + 1), each d = clothPropsData.damping_bend, each tangent_vector = tangent_vector_sideA, each bending_vector = bending_vector_sideA) if constrainEdges;
  Parts.Cloth.Springs.Bend_ConstrainedEdge[1, N + 1] bend1sB(k = Initializers.Cloth_G1_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = {M + 1}, N_ind = 1:N + 1), each d = clothPropsData.damping_bend, each tangent_vector = tangent_vector_sideB, each bending_vector = bending_vector_sideB) if constrainEdges and useSideBFrame;
  //
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a[N+1] sideA if useSideAFrame;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b[N+1] sideB if useSideBFrame;
  Parts.Cloth.Interfaces.Location[N+1] sideAloc if not useSideAFrame;
  Parts.Cloth.Interfaces.Location[N+1] sideBloc if not useSideBFrame;
  //
protected
  outer DeployStructLib.DSL_Globals DSLglb;
equation
  //
  assert(Vectors.length(tangent_vector_sideA) > 0.0, "In Cloth: tangent_vector_sideA must be non-zero length");
  assert(Vectors.length(bending_vector_sideA) > 0.0, "In Cloth: bending_vector_sideA must be non-zero length");
  assert(Vectors.length(tangent_vector_sideB) > 0.0, "In Cloth: tangent_vector_sideB must be non-zero length");
  assert(Vectors.length(bending_vector_sideB) > 0.0, "In Cloth: bending_vector_sideB must be non-zero length");
  //
if not FEcloth then
  if flat then
    for j in 1:N+1 loop
      connect(clothInstanceFlat.sideA[j].frame_a, sideA[j]);
      connect(clothInstanceFlat.sideB[j].frame_a, sideB[j]);
      //
      // Constrained edge springs
      if constrainEdges then
        connect(bend1sA[1, j].ref_frame, clothInstanceFlat.sideA[j].frame_a);
        connect(bend1sA[1, j].location_b, clothInstanceFlat.mass[1, j].location);
        connect(bend1sB[1, j].ref_frame, clothInstanceFlat.sideB[j].frame_a);
        connect(bend1sB[1, j].location_b, clothInstanceFlat.mass[M-1, j].location);
      end if;
    end for;
  else
    for j in 1:N+1 loop
      connect(clothInstanceBend.sideA[j].frame_a, sideA[j]);
      connect(clothInstanceBend.sideB[j].frame_a, sideB[j]);
      //
      // Constrained edge springs
      if constrainEdges then
        connect(bend1sA[1, j].ref_frame, clothInstanceBend.sideA[j].frame_a);
        connect(bend1sA[1, j].location_b, clothInstanceBend.mass[1, j].location);
        connect(bend1sB[1, j].ref_frame, clothInstanceBend.sideB[j].frame_a);
        connect(bend1sB[1, j].location_b, clothInstanceBend.mass[M-1, j].location);
      end if;
    end for;
  end if;
else
  if tri then
    for j in 1:N+1 loop
        if useSideAFrame then
          connect(clothInstanceFlatTri.sideA[j].frame_a, sideA[j]);
        else
          connect(clothInstanceFlatTri.sideAloc[j], sideAloc[j]);
        end if;
        if useSideBFrame then
          connect(clothInstanceFlatTri.sideB[j].frame_a, sideB[j]);
        else
          connect(clothInstanceFlatTri.sideBloc[j], sideBloc[j]);
        end if;
      //
      if constrainEdges then
        connect(bend1sA[1, j].ref_frame, clothInstanceFlatTri.sideA[j].frame_a);
        connect(bend1sA[1, j].location_b, clothInstanceFlatTri.mass[1, j].location);
        connect(bend1sB[1, j].ref_frame, clothInstanceFlatTri.sideB[j].frame_a);
        connect(bend1sB[1, j].location_b, clothInstanceFlatTri.mass[M-1, j].location);
      end if;
    end for;
  else
  if zFold then
    for j in 1:N+1 loop
      connect(clothInstanceZfoldQuad.sideA[j].frame_a, sideA[j]);
      if useSideBFrame then
        connect(clothInstanceZfoldQuad.sideB[j].frame_a, sideB[j]);
      else
        connect(clothInstanceZfoldQuad.sideBloc[j], sideBloc[j]);
      end if;
    end for;
  else
      for j in 1:N+1 loop
        if useSideAFrame then
          connect(clothInstanceFlatQuad.sideA[j].frame_a, sideA[j]);
        else
          connect(clothInstanceFlatQuad.sideAloc[j], sideAloc[j]);
        end if;
        if useSideBFrame then
          connect(clothInstanceFlatQuad.sideB[j].frame_a, sideB[j]);
        else
          connect(clothInstanceFlatQuad.sideBloc[j], sideBloc[j]);
        end if;
        // Constrained edge springs
        if constrainEdges then
          connect(bend1sA[1, j].ref_frame, clothInstanceFlatQuad.sideA[j].frame_a);
          connect(bend1sA[1, j].location_b, clothInstanceFlatQuad.mass[1, j].location);
	      if useSideBFrame then
            connect(bend1sB[1, j].ref_frame, clothInstanceFlatQuad.sideB[j].frame_a);
	        connect(bend1sB[1, j].location_b, clothInstanceFlatQuad.mass[M-1, j].location);
 
	      end if;
        
        end if;
      //
    end for;
  end if;
  end if;
end if;
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2}), graphics = {Rectangle(origin = {0.11, -0.109061}, fillColor = {0, 85, 127}, fillPattern = FillPattern.Cross, extent = {{-81.2187, 75.253}, {86.7436, -57.7944}}), Text(origin = {-89.0577, 9.49989}, rotation = 90, extent = {{-50.83, 4.86}, {50.83, -4.86}}, textString = "N=%N", fontSize = 40, fontName = "Arial"), Text(origin = {-0.55, 83.42}, extent = {{-50.83, 4.86}, {50.83, -4.86}}, textString = "M=%M", fontSize = 40, fontName = "Arial")}), Documentation(info =  "<html>
  <p>
  Block for modeling <b>flexible blankets</b>, such as solar blankets. 
  <p>
  There are two formulations. One formulation is a finite element formulation
  based on natural strains. Both triangle and quadrilateral elements are available. This formulation has been thoroughly validated but does not currently   include bending stiffness. A second formulation, a spring-mass formulation, is also provided, but it has not been validated. 
  </p>
  <p>
  To use this block, be sure to set M and N and specify the initial configuration, using the flags (flat, zFold, etc). If using the finite element formulation, flat and z-folded are available as initial configurations. To start in a bent configuration with the finite element formulaton, use two blankets in a flat formulation, connected to each other at the bottom of the fold, and be sure to set appropriate z-coordinates. See DeployStructLib.Parts.Section for an example of how to do this. 
  </p>
  <p>
  It is also important to set P-values and their respective _starts correctly. Parameters P1-P4 are relative coordinates describing the geometry of the cloth when it is fully extended. If, for example, the cloth being modeled was rectangular, with width=w and length=L, then the P-values might be: P1={0, 0, 0}, P2={0, w, 0}, P3={L, w, 0}, P4={L, 0, 0}. The _start values are the absolute coordinate, in world, at which each corner of the cloth should start.
  </p>
  <p>
  A cloth has N+1 connections on each side. SideA connections are always MultiBody Frames. SideB connections can be Frames (if useSideBFrame is true, which is the default) or they can be DeployStructLib.Interfaces.Location connectors. Use locations on SideB if connecting to another cloth block, such as in DeployStructLib.Parts.Section. To connect to beams or other non-cloth blocks, use Frames. To maintain proper parameterization, make connections in a for loop.
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth;
