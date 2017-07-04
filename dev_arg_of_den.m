function [ result ] = dev_arg_of_den(r, ak, ak_1)
%r is the r_max. a is the coe of denominator
%this function returns the derivative of argument of transfer function denominator

%this function is unfinished
delta_a = 0.000001;
syms w
f(w) = 0*w;
for k = 1:length(ak)
    f(w)= f(w) + ak(k)*((r*exp(1j*w))^(-(k-1)));
end
g(w) = 0*w;
left_mat = zeros(1, length(ak));
for k = 1:length(ak)
    disp(k)
    g(w) = diff(angle(f(w) + delta_a*((r*exp(1j*w))^(-k-1))) - angle(f(w)))/delta_a;
    disp(g(w))
    trap = zeros(1,100);
    del = linspace(0,pi,100);
    for q = 1:100
        trap(q) = g(del(q));
        %disp(q);
    end
    left_mat(k) = trapz(del,trap);
%     left_mat(k) = int(g(w), w, 0, pi)* 1 / pi;
   % disp(k);
end
alpha = ak - ak_1';
result = left_mat * alpha';
end

