within DeployStructLib.Properties;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

package BeamXProperties
  "Records for Beam cross section properties"
    extends Modelica.Icons.Package;
  model beamCrossSectionType
    type xtype = enumeration(
        Circular_Rod,
        Circular_Tube,
        Rectangular_Bar,
        Rectangular_Tube,
        General_Section);
  end beamCrossSectionType;

  record beamXProperty
    import SI = Modelica.SIunits;
    parameter beamCrossSectionType.xtype crossSectionType;
    parameter SI.Length width = 0 "Width= Length of Dimension in Local y";
    parameter SI.Length height = 0 "Height=Length of Dimension in Local z";
    parameter SI.Length d = 0 "Outer Diameter";
    parameter SI.Length t = 0 "Wall thickness";
    parameter Real Iyy = BeamIyyCalc(width = width, height = height, d = d, t = t, crossSectionType = crossSectionType) "Moment of Inertia";
    parameter Real Izz = BeamIzzCalc(width = width, height = height, d = d, t = t, crossSectionType = crossSectionType) "Moment of Inertia";
    parameter Real J = BeamJCalc(width = width, height = height, d = d, t = t, crossSectionType = crossSectionType) "Torsion constant";
    parameter Real A = BeamAreaCalc(width = width, height = height, d = d, t = t, crossSectionType = crossSectionType) "Area";
    parameter Real extra = 0 "Extra shape parameter (for visualization)";
  end beamXProperty;

  record RectBarProperty = beamXProperty(crossSectionType = beamCrossSectionType.xtype.Rectangular_Bar, width = 0.01, height = 0.01) annotation(defaultComponentName = "RectBarProperty", defaultComponentPrefixes = "parameter");
  record RectTubeProperty = beamXProperty(crossSectionType = beamCrossSectionType.xtype.Rectangular_Tube, width = 0.01, height = 0.01, t = 0.001) annotation(defaultComponentName = "RectTubeProperty", defaultComponentPrefixes = "parameter");
  record CircRodProperty = beamXProperty(crossSectionType = beamCrossSectionType.xtype.Circular_Rod, d = 0.1) annotation(defaultComponentName = "CircRodProperty", defaultComponentPrefixes = "parameter");
  record CircTubeProperty = beamXProperty(crossSectionType = beamCrossSectionType.xtype.Circular_Tube,d = 0.1, t = 0.01) annotation(defaultComponentName = "CircTubeProperty", defaultComponentPrefixes = "parameter");
  record GeneralSectionProperty = beamXProperty(crossSectionType = beamCrossSectionType.xtype.General_Section, A = 100, Iyy = 1, Izz = 1, J = 1) annotation(defaultComponentName = "GeneralSectionProperty", defaultComponentPrefixes = "parameter");

  function getShapeType
    input beamXProperty xprop;
    output String shapeType;
  algorithm
    if xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      shapeType := "box";
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      shapeType := "box";
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      shapeType := "cylinder";
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      shapeType := "pipe";
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.General_Section then
      shapeType := "box";
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end getShapeType;

  function getShapeExtra
    input beamXProperty xprop;
    output Real extra;
  algorithm
    if xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      extra := xprop.extra;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      extra := xprop.width / (xprop.width - 2.0 * xprop.t);
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      extra := xprop.extra;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      extra := xprop.d / (xprop.d - 2.0 * xprop.t);
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.General_Section then
      extra := xprop.extra;
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end getShapeExtra;

  function getDim
    input beamXProperty xprop;
    input Integer dimID;
    output Real dim;
  algorithm
    assert(dimID > 1 and dimID < 4, "Invalid dimension ID", AssertionLevel.error);
    if xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      if dimID == 2 then
        dim := xprop.width;
      elseif dimID == 3 then
        dim := xprop.height;
      end if;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      if dimID == 2 then
        dim := xprop.width;
      elseif dimID == 3 then
        dim := xprop.height;
      end if;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      if dimID == 2 then
        dim := xprop.d;
      elseif dimID == 3 then
        dim := xprop.d;
      end if;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      if dimID == 2 then
        dim := xprop.d;
      elseif dimID == 3 then
        dim := xprop.d;
      end if;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.General_Section then
      if dimID == 2 then
        dim := xprop.width;
      elseif dimID == 3 then
        dim := xprop.height;
      end if;
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end getDim;

  function BeamAreaCalc
    input beamCrossSectionType.xtype crossSectionType;
    input Real height = 0.01;
    input Real width = 0.01;
    input Real t = 0.001;
    input Real d = 0.1;
    output Real A "Area";
  protected
    Real wi;
    Real hi;
    Real di;
  algorithm
    wi := width - 2 * t;
    hi := height - 2 * t;
    di := d - 2 * t;
    if crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      A := height * width;
    elseif crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      A := height * width - hi * wi;
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      A := Modelica.Constants.pi * d ^ 2 / 4;
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      A := Modelica.Constants.pi / 4 * (d ^ 2 - di ^ 2);
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamAreaCalc;

  function BeamIyyCalc
    input beamCrossSectionType.xtype crossSectionType;
    input Real height = 0.01;
    input Real width = 0.01;
    input Real t = 0.001;
    input Real d = 0.1;
    output Real Iyy "Moment of Inertia";
  protected
    Real wi = width - 2 * t;
    Real hi = height - 2 * t;
    Real di = d - 2 * t;
  algorithm
    if crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      Iyy := 1 / 12 * width * height ^ 3;
    elseif crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      Iyy := 1 / 12 * (width * height ^ 3 - wi * hi ^ 3);
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      Iyy := Modelica.Constants.pi * d ^ 4 / 64;
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      Iyy := Modelica.Constants.pi / 64 * (d ^ 4 - di ^ 4);
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamIyyCalc;

  function BeamIzzCalc
    input beamCrossSectionType.xtype crossSectionType;
    input Real height = 0.01;
    input Real width = 0.01;
    input Real t = 0.001;
    input Real d = 0.1;
    output Real Izz "Moment of Inertia";
  protected
    Real wi = width - 2 * t;
    Real hi = height - 2 * t;
    Real di = d - 2 * t;
  algorithm
    if crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      Izz := 1 / 12 * height * width ^ 3;
    elseif crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      Izz := 1 / 12 * (height * width ^ 3 - wi ^ 3 * hi);
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      Izz := Modelica.Constants.pi * d ^ 4 / 64;
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      Izz := Modelica.Constants.pi / 64 * (d ^ 4 - di ^ 4);
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamIzzCalc;

  function BeamJCalc
    input beamCrossSectionType.xtype crossSectionType;
    input Real height = 0.01;
    input Real width = 0.01;
    input Real d = 0.1;
    input Real t = 0.001;
    output Real J "Torsion Constant";
  protected
    Real wi = width - 2 * t;
    Real hi = height - 2 * t;
    Real di = d - 2 * t;
    Real a_j;
    Real b_j;
  algorithm
    if crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      a_j := max(width, height);
      b_j := min(width, height);
      J := a_j * b_j ^ 3 * (1 / 3 - 0.21 * (b_j / a_j) * (1 - b_j ^ 4 / (12 * a_j ^ 4)));
    elseif crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
  //    J := (height * width + wi * hi) ^ 2 * t / (height + width + hi + wi);
      J := 2 * t * width ^ 2 * height ^ 2 / (width + height);
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      J := Modelica.Constants.pi * d ^ 4 / 32;
    elseif crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
  //    J := Modelica.Constants.pi * t / 8 * (d ^ 2 + di ^ 2) ^ 2 / (d + di);
      J := Modelica.Constants.pi * t * (d - t) ^ 3  / 4;
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamJCalc;

  function BeamIttCalc
    input beamXProperty xprop;
    input Real L = 2.0;
    // Itt is always diagonal for a straight beam, only calculate the diagonal
    output Real Itt[3] "Moment of Inertia";
  algorithm
    if xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      Itt :={xprop.width ^ 2 + xprop.height ^ 2, L ^ 2 + xprop.height ^ 2, L ^ 2 + xprop.width ^ 2} / 12;
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      Itt := {xprop.width * xprop.height * (xprop.width * xprop.width + xprop.height * xprop.height) - (xprop.width - 2 * xprop.t) * (xprop.height - 2 * xprop.t) * ((xprop.width - 2 * xprop.t) * (xprop.width - 2 * xprop.t) + (xprop.height - 2 * xprop.t) * (xprop.height - 2 * xprop.t)), xprop.width * xprop.height * (L * L + xprop.height * xprop.height) - (xprop.width - 2 * xprop.t) * (xprop.height - 2 * xprop.t) * (L * L + (xprop.height - 2 * xprop.t) * (xprop.height - 2 * xprop.t)), xprop.width * xprop.height * (L * L + xprop.width * xprop.width) - (xprop.width - 2 * xprop.t) * (xprop.height - 2 * xprop.t) * (L * L + (xprop.width - 2 * xprop.t) * (xprop.width - 2 * xprop.t))} / (12*(xprop.width * xprop.height - (xprop.width - 2*xprop.t)*(xprop.height - 2*xprop.t)));
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      Itt := {1 / 2 * (xprop.d / 2) ^ 2, 1 / 12 * (3 * (xprop.d / 2) ^ 2 + L ^ 2), 1 / 12 * (3 * (xprop.d / 2) ^ 2 + L ^ 2)};
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      Itt := {1 / 2 * ((xprop.d / 2 - xprop.t) ^ 2 + (xprop.d / 2) ^ 2), 1 / 12 * (3 * ((xprop.d / 2 - xprop.t) ^ 2 + (xprop.d / 2) ^ 2) + L ^ 2), 1 / 12 * (3 * ((xprop.d / 2 - xprop.t) ^ 2 + (xprop.d / 2) ^ 2) + L ^ 2)};
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamIttCalc;

  function BeamCMCalc
    input beamXProperty xprop;
    input Real L = 2.0;
    output Real[3] r_CM;
  algorithm
    if xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Bar then
      r_CM := {L / 2, 0.0, 0.0};
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Rectangular_Tube then
      r_CM := {L / 2, 0.0, 0.0};
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Rod then
      r_CM := {L / 2, 0.0, 0.0};
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.Circular_Tube then
      r_CM := {L / 2, 0.0, 0.0};
    elseif xprop.crossSectionType == beamCrossSectionType.xtype.General_Section then
      r_CM := {L / 2, 0.0, 0.0};
    else
      assert(true, "Invalid cross-section", AssertionLevel.error);
    end if;
  end BeamCMCalc;

annotation(Documentation(info = "<html>
<p>
Beam cross section properties for use with the DeployStructLib.Parts.Beam block. Properties are automatically calculated based on cross section dimensions. 
</p>
<p>
To use these properties, add DeployStructLib.Properties.BeamProperties to your model, and provide the cross-section type and the relevant dimensions. Then, give the Beam block the name of this record. 
</p>
<p>
Available cross-sections are:
<ul>
<li>Rectangular bar </li>
<li>Rectangular tube </li> 
<li>Circular Rod </li>
<li>Circular tube </li>
<li>General section </li>
</ul>
The \" General Section\" asks for the inertia tensor and area directly, allowing you to use cross sections other than the standard provided here. <b>Note:</b> cross sections are assumed to be constant along the length of the beam. 
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end BeamXProperties;

