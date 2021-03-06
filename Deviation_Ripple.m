function [ answer ] = Deviation_Ripple( wp,ws,type,n,num,den,tau )
%One thing to be mentioned.


ripple = Linear_Ripple(wp,ws,type,n,num,den,tau);
answer = [];


for i = 1:length(num)             %firstly calculate num gradient
    num(i) = num(i) + 0.0001;
    new_ripple = Linear_Ripple(wp,ws,type,n,num,den,tau);
    num(i) = num(i) - 0.0001;
    dev = (new_ripple - ripple)/0.0001;
    answer = [answer,dev];
    
end
for i = 1:length(den)             %firstly calculate num gradient
    den(i) = den(i) + 0.0001;
    new_ripple = Linear_Ripple(wp,ws,type,n,num,den,tau);
    den(i) = den(i) - 0.0001;
    dev = (new_ripple - ripple)/0.0001;
    answer = [answer,dev];
end


end

