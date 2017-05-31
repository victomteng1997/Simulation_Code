function [result] = decimal_digits(vec,n)
% take vector and ddecimal digits n as input
% return a result
len = length(vec);
result = zeros(1,len);
for c = 1:len
    current = round(vec(c)*(10^n))/(10^n);
    result(c) = current;
end
end

