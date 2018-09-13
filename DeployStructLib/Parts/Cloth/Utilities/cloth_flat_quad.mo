within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth_flat_quad
  "Block for cloth initialized in flat configuration, using Natural Quad formulation."
  extends ClothQuad;
  import Modelica.Mechanics.MultiBody.Frames;
  //
  Mass[M-1, N+1] mass(m = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act = M-1), each enforceStates = true, each steadyState = steadyState_mass, each isCoincident = false, r_0(start = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), M_act = M-1)), each alpha = clothPropsData.alpha, each animation = false);
  //
  Mass[1, N+1] edgeMassA(m = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=false, M_act = 1), r_0(start = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=false, M_act = 1)), each isCoincident = useSideAFrame, each alpha = clothPropsData.alpha, each animation = false, each steadyState = not useSideAFrame and steadyState_mass);
  Mass[1, N+1] edgeMassB(m = Initializers.Cloth_Mass_Init(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, isEdgeB=true, M_act = 1), r_0(start = Initializers.Cloth_MassLoc_Flat_Init(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start), isEdge=true, isEdgeB=true, M_act = 1)), each isCoincident = useSideBFrame, each alpha = clothPropsData.alpha, each animation = false, each steadyState = not useSideBFrame and steadyState_mass);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_flat_quad;
