function [ output ] = objective_deltax (x)
%minimize the objective function to solve delta x
%still underconstruction 
%in number of point form (for example [0,100] [200,300]
global g_etau g_dev_etau 
global g_lr_pass g_lr_stop g_gradient_lr_pass g_gradient_lr_stop
global g_sample_num g_pass_area 
global g_lambada_p g_lambada_s

all = max(abs((g_etau + g_dev_etau*x),inf));
disp(all)
% first = all((g_sample_num*g_pass_area(1)):(g_sample_num*g_pass_area(2)),:);
second = g_lambada_p * (g_lr_pass + g_gradient_lr_pass * x);
third = g_lambada_s*(g_lr_stop + g_gradient_lr_stop*x);
output = all+max(abs(second,inf))+max(abs(third,inf));


end

