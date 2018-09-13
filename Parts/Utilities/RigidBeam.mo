within DeployStructLib.Parts.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model RigidBeam
  import SI = Modelica.SIunits;
  import Modelica.Mechanics.MultiBody.Types;
  import Modelica.Mechanics.MultiBody.Visualizers;
  import Modelica.Mechanics.MultiBody.Frames;
  import DeployStructLib.Properties.BeamXProperties.*;
  //
  parameter SI.Length L "Beam length";
  parameter beamXProperty xprop;
  parameter SI.Density rho = 2700 "Density";
  parameter SI.Mass mass = rho * L * xprop.A "Mass";
  parameter Real[3] r_start = {L, 0, 0};
  parameter Real[3] r = {L, 0, 0} "Position vector from frame_a to frame_b, resolved in frame_a";
  parameter SI.Inertia Itt[3] = mass * BeamIttCalc(xprop, L) "Inertia tensor of body box with respect to center of mass, parallel to frame_a";
  //
  parameter Boolean animation = true "= true, if animation shall be enabled";
  //
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_a;
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b;
  //
  parameter SI.Position r_shape[3] = {0, 0, 0} "Vector from frame_a to box origin, resolved in frame_a";
  parameter SI.Angle angles_start[3] = {0, 0, 0} "Initial values of angles to rotate frame_a around 'sequence_start' axes into frame_b" annotation(Dialog(tab = "Initialization"));
  parameter Types.RotationSequence sequence_start = {1, 2, 3} "Sequence of rotations to rotate frame_a into frame_b at initial time" annotation(Evaluate = true, Dialog(tab = "Initialization"));
  parameter Modelica.Mechanics.MultiBody.Types.Axis lengthDirection = {1, 0, 0} "Vector in length direction of box, resolved in frame_a" annotation(Evaluate = true);
  parameter Modelica.Mechanics.MultiBody.Types.Axis widthDirection = {0, 1, 0} "Vector in width direction of box, resolved in frame_a" annotation(Evaluate = true);
  parameter Real dim2 = DeployStructLib.Properties.BeamXProperties.getDim(xprop, 2);
  parameter Real dim3 = DeployStructLib.Properties.BeamXProperties.getDim(xprop, 3);
  parameter Boolean useQuaternions = true;
  //
  input Modelica.Mechanics.MultiBody.Types.Color color = Modelica.Mechanics.MultiBody.Types.Defaults.BodyColor "Color of body" annotation(Dialog(colorSelector = true, enable = animation));
  input Types.SpecularCoefficient specularCoefficient = world.defaultSpecularCoefficient "Reflection of ambient light (= 0: light is completely absorbed)" annotation(Dialog(enable = animation));
  Parts.Utilities.BodyShape body(useQuaternions = useQuaternions, r = r, r_CM = BeamCMCalc(xprop, L), m = mass, I_11 = Itt[1], I_22 = Itt[2], I_33 = Itt[3], I_21 = 0.0, I_31 = 0.0, I_32 = 0.0, sequence_start = sequence_start, angles_start = angles_start, animation = false, r_shape = r_shape, lengthDirection = lengthDirection, widthDirection = widthDirection, length = L, width = dim2, height = dim3, animateSphere = false);
protected
  outer Modelica.Mechanics.MultiBody.World world;
  outer DeployStructLib.DSL_Globals DSLglb;
  Visualizers.Advanced.Shape shape(shapeType = DeployStructLib.Properties.BeamXProperties.getShapeType(xprop), color = color, specularCoefficient = specularCoefficient, r_shape = {0, 0, 0}, lengthDirection = {1, 0, 0}, widthDirection = {0, 1, 0}, length = L, width = dim2, height = dim3, extra = DeployStructLib.Properties.BeamXProperties.getShapeExtra(xprop), r = frame_a.r_0, R = frame_a.R) if world.enableAnimation and animation;
  //
equation
  connect(frame_a, body.frame_a);
  connect(frame_b, body.frame_b);
  annotation(Documentation(info="<html>
  <p>
  This block provides a model of a rigid beam, based on Modelica.Mechanics.MultiBody.Parts.BodyBox. It is recommended that this model not be used directly. Instead, use DeployStructLib.Parts.Beam and set the \"rigid\" flag to true.
  </p>
  <p>
  Copyright &copy; 2018<br>
  ATA ENGINEERING, INC.<br>
  ALL RIGHTS RESERVED
  </p>

  </html>"));	
end RigidBeam;
