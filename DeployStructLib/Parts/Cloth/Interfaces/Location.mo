within DeployStructLib.Parts.Cloth.Interfaces;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

connector Location "Location of the component with one cut-force (no icon)"

  import SI = Modelica.SIunits;
  SI.Position r_0[3] "Position vector from world frame to the connector frame origin, resolved in world frame";
  flow SI.Force f[3] "Cut-force resolved in world frame" annotation(unassignedMessage = "All Forces cannot be uniquely calculated.
                    The reason could be that the mechanism contains
                    a planar loop or that joints constrain the
                    same motion. For planar loops, use for one
                    revolute joint per loop the joint
                    Joints.RevolutePlanarLoopConstraint instead of
                    Joints.Revolute.");
  annotation(defaultComponentName = "location", Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}, initialScale = 0.16), graphics = {Rectangle(extent = {{-10, 10}, {10, -10}}, lineColor = {95, 95, 95}, lineThickness = 0.5), Rectangle(extent = {{-30, 100}, {30, -100}}, lineColor = {0, 0, 0}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid)}), Diagram(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}, grid = {1, 1}, initialScale = 0.16), graphics = {Text(extent = {{-140, -50}, {140, -88}}, lineColor = {0, 0, 0}, textString = "%name"), Rectangle(extent = {{-12, 40}, {12, -40}}, lineColor = {0, 0, 0}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid)}), Documentation(info = "<html>
     <p>
     Basic definition of the location of a mechanical
     component. The cut-force is in the world coordinate system.
     </p>
     <p>
     Copyright &copy; 2018<br>
     ATA ENGINEERING, INC.<br>
     ALL RIGHTS RESERVED
     </p>

     </HTML>"));
end Location;
