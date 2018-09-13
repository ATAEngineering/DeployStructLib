within DeployStructLib.Properties;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

record ClothProperty
  "Property record for DeployStructLib Cloth blocks"
  import SI = Modelica.SIunits;
  parameter SI.SurfaceDensity area_density = -1 "Blanket Area Mass Density";
  parameter Real thickness = -1 "Thickness";
  parameter Real E = -1 "Tensile Modulus";
  parameter Real G = -1 "In-plane Shear Modulus";
  parameter Real nu = -1 "Poisson's ratio";
  parameter Real D = -1 "Bending Stiffness";
  parameter Real alpha = 0.0 "Mass proportional damping";
  parameter Real beta = 0.01 "Stiffness proportional damping";
  parameter Real damping_bend = 0.01 "Damping due  to bending";
  annotation(defaultComponentName = "clothProperty", defaultComponentPrefixes = "parameter", Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end ClothProperty;
