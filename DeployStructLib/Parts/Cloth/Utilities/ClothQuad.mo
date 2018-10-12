within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

partial model ClothQuad
  "Base class for cloth using Natural Quad formulation"
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
  //
  Parts.Cloth.Springs.NaturalQuad[M, N] quad(Kqin = Initializers.Cloth_NatQuad_Init(M, N, clothPropsData.E, clothPropsData.G, clothPropsData.nu, clothPropsData.thickness, P1, P2, P3, P4, P1_loc = P1_loc, ref_angles = ref_angles, P1_start = P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P1_start), P2_start = P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P2_start), P3_start = P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P3_start), P4_start = P1_loc + Frames.resolve2(Frames.axesRotations(axes_sequence, ref_angles, zeros(3)), P4_start)), each beta = clothPropsData.beta, each color = color);
  //
  //
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
  // connect quads
  for j in 1:N loop
    connect(edgeMassA[1, j].location, quad[1, j].location[1]);
    connect(mass[1, j].location, quad[1, j].location[2]);
    connect(mass[1, j + 1].location, quad[1, j].location[3]);
    connect(edgeMassA[1, j + 1].location, quad[1, j].location[4]);
//
    connect(mass[M - 1, j].location, quad[M, j].location[1]);
    connect(edgeMassB[1, j].location, quad[M, j].location[2]);
    connect(edgeMassB[1, j + 1].location, quad[M, j].location[3]);
    connect(mass[M - 1, j + 1].location, quad[M, j].location[4]);
//
    for i in 2:M - 1 loop
      connect(mass[i - 1, j].location, quad[i, j].location[1]);
      connect(mass[i, j].location, quad[i, j].location[2]);
      connect(mass[i, j + 1].location, quad[i, j].location[3]);
      connect(mass[i - 1, j + 1].location, quad[i, j].location[4]);
    end for;
  end for;
  //
  //
  //
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end ClothQuad;
