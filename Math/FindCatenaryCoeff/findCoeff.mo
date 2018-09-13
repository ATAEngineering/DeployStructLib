within DeployStructLib.Math.FindCatenaryCoeff;

/*
COPYRIGHT (C) 2018
BY ATA ENGINEERING, INC.
ALL RIGHTS RESERVED
*/

function findCoeff "Calculate the catenary coefficient. Assumes no difference in height"
  input Real h "Horizontal distance between posts";
  input Real s "Length";
  input Real a_guess = 1.0 "Initial guess for catenary coefficient";
  input Real max_rel_step_size = 0.01;
  input Real tol = 0.0001;
  input Integer max_number_steps = 1000;
  output Real a "Catenary coefficient";
  //  0 = 2 * a * sinh(0.5 * h / a) - s;
protected
  Real a_old;
  Real res;
  Real max_step_size;
  Real step = 1;
  Integer n = 0;
algorithm
  // Basic Newton algorithm
  a_old := a_guess;
  res := f(a_old, s, h);
  //print("Start: h=" + String(h) + ", s=" + String(s) + ", res=" + String(res) + ", a_old=" + String(a_old) + ", step=" + String(step) + "\n");
  while abs(res) > tol and n < max_number_steps loop
    max_step_size := max_rel_step_size * a_old;
    step := res / derf(a_old, s, h);
    step := if abs(step) > max_step_size then sign(step) * max_step_size else step;
    a := a_old - step;
    res := f(a, s, h);
    n := n + 1;
    a_old := a;
  end while;
  //print("h=" + String(h) + ", s=" + String(s) + ", res=" + String(res) + ", a=" + String(a) + ", step=" + String(step) + "\n");
  annotation(Inline = true, Documentation(info="<html>
<p>
Copyright &copy; 2018<br>
ATA ENGINEERING, INC.<br>
ALL RIGHTS RESERVED
</p>

</html>"));
end findCoeff;
