within DeployStructLib.Properties;
/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

class EAGJ_BeamProperty
"Class for providing combined beam properties"
    parameter Real alpha "Mass-proportional damping";
    parameter Real beta "Stiffness-proportional damping";
    parameter Real EA "Axial stiffness";
    parameter Real EIyy "Bending stiffness about y";
    parameter Real EIzz "Bending stiffness about z";
    parameter Real GJ "Torsional stiffness";
    parameter Real cen_y "Section centroid location in y-direction";
    parameter Real cen_z "Section centroid location in z-direction";
    parameter Real rhoA "Mass per unit length";
    parameter Real MOIxx "Moment of inertia about x";
    parameter Real MOIyy "Moment of inertia about y";
    parameter Real MOIzz "Moment of inertia about z";
    parameter Real rCM_y "Section center of mass in y-direction";
    parameter Real rCM_z "Section center of mass in z-direction";
    annotation(defaultComponentName = "EAGJ_BeamProperty", defaultComponentPrefixes = "parameter", Documentation(info = "<html>
<p>
Beam combined properties for use with the DeployStructLib.Parts.Beam block. To use these properties, add DeployStructLib.Properties.EAGJ_BeamProperty to your model, provide the properties, and give the Beam block the name of this record. Also be sure to set \"useEAGJ\" to <b>true</b> in the Beam block.
</p>
<p>
All properties, except for centroid location, must be provided.
</p>
<p>
Damping is modeled using Rayleigh damping, where the damping matrix <b>C</b> is a linear combination of the stiffness matrix <b>K</b> and the mass matrix <b>M</b> as follows:
</p> 
<p>
<pre>
    <b>C</b> = &alpha;<b>M</b> + &beta;<b>K</b>
</pre>
</p>
<p>
Values of \"alpha\" and \"beta\" should generally be kept small (~0.01 - ~0.1), or the simulation may struggle to converge. If convergence is an issue when damping is used, try setting both \"alpha\" and \"beta\" to zero. If that converges, then gradually increase the damping. 
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

  </html>"));
end EAGJ_BeamProperty;
