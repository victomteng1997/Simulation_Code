function [ result ] = dev_arg_of_den(r, a, ak)
%r is the r_max. a is the coe of denominator
%this function returns the derivative of argument of transfer function denominator

%this function is unfinished
delta_a = 0.0001;
syms w
f(w) = 0;
for i = 1:length(a)
    f(w)= f(w) + a(i)*((r*exp(1j*w))^(-i));
end
g(w) = 0;
left_mat = zeros(1, length(a));
for i = 1:length(a)
    g(w) = diff(angle(f(w) + delta_a*((r*exp(1j*w))^(-i)))) - diff(angle(f(w)))/delta_a;
    left_mat(i) = 1 / pi * int(g(w), 0, pi);
end
alpha = a - ak;
result = left_mat * alpha;
end

