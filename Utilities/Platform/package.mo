within DeployStructLib.Utilities;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

package Platform
  extends Modelica.Icons.Package;
  type ostype = enumeration(Unknown "Unknown", Windows "Windows", OSX "Mac OSX", Linux "Linux");

  function getPlatform
    extends Modelica.Icons.Function;
    output ostype typeval = ostype.Unknown;
  protected
    String tmp;
    Boolean exists;
  algorithm
    (tmp, exists) := Modelica.Utilities.System.getEnvironmentVariable("OS");
    if exists then
      if Modelica.Utilities.Strings.find(tmp, "Windows") > 0 then
        typeval := ostype.Windows;
      end if;
    else
      (tmp, exists) := Modelica.Utilities.System.getEnvironmentVariable("OSTYPE");
      if Modelica.Utilities.Strings.find(tmp, "darwin") > 0 then
        typeval := ostype.OSX;
      end if;
      if Modelica.Utilities.Strings.find(tmp, "linux") > 0 then
        typeval := ostype.Windows;
      end if;
    end if;
  end getPlatform;
  annotation(Documentation(info = "<HTML>
<p>
Licensed by ATA Engineering, Inc. under the Modelica License 2
</p>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

<p>
<i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://DeployStructLib.UsersGuide.ModelicaLicense2\">DeployStructLib.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.
</i>
</p>
</HTML>"));
end Platform;
