function [solution] = mosek_optimzer(r, ak)

% define the decision variable
delta_x = sdpvar(2*length(ak),1); 
% define the constraints
[c] = constraint_builder(delta_x);
ceq = dev_arg_of_den(r, ak, delta_x(1:length(delta_x)/2));
Constraints = [c(1) <= 0, c(2) <= 0, ceq == 0];
% define the objective function
Objective = objective_deltax(delta_x);
% Set some options for YALMIP and solver
options = sdpsettings('verbose',1,'solver','mosek');
% Solve the problem
sol = optimize(Constraints,Objective,options);
% Analyze error flags
if sol.problem == 0
 % Extract and display value
 solution = value(delta_x);
else
 display('Hmm, something went wrong!');
 sol.info
 yalmiperror(sol.problem)
end
end
