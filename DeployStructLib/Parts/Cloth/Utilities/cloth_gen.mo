within DeployStructLib.Parts.Cloth.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

partial model cloth_gen
  "Base class for cloth, using spring-mass formulation."
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
  parameter Integer[3] axes_sequence = {1, 2, 3} "Sequence of axes of 'ref_angles' to describe orientation of P1 in space";
  parameter Integer M annotation(Evaluate = true);
  parameter Integer N annotation(Evaluate = true);
  parameter Boolean steadyState_mass = DSLglb.SteadyState;
  parameter Properties.ClothProperty clothPropsData;
  //
  Parts.Cloth.Springs.Extension[M, N + 1] extension1(k = Initializers.Cloth_K1_initializer(P1, P2, P3, P4, M, N, E_mod = clothPropsData.E * clothPropsData.thickness), each d = clothPropsData.alpha, s_0 = Initializers.Cloth_K1s0_initializer(P1, P2, P3, P4, M, N));
  Parts.Cloth.Springs.Extension[M + 1, N] extension2(k = Initializers.Cloth_K2_initializer(P1, P2, P3, P4, M, N, E_mod = clothPropsData.E * clothPropsData.thickness), each d = clothPropsData.alpha, s_0 = Initializers.Cloth_K2s0_initializer(P1, P2, P3, P4, M, N));
  Parts.Cloth.Springs.Extension[M, N] shear1(k = Initializers.Cloth_G1_initializer(P1, P2, P3, P4, M, N, G_xy = clothPropsData.G, thickness =  clothPropsData.thickness), each d = clothPropsData.alpha, each steadyState = false, s_0 = Initializers.Cloth_G1s0_initializer(P1, P2, P3, P4, M, N));
  Parts.Cloth.Springs.Extension[M, N] shear2(k = Initializers.Cloth_G2_initializer(P1, P2, P3, P4, M, N, G_xy = clothPropsData.G, thickness =  clothPropsData.thickness), each d = clothPropsData.alpha, each steadyState = false, s_0 = Initializers.Cloth_G2s0_initializer(P1, P2, P3, P4, M, N));
  //
  Parts.Cloth.Springs.Bend_FreeEdge[M - 1, 2] bend1e(k = Initializers.Cloth_G1_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = 2:M, N_ind = {1, N+1}), each d = clothPropsData.damping_bend);
  Parts.Cloth.Springs.Bend_FreeEdge[2, N - 1] bend2e(k = Initializers.Cloth_G2_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = {1, M+1}, N_ind = 2:N), each d = clothPropsData.damping_bend);
  Parts.Cloth.Springs.Bend_Center[M - 1, N - 1] bend1c(k = Initializers.Cloth_G1_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = 2:M, N_ind = 2:N), each d = clothPropsData.damping_bend);
  Parts.Cloth.Springs.Bend_Center[M - 1, N - 1] bend2c(k = Initializers.Cloth_G2_bend_initializer(P1 = P1, P2 = P2, P3 = P3, P4 = P4, M = M, N = N, D = clothPropsData.D, M_ind = 2:M, N_ind = 2:N), each d = clothPropsData.damping_bend);
  //
  Parts.Cloth.Interfaces.Location2Frame[N+1] sideA;
  Parts.Cloth.Interfaces.Location2Frame[N+1] sideB;
  //
protected
  outer DeployStructLib.DSL_Globals DSLglb;
  //
equation
  // connect sides/locations and masses
  for j in 1:N + 1 loop
    connect(sideA[j].location, edgeMass[1, j].location);
    connect(sideB[j].location, edgeMass[2, j].location);
  end for;
  // connect x-dir springs
  for j in 1:N + 1 loop
    connect(edgeMass[1, j].location, extension1[1, j].location_a);
    connect(mass[1, j].location, extension1[1, j].location_b);
    connect(edgeMass[2, j].location, extension1[M, j].location_b);
    connect(mass[M-1, j].location, extension1[M, j].location_a);
    for i in 2:M-1 loop
      connect(mass[i - 1, j].location, extension1[i, j].location_a);
      connect(mass[i, j].location, extension1[i, j].location_b);
    end for;
  end for;
  //
  // connect y-dir springs
  for j in 1:N loop
    connect(edgeMass[1, j].location, extension2[1, j].location_a);
    connect(edgeMass[1, j+1].location, extension2[1, j].location_b);
    connect(edgeMass[2, j].location, extension2[M+1, j].location_a);
    connect(edgeMass[2, j+1].location, extension2[M+1, j].location_b);
    for i in 2:M loop
      connect(mass[i-1, j].location, extension2[i, j].location_a);
      connect(mass[i-1, j + 1].location, extension2[i, j].location_b);
    end for;
  end for;
  //
  // connect shear springs
  for j in 1:N loop
      connect(edgeMass[1, j].location, shear1[1, j].location_a);
      connect(mass[1, j+1].location, shear1[1, j].location_b);
      connect(edgeMass[1, j+1].location, shear2[1, j].location_a);
      connect(mass[1, j].location, shear2[1, j].location_b);
      //
      connect(mass[M-1, j].location, shear1[M, j].location_a);
      connect(edgeMass[2, j+1].location, shear1[M, j].location_b);
      connect(mass[M-1, j+1].location, shear2[M, j].location_a);
      connect(edgeMass[2, j].location, shear2[M, j].location_b);
    for i in 2:M-1 loop
      connect(mass[i-1, j].location, shear1[i, j].location_a);
      connect(mass[i, j + 1].location, shear1[i, j].location_b);
      connect(mass[i-1, j + 1].location, shear2[i, j].location_a);
      connect(mass[i, j].location, shear2[i, j].location_b);
    end for;
  end for;
  //
  // connect bend1 springs
  // Center springs
  for j in 1:N - 1 loop
      connect(edgeMass[1, j+1].location, bend1c[1, j].location_a);
      connect(mass[1, j+1].location, bend1c[1,j].location_c);
      connect(mass[1, j].location, bend1c[1,j].location_d);
      connect(mass[1, j+2].location, bend1c[1,j].location_e);
      connect(mass[2, j+1].location, bend1c[1,j].location_b);
      //
      connect(mass[M-2, j+1].location, bend1c[M-1,j].location_a);
      connect(mass[M-1, j+1].location, bend1c[M-1,j].location_c);
      connect(mass[M-1, j].location, bend1c[M-1,j].location_d);
      connect(mass[M-1, j+2].location, bend1c[M-1,j].location_e);
      connect(edgeMass[2, j+1].location, bend1c[M-1, j].location_b);
      //
      connect(mass[1, j].location, bend2c[1, j].location_a);
      connect(mass[1, j+1].location, bend2c[1, j].location_c);
      connect(edgeMass[1,j+1].location, bend2c[1, j].location_d);
      connect(mass[2, j+1].location, bend2c[1, j].location_e);
      connect(mass[1, j+2].location, bend2c[1, j].location_b);
      //
      connect(mass[M-1, j].location, bend2c[M-1, j].location_a);
      connect(mass[M-1, j+1].location, bend2c[M-1, j].location_c);
      connect(mass[M-2, j+1].location, bend2c[M-1, j].location_d);
      connect(edgeMass[2, j+1].location, bend2c[M-1, j].location_e);
      connect(mass[M-1, j+2].location, bend2c[M-1, j].location_b);
    for i in 2:M - 2 loop
      connect(mass[i - 1, j + 1].location, bend1c[i, j].location_a);
      connect(mass[i, j + 1].location, bend1c[i, j].location_c);
      connect(mass[i, j].location, bend1c[i, j].location_d);
      connect(mass[i, j + 2].location, bend1c[i, j].location_e);
      connect(mass[i + 1, j + 1].location, bend1c[i, j].location_b);
      //
      connect(mass[i, j].location, bend2c[i, j].location_a);
      connect(mass[i, j + 1].location, bend2c[i, j].location_c);
      connect(mass[i-1, j + 1].location, bend2c[i, j].location_d);
      connect(mass[i+1, j + 1].location, bend2c[i, j].location_e);
      connect(mass[i, j + 2].location, bend2c[i, j].location_b);
    end for;
  end for;
  //
  // Free edge springs
  connect(edgeMass[1, 1].location, bend1e[1, 1].location_a);
  connect(mass[1, 1].location, bend1e[1, 1].location_c);
  connect(mass[1, 2].location, bend1e[1, 1].location_d);
  connect(mass[2, 1].location, bend1e[1, 1].location_b);
  //
  connect(edgeMass[1, N+1].location, bend1e[1, 2].location_a);
  connect(mass[1, N+1].location, bend1e[1, 2].location_c);
  connect(mass[1, N].location, bend1e[1, 2].location_d);
  connect(mass[2, N+1].location, bend1e[1, 2].location_b);
  //
  connect(mass[M-2, 1].location, bend1e[M-1, 1].location_a);
  connect(mass[M-1, 1].location, bend1e[M-1, 1].location_c);
  connect(mass[M-1, 2].location, bend1e[M-1, 1].location_d);
  connect(edgeMass[2, 1].location, bend1e[M-1, 1].location_b);
  //
  connect(mass[M-2, N+1].location, bend1e[M-1, 2].location_a);
  connect(mass[M-1, N+1].location, bend1e[M-1, 2].location_c);
  connect(mass[M-1, N].location, bend1e[M-1, 2].location_d);
  connect(edgeMass[2, N+1].location, bend1e[M-1, 2].location_b);
  for i in 2:M - 2 loop
    connect(mass[i - 1, 1].location, bend1e[i, 1].location_a);
    connect(mass[i, 1].location, bend1e[i, 1].location_c);
    connect(mass[i, 2].location, bend1e[i, 1].location_d);
    connect(mass[i + 1, 1].location, bend1e[i, 1].location_b);
    //
    connect(mass[i - 1, N + 1].location, bend1e[i, 2].location_a);
    connect(mass[i, N + 1].location, bend1e[i, 2].location_c);
    connect(mass[i, N].location, bend1e[i, 2].location_d);
    connect(mass[i + 1, N + 1].location, bend1e[i, 2].location_b);
  end for;
//
  for j in 1:N - 1 loop
    connect(edgeMass[1, j].location, bend2e[1, j].location_a);
    connect(edgeMass[1, j + 1].location, bend2e[1, j].location_c);
    connect(mass[1, j + 1].location, bend2e[1, j].location_d);
    connect(edgeMass[1, j + 2].location, bend2e[1, j].location_b);
    //
    connect(edgeMass[2, j].location, bend2e[2, j].location_a);
    connect(edgeMass[2, j + 1].location, bend2e[2, j].location_c);
    connect(mass[M-1, j + 1].location, bend2e[2, j].location_d);
    connect(edgeMass[2, j + 2].location, bend2e[2, j].location_b);
  end for;
  //
  annotation(Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})),Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end cloth_gen;
