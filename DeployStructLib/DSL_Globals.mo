within DeployStructLib;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

model DSL_Globals
  parameter Boolean enableAnimation = true "= true, if animation of all components is enabled" annotation(Evaluate=true);
  parameter Boolean SteadyState = false "= true, if components are to be initialized to steady state, otherwise will start with variable values=0.0";
// Remove useDSgravity when omc bug #3202 is fixed
  parameter Boolean useDSgravity = true "= true, special gravity function is to be used in DeployStructLib components to allow for override propagation of world.g, but won't correctly handle non-DeployStructLib components (e.g., MultiBody.Parts.Body)" annotation(Evaluate=true);
  parameter Boolean quasiStatic = false "= true, if a quasi-static analysis is to be used where all mass values are reduced by quasiStaticFactor. This only works for DeployStructLib components and won't correctly handle non-DeployStructLib components (e.g., MultiBody.Parts.Body). Gravity forces will be unaffected." annotation(Evaluate=true);
  parameter Real quasiStaticFactor = 0.001 "Factor used to scale masses for quasiStatic analysis";
  //
  annotation(defaultComponentName = "DSLglb", defaultComponentPrefixes = "inner", missingInnerMessage = "No \"DSL_Globals\" component is defined. Please drag DSL_Globals into the top level of your model.", Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}}, preserveAspectRatio = true, initialScale = 0.1, grid = {2, 2})), Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end DSL_Globals;
