function [ IIR_coe_best ] = IIR_Design( N_red, Rip_pb, Rip_sb, f_ct, tau, r_max )
%Proposed Design Algorithm
%{
wp = 0.4;
ws = 0.6;
maxpbgain = 1.001;
minpbgain = 0.999;
maxsbgain = 0.001;
%}

%  ModelReduction is not finished yet

%  Here the given example is a low pass filter. All the other situations
%  may be added in later


N_fir = 2*tau;
while N_red <= (2/3*N_fir)
    rho = 0.01;
    %the following part is about getting the initial iir filter coef
    %before this, wp and ws are needed to be stated
    %hence, I added this part into Model Reduction
    IIRcoe_ini = ModelReduction(N_red, N_fir, Rip_pb, Rip_sb, f_ct);             %IIRcoe_ini should be a two dimentional vector [b,a], b is num, a is deno
    
    %calculate ripple of inital IIR      here assume wp = 0.4, ws = 0.6
    Rip_pb0 = Get_ripple(0,0.4,IIRcoe_ini);
    Rip_sb0 = Get_ripple(0.6,1,IIRcoe_ini);
    lambada_p = 10^5 * Rip_pb0;
    lambada_s = 10^5 * Rip_sb0;
    while rho > 10^(-4) && lambada_p <= 10^5 && lambada_s <= 10^5
        %compute deviation of group delay, linear ripple, gradient of deviation of group delay, gradient of linear ripple and gradient of �� for initial IIR filter
        %before all this, calculate the group delay first
        num_sam = 314;       %number of sampling points
        [gd_ini,w_ini] = grpdelay(IIRcoe_ini(1),IIRcoe_ini(2), num_sam);           %gd and w are the group delay response and respective frequency ,314 is the number of sampled points
        %1. deviation of group delay
        matrix = zeros(num_sam,1);
        matrix(:,:) = tau;
        e_tau_ini =  gd_ini - matrix;
        
        %2 linear ripple
        %function Linear_Ripple gives the linear ripple in specific region
        psband1 = Linear_Ripple(0,0.4, 'pass',num_sam);
        stband1 = Linear_Ripple(0.6,1,'stop',num_sam);
        
    
    
    
        
    
    
    
    end
end
