function [ ripple ] = Get_ripple( wp, ws, coe)
%Get the ripple in the given region

%{
This MATLAB function returns the n-point frequency response vector, h, and the
    corresponding angular frequency vector, w, for the digital filter with numerator
    and denominator polynomial coefficients stored in b and a, respectively.
%}

%ws and wp should be normalized frequency (0 to 1)

[h,w] = freqz(coe(1),coe(2),3140);
checked_region = h(ws*3.14*1000+1:wp*3.14*1000,:);
ripple = max(checked_region) - min(checked_region);


end

