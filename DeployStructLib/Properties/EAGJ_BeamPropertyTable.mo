within DeployStructLib.Properties;
/*
COPYRIGHT (C) 2021
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

class EAGJ_BeamPropertyTable "Class for providing EAGJ format beam properties via a table defined in a file"
//
  parameter EAGJ_BeamProperty EAGJprop(
    EA=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 1, L),
    EIyy=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 2, L),
    EIzz=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 3, L),
    GJ=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 4, L),
    cen_y=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 5, L),
    cen_z=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 6, L),
    rhoA=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 7, L),
    MOIxx=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 8, L),
    MOIyy=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 9, L),
    MOIzz=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 10, L),
    rCM_y=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 11, L),
    rCM_z=Modelica.Blocks.Tables.Internal.getTable1DValue(tableID, 12, L),
    alpha = alpha,
    beta = beta);
  parameter String fileName = "fdsa";
  parameter String tableName = "asdf";
  parameter Real L "Length interpolation position";
  parameter Real alpha "Mass-proportional damping";
  parameter Real beta "Stiffness-proportional damping";
  //
  parameter Real table[:, 13] = fill(0.0, 0, 13) "Table matrix"
    annotation (Dialog(group="Table data definition"));
  parameter Integer columns[:]=2:13
    "Columns of table to be interpolated"
    annotation (Dialog(group="Table data interpretation"));
  parameter Modelica.Blocks.Types.ExternalCombiTable1D tableID=
      Modelica.Blocks.Types.ExternalCombiTable1D(
        tableName,
        if fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(fileName) then fileName else "NoName",
        table,
        columns,
        Modelica.Blocks.Types.Smoothness.LinearSegments,
        Modelica.Blocks.Types.Extrapolation.LastTwoPoints,
        false) "External table object";
  //
  annotation(defaultComponentName = "EAGJ_BeamPropertyTable", defaultComponentPrefixes = "parameter", Documentation(info = "<html>
<p>
Beam combined properties for use with the DeployStructLib.Parts.Beam block using a table defined in a .mat file. To use these properties, add DeployStructLib.Properties.EAGJ_BeamPropertyTable to your model, provide the fileName and tableName, and give the Beam block the name of this record + .EAGJprop (i.e., props.EAGJprop). Also be sure to set \"useEAGJ\" to <b>true</b> in the Beam block.
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
Copyright &copy; 2021<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

  </html>"));
end EAGJ_BeamPropertyTable;  
