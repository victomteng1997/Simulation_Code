function [ output ] = objective_deltax (delta_x)
%minimize the objective function to solve delta x
%still underconstruction 
%in number of point form (for example [0,100] [200,300]
global g_etau g_dev_etau 
global g_sample_num g_pass_area g_stop_area
global g_lambada_p g_lambada_s


all = norm((g_etau + g_dev_etau*delta_x),inf);
first = all((g_sample_num*g_pass_area(1)):(g_sample_num*g_pass_area(2)),:);
second = g_lambada_p * all((g_sample_num*g_pass_area(1)):(g_sample_num*g_pass_area(2)),:);
third = g_lambada_s*all((g_sample_num*g_stop_area(1)):(g_sample_num*g_stop_area(2)),:);
output = norm(first,inf)+norm(second,inf)+norm(third,inf);


end

