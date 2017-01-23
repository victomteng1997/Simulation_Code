function [ numerator,denominator] = ModelReduction( A,b,c,d,Ts )
%Model Reduction function 
%Step 0: Generate the FIR filter 

%here I need to put in a function to generate the intial system


%Step 1: Compute the impulse-response gramian P asthe solution of the Lyapunov equation
%{
X = dlyapchol(A,B,E) computes a Cholesky factorization X = R'*R of X solving the Sylvester equation
A*X*A' - E*X*E' + B*B' = 0

csys = canon(sys,type) transforms the linear model sys into a canonical state-space model csys. The argument type specifies whether csys is in modal or companion form.
%}
sys = ss(A,b,c,d,Ts);  %create the system
sys_head = canon(sys,'modal');  %canonical realization
A_head = sys_head.A;
b_head = sys_head.b;
c_head = sys_head.c;

R = dlyapchol(transpose(A_head),transpose(c_head));        
P = transpose(R)*R;                    %impulse-response gramian P               这里可能有问题，因为对dlyapchol这个函数的运行方式不太确定，不知道算出来的结果是R还是P
L = orthogonal_matrix(P);
A_d = L\A_head*L;
b_d = L\b_head;
c_d = c_head*L;
s_A = size(A_d);s_b = size(b_d);s_c = siza(c_d);

A_m = A_d(1:ceil(0.5*s_A(1)),1:ceil(0.5*s_A(1)));    
b_m = b_d(1:ceil(0.5*s_b(1)),:);
c_m = c_d(:,1:ceil(0.5*s_c(2)));
d_m = d;                                                 % reduced state-space model 

[numerator,denominator] = ss2tf(A_m,b_m,c_m,d_m);






end

