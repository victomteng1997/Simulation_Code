function [ s_map ] = get_smap(deviation, max, min)
% From deviation, get sensitivity map and use it for further discrete
% points choosing
%   Remain to be tested
n_size = size(deviation);
s_map = zeros(1,n_size(2));
for i = 1:n_size(2)
    s_map(i) = deviation(max,i)-deviation(min,i);
%To be mentioned, the resulted s_map would be a 1*n matrix
end

end

