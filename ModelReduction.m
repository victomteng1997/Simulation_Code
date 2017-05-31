function [ numerator,denominator] = ModelReduction( N_red, N_fir, Rip_pb, Rip_sb, f_ct) %f_ct only available for bandpass filter
%here i set Rip_pb = 0.5, Rip_sb = 40
%Model Reduction function 
%Step 0: Generate the FIR filter 

%% personally i don't understand what's happening... but this file can only be run section by section

%Get inital fir filter
hpFilt = designfilt('lowpassfir','PassbandFrequency',0.25, ...
         'StopbandFrequency',0.35,'PassbandRipple',0.5, ...
         'StopbandAttenuation',35,'DesignMethod','kaiserwin');
fvtool(hpFilt);

%get the space state form
[A,B,C,D] = ss(hpFilt);


%Step 1: Compute the impulse-response gramian P asthe solution of the Lyapunov equation
%{
X = dlyapchol(A,B,E) computes a Cholesky factorization X = R'*R of X solving the Sylvester equation
A*X*A' - E*X*E' + B*B' = 0

csys = canon(sys,type) transforms the linear model sys into a canonical state-space model csys. The argument type specifies whether csys is in modal or companion form.
%}
Ts = 0.1; % specify the sampled time (unit: s)
sys = ss(A,B,C,D,Ts);  %create the system
sys_head = canon(sys,'modal');  %canonical realization
A_head = sys_head.A;
b_head = sys_head.b;
c_head = sys_head.c;

R = dlyapchol(transpose(A_head),transpose(c_head));        
P = transpose(R)*R;                    %impulse-response gramian P               这里可能有问题，因为对dlyapchol这个函数的运行方式不太确定，不知道算出来的结果是R还是P
L = orthogonal_matrix(P)
A_d = L\A_head*L;
b_d = L\b_head;
c_d = c_head*L;
s_A = size(A_d);s_b = size(b_d);s_c = size(c_d);

A_m = A_d(1:ceil(0.5*s_A(1)),1:ceil(0.5*s_A(1)));    
b_m = b_d(1:ceil(0.5*s_b(1)),:);
c_m = c_d(:,1:ceil(0.5*s_c(2)));
d_m = D;                                                 % reduced state-space model 

[numerator,denominator] = ss2tf(A_m,b_m,c_m,d_m);


%% To check the frequency response of the filter
[h,w] = freqz(numerator,denominator,'whole',2001);
plot(w/pi,20*log10(abs(h)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')


end

