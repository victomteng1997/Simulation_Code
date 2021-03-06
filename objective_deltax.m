function [ output ] = objective_deltax (x)
%minimize the objective function to solve delta x
%still underconstruction 
%in number of point form (for example [0,100] [200,300]
global g_etau g_dev_etau 
global g_lr_pass g_lr_stop g_gradient_lr_pass g_gradient_lr_stop
global g_sample_num g_pass_area 
global g_lambada_p g_lambada_s
p_etau = g_etau(1:round(0.4*314));
p_dev_etau = g_dev_etau(1:round(0.4*314),:);
all = norm(p_etau + p_dev_etau*x,2);
% first = all((g_sample_num*g_pass_area(1)):(g_sample_num*g_pass_area(2)),:);
second = g_lambada_p * (g_lr_pass + g_gradient_lr_pass * x);
third = g_lambada_s*(g_lr_stop + g_gradient_lr_stop*x);
output = all+max(abs(second))+max(abs(third));
%output = all

end

