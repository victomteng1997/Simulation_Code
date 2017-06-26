function [solution] = mosek_optimzer()
global g_len_x

% define the decision variable
delta_x = sdpvar(g_len_x,1); 
% define the constraints
[c, ceq] = constraint( delta_x);
Constraints = [c(1) <= 0, c(2) <= 0, ceq == 1];
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
