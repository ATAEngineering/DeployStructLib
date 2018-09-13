within DeployStructLib.Visualization;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model Shape "Extends MSL Shape block"

  extends Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape;
  
  input Real transparency = 0.0 "Transparency of shape: 0 (= opaque) ... 1 (= fully transparent)" annotation(Dialog);

annotation(Documentation(info="<html>
<p>
<b> Attribution Notice </b> 
</p>
<p>
This model is an extension of the Shape block in the 
Mechanics.MultiBody.Visualizers.Advanced package
of the Modelica Standard Library <br>
Copyright &copy; 1998-2016, Modelica Association and DLR.
</p>

<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end Shape;
