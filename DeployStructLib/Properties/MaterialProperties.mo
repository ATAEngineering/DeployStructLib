within DeployStructLib.Properties;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

package MaterialProperties
"Material properties for DeployStructLib.Parts.Beam blocks"
    extends Modelica.Icons.Package;
  record isotropicMaterialProperty "Isotropic material property record for DeployStructLib.Parts.Beam block"
    import SI = Modelica.SIunits;
    parameter Real alpha = 0 "Mass-proportional damping factor";
    parameter Real beta = 0 "Stiffness-proportional damping factor";
    parameter SI.Density rho = 1;
    parameter SI.ModulusOfElasticity E = 1;
    parameter SI.ShearModulus G = -1 "-1 indicates that G will be calculated from E and nu";
    parameter SI.PoissonNumber nu = -1 "-1 indicates that nu will be calculated from E and G";
    annotation(defaultComponentName = "isotropicMaterialProperty", defaultComponentPrefixes = "parameter");
  end isotropicMaterialProperty;
  
annotation(Documentation(info = "<html>
<p>
Beam material properties for use with the DeployStructLib.Parts.Beam block. To use these properties, add DeployStructLib.Properties.MaterialProperties to your model, provide the properties, and give the Beam block the name of this record.   
</p>
<p>
For any beam, including rigid beams, density (\"rho\") must be supplied. For flexible beams, two of elastic modulus, shear modulus, and Poisson's ratio must be supplied. The third of those properties will be computed. 
</p>
<p>
Damping can also be provided. Damping is modeled using Rayleigh damping; the damping matrix <b>C</b> is a linear combination of the stiffness matrix <b>K</b> and the mass matrix <b>M</b> as follows:
</p> 
<p>
<pre>
    <b>C</b> = &alpha;<b>M</b> + &beta;<b>K</b>
</pre>
</p>
<p>
Values of \"alpha\" and \"beta\" should generally be kept small (~0.01-~0.1), or the simulation may struggle to converge. If convergence is an issue when damping is used, try setting both \"alpha\" and \"beta\" to zero. If that converges, then gradually increase the damping. 
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end MaterialProperties;
