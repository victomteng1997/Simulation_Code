function [ result ] = dev_arg_of_den(r, a)
%r is the r_max. a is the coe of denominator
%this function returns the derivative of argument of transfer function denominator

%this function is unfinished
syms w
f(w) = 0;
for i = 1:length(a)
    f(w)= f(w) + a(i)*((r*exp(1j*w))^(-i));
end
f(w) = argument(f(w));

result = diff(f(w));
end

