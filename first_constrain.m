function [ c ceq ] = first_constraint( x )
% The first constraint in the paper
% transition band gain is not greater than 1

global g_etau g_dev_etau 
global g_sample_num g_pass_area g_stop_area
global g_lambada_p g_lambada_s

gain = 1;          %here can be modified, but in most cases it can be 1

ceq = []

end

