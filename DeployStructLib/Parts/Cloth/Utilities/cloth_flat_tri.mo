within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth_flat_tri "Block for cloth initialized in flat configuration, using Natural Triangle formulation."
  import Modelica.Mechanics.MultiBody.Frames;
  extends ClothTri(
  m_init = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act = M-1),
  m_init_edgeA = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=false, M_act = 1),
  m_init_edgeB = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=true, M_act = 1),
  r_0_start = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), M_act = M-1),
  r_0_start_edgeA = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=false, M_act = 1),
  r_0_start_edgeB = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=true, M_act = 1)
  );
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_flat_tri;
