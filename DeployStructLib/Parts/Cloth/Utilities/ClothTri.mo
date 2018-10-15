within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

partial model ClothTri
  "Base class for cloth using Natural Triangle formulation"
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Frames;
  import Modelica.Mechanics.MultiBody.Interfaces;
  import Modelica.Mechanics.MultiBody.Forces;
  import Modelica.Math.Vectors;
  import DeployStructLib;
  //
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
  parameter Real[3] ref_angles "Angles to describe orientation of P1 in space";
  parameter Integer[3] axes_sequence = {1, 2, 3} "Sequence of axes of 'ref_angles' to describe orientation of P1 in space" annotation(Evaluate = true);
  parameter Integer M annotation(Evaluate = true);
  parameter Integer N annotation(Evaluate = true);
  parameter Boolean steadyState_mass = DSLglb.SteadyState;
  parameter Properties.ClothProperty clothPropsData;
  //
  parameter Modelica.Mechanics.MultiBody.Types.RealColor color = {0, 0, 224} "Color of cloth" annotation(Dialog(enable = animation and not multiColoredSurface, colorSelector = true, group = "Material properties"));
  parameter Boolean useSideAFrame = true;
  parameter Boolean useSideBFrame = true;
  //
  parameter SI.Mass[M-1, N+1] m_init;
  parameter SI.Mass[1, N+1] m_init_edgeA;
  parameter SI.Mass[1, N+1] m_init_edgeB;
  parameter Real[M-1, N+1, 3] r_0_start;
  parameter Real[1, N+1, 3] r_0_start_edgeA;
  parameter Real[1, N+1, 3] r_0_start_edgeB;
  //
  Parts.Cloth.Springs.NaturalTriangle[M, N] triBL(Kqin = Initializers.Cloth_NatTri_Initializer(M, N, clothPropsData.E, clothPropsData.G, clothPropsData.nu, clothPropsData.thickness, 1, P1, P2, P3, P4, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence), each beta = clothPropsData.beta, each color = color);
  Parts.Cloth.Springs.NaturalTriangle[M, N] triUR(Kqin = Initializers.Cloth_NatTri_Initializer(M, N, clothPropsData.E, clothPropsData.G, clothPropsData.nu, clothPropsData.thickness, 3, P1, P2, P3, P4, P1_loc = P1_loc, ref_angles = ref_angles, axes_sequence = axes_sequence), each beta = clothPropsData.beta, each color = color);
  //
  Mass[M-1, N+1] mass(m = m_init, each enforceStates = true, each steadyState = steadyState_mass, each isCoincident = false, r_0(start = r_0_start), each alpha = clothPropsData.alpha, each animation = false);
  Mass[1, N+1] edgeMassA(m = m_init_edgeA, r_0(start = r_0_start_edgeA), each isCoincident = useSideAFrame, each alpha = clothPropsData.alpha, each animation = false, each steadyState = not useSideAFrame and steadyState_mass);
  Mass[1, N+1] edgeMassB(m = m_init_edgeB, r_0(start = r_0_start_edgeB), each isCoincident = useSideBFrame, each alpha = clothPropsData.alpha, each animation = false, each steadyState = not useSideBFrame and steadyState_mass);
  //
  Parts.Cloth.Interfaces.Location2Frame[N + 1] sideA if useSideAFrame;
  Parts.Cloth.Interfaces.Location2Frame[N + 1] sideB if useSideBFrame;
  Parts.Cloth.Interfaces.Location[N + 1] sideAloc if not useSideAFrame;
  Parts.Cloth.Interfaces.Location[N + 1] sideBloc if not useSideBFrame;
  //
protected
  outer DeployStructLib.DSL_Globals DSLglb;
  //
equation
  // connect sides/locations and masses
  for j in 1:N + 1 loop
    if useSideAFrame then
      connect(sideA[j].location, edgeMassA[1, j].location);
    else
      connect(sideAloc[j], edgeMassA[1, j].location);
    end if;
    if useSideBFrame then
      connect(sideB[j].location, edgeMassB[1, j].location);
    else
      connect(sideBloc[j], edgeMassB[1, j].location);
    end if;
  end for;
  //
  // connect triangles
  for j in 1:N loop
    connect(edgeMassA[1, j].location, triBL[1, j].location[1]);
    connect(mass[1, j].location, triBL[1, j].location[2]);
    connect(edgeMassA[1, j + 1].location, triBL[1, j].location[3]);
    connect(mass[M - 1, j].location, triBL[M, j].location[1]);
    connect(edgeMassB[1, j].location, triBL[M, j].location[2]);
    connect(mass[M - 1, j + 1].location, triBL[M, j].location[3]);
    connect(mass[1, j + 1].location, triUR[1, j].location[1]);
    connect(edgeMassA[1, j + 1].location, triUR[1, j].location[2]);
    connect(mass[1, j].location, triUR[1, j].location[3]);
    connect(edgeMassB[1, j + 1].location, triUR[M, j].location[1]);
    connect(mass[M - 1, j + 1].location, triUR[M, j].location[2]);
    connect(edgeMassB[1, j].location, triUR[M, j].location[3]);
//
    for i in 2:M - 1 loop
      connect(mass[i - 1, j].location, triBL[i, j].location[1]);
      connect(mass[i, j].location, triBL[i, j].location[2]);
      connect(mass[i - 1, j + 1].location, triBL[i, j].location[3]);
      connect(mass[i, j + 1].location, triUR[i, j].location[1]);
      connect(mass[i - 1, j + 1].location, triUR[i, j].location[2]);
      connect(mass[i, j].location, triUR[i, j].location[3]);
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
end ClothTri;
