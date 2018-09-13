within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model cloth_bend
  "Block for cloth initialized in bent V configuration, using spring-mass formulation."
  extends cloth_gen;
  import Modelica.Mechanics.MultiBody.Frames;
//
  Mass[M-1, N+1] mass(m = Cloth.Initializers.Cloth_Mass_initializer(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act=M-1), each enforceStates = true, each steadyState = steadyState_mass, r_0(start = Cloth.Initializers.Cloth_MassLoc_initializer(P1, P2, P3, P4, M-1, N+1, start_angle, P1_loc, P_R = Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)))));
  Mass[2, N+1] edgeMass(m = Cloth.Initializers.Cloth_Mass_initializer(P1, P2, P3, P4, M, N, clothPropsData.area_density, M_act=2), each enforceStates = true, each steadyState = steadyState_mass, r_0(start = Cloth.Initializers.Cloth_MassLoc_initializer(P1, P2, P3, P4, 2, N+1, start_angle, P1_loc, P_R = Frames.axesRotations(axes_sequence, ref_angles, der(ref_angles)))));
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_bend;
