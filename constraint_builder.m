function [c] = constraint_builder( delta_x)
% Constraint for optimization problem
global g_lr_tran rho
rho = 0.01;
c(1) = norm(delta_x,2) - rho;
c(2) = norm(g_lr_tran, inf) - 1;
% ceq = all(dev_arg_of_den(r, a, ak) == 0); % TODO: value of r, a, ak need to be passed here
%this place is reserved for stability

% VERY IMPORTANT
%one constraint for stability is not finished yet.
%need to be added in later
end

