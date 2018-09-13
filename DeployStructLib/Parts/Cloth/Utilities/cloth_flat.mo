within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth_flat
  "Block for cloth initialized in flat configuration, using spring-mass formulation."
  extends cloth_gen;
  import Modelica.Mechanics.MultiBody.Frames;
  //
  Mass[M-1, N+1] mass(m = Initializers.Cloth_Mass_initializer(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act = M-1), each enforceStates = true, each steadyState = steadyState_mass, each isCoincident = false, r_0(start = Initializers.Cloth_MassLoc_Flat_Initializer(M, N, P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)), P1_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)), P2_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)), P3_start), P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)), P4_start))));
  //
  Mass[2, N+1] edgeMass(m = Initializers.Cloth_Mass_initializer(P1, P2, P3, P4, M, N, clothPropsData.area_density, isEdge=true, M_act = 2), each isCoincident = true);
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_flat;
