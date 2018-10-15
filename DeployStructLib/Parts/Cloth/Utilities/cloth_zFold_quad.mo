within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth_zFold_quad "Block for modeling blanket that starts in z-fold configuration. Uses NaturalQuad formulation."
  import Modelica.Mechanics.MultiBody.Frames;
  extends ClothQuad(
  m_init = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act = M-1),
  m_init_edgeA = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=false, M_act = 1),
  m_init_edgeB = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=true, M_act = 1),
  r_0_start = Initializers.Cloth_MassLoc_zFold_Initializer(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), M_act = M-1, L = L, folds = folds, dir_pos = dir_pos),
  r_0_start_edgeA = Initializers.Cloth_MassLoc_zFold_Initializer(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=false, M_act = 1, L = L, folds = folds, dir_pos = dir_pos),
  r_0_start_edgeB = Initializers.Cloth_MassLoc_zFold_Initializer(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=true, M_act = 1, L = L, folds = folds, dir_pos = dir_pos)
  );
  //
  parameter Real endDist[3] = ((P4 + P3)/2) - ((P1 + P2)/2);
  parameter Real L = sqrt(endDist[1]^2 + endDist[2]^2 + endDist[3]^2);
  parameter Integer folds = 1;
  parameter Boolean dir_pos;
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_zFold_quad;
