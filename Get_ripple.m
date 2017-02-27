function [ ripple ] = Get_ripple( wp, ws, num,den,num_sam = 3140)
%Get the ripple in the given region

%{
This MATLAB function returns the n-point frequency response vector, h, and the
    corresponding angular frequency vector, w, for the digital filter with numerator
    and denominator polynomial coefficients stored in b and a, respectively.
%}

%ws and wp should be normalized frequency (0 to 1)

[h,w] = freqz(num,den,num_sam);
checked_region = h(ws*num_sam+1:wp*num_sam,:);
ripple = max(checked_region) - min(checked_region);


end

