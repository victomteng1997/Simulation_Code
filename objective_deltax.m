function [ output ] = objective_deltax (delta_x,i_area,j_area,e_tau,dev_e_tau,lambada_p, lambada_s)
%minimize the objective function to solve delta x
%still underconstruction 
%i_area and j_area represents the frequency area of passband and stopband,
%in number of point form (for example [0,100] [200,300]
all = norm((e_tau + dev_e_tau*delta_x),inf);
first = all(i_area(1):i_area(2),:);
second = lambada_p * all(i_area(1):i_area(2),:);
third = lambada_s*all(j_area(1):j_area(2),:);
output = norm(first,inf)+norm(second,inf)+norm(third,inf);


end

