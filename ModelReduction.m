function [ output_args ] = ModelReduction( A,b,c,d,Ts )
%Model Reduction function 
%Step 0: Generate the FIR filter 
%Step 1: Compute the impulse-response gramian P asthe solution of the Lyapunov equation
%{
X = dlyapchol(A,B,E) computes a Cholesky factorization X = R'*R of X solving the Sylvester equation
A*X*A' - E*X*E' + B*B' = 0

csys = canon(sys,type) transforms the linear model sys into a canonical state-space model csys. The argument type specifies whether csys is in modal or companion form.
%}
sys = ss(A,b,c,d,Ts);  %create the system
sys_head = canon(sys,'modal');  %canonical realization
A_head = sys_head.A;
c_head = sys_head.c;
R = dlyapchol(transpose(A_head),transpose(c_head));        
P = transpose(R)*R;                    %impulse-response gramian P               这里可能有问题，因为对dlyapchol这个函数的运行方式不太确定，不知道算出来的结果是R还是P
L = orthogonal_matrix(P);








end

