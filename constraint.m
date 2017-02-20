function [ c,ceq ] = constraint( delta_x)
% Constraint for optimization problem
global g_lr_tran rho
c(1) = norm(delta_x,2) - rho;
c(2) = g_lr_tran - 1;
ceq = [];        %this place is reserved for stability

% VERY IMPORTANT
%one constraint for stability is not finished yet.
%need to be added in later
end

