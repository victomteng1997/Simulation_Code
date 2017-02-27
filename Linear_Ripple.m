function [ ripple ] = Linear_Ripple(wp,ws,type,n,num,den,tau)
%Return the Linear Ripple in the desired region
% wp, ws are the boundary of the region respectively
matrix = zeros(n,1);             %the inital matrix with all 0 in one column

%�˴��������˵��
%Ϊȷ�����м��������ظ�����ȡ��һԭ�򣬼������������Ϊ125.2�㣬�����126
if wp == 0
    s_point = 1;
else
    s_point = ceil(wp*n);
end
e_point = ceil(ws*n);

[h,w] = freqz(num,den,n);

if strcmp(type,'pass')
    for i = s_point:e_point
        matrix(i,:) = h(i) - exp(1i*(i/n*pi)*tau);
    end
elseif strcmp(type,'stop')
    for i = s_point:e_point
        matrix(i,:) = h(i);
    end    
elseif strcmp(type,'tran')
    for i = s_point:e_point
        matrix(i,:) = h(i);
    end    
else 
    fprintf('Wrong calculation region type')
end
ripple = matrix;

end

