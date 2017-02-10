function [ num_best, den_best ] = IIR_Design( N_red, Rip_pb, Rip_sb, f_ct, tau, r_max )

%Firstly indicate those variables based on the calculation, and are needed
%in later result
global g_etau g_dev_etau g_lr_pass g_lr_stop g_gradient_lr_pass g_gradient_lr_stop
%Then indicate those variables that pre-set to this IIR filter, including
%passband and stopband
global g_sample_num g_pass_area g_stop_area g_lambada_p g_lambada_s
g_sample_num = 314;
g_pass_area = [0,0.4];
g_stop_area = [0.6,1];
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
    [ini_num,ini_den] = ModelReduction(N_red, N_fir, Rip_pb, Rip_sb, f_ct);             %2017/1/26 change ini_coe to ini_num and ini_den to minimize the dimensional problem
    %calculate ripple of inital IIR      here assume wp = 0.4, ws = 0.6
    Rip_pb0 = Get_ripple(0,0.4,ini_num,ini_den);
    Rip_sb0 = Get_ripple(0.6,1,ini_num,ini_den);
    g_lambada_p = 10^5 * Rip_pb0;
    g_lambada_s = 10^5 * Rip_sb0;
    while rho > 10^(-4) && lambada_p <= 10^5 && lambada_s <= 10^5
        %compute deviation of group delay, linear ripple, gradient of deviation of group delay, gradient of linear ripple and gradient of ¦µ for initial IIR filter
        %before all this, calculate the group delay first
        num_sam = 314;       %number of sampling points
        [gd_ini,w_ini] = grpdelay(ini_num,ini_den, num_sam);           %gd and w are the group delay response and respective frequency ,314 is the number of sampled points
        %1. deviation of group delay
        matrix = zeros(num_sam,1);
        matrix(:,:) = tau;
        e_tau_ini =  gd_ini - matrix;
        g_etau = e_tau_ini;
        
        
        %2 linear ripple
        %function Linear_Ripple gives the linear ripple in specific region
        psband1 = Linear_Ripple(0,0.4, 'pass',num_sam,IIRcoe_ini,tau);
        stband1 = Linear_Ripple(0.6,1,'stop',num_sam,IIRcoe_ini,tau);
        g_lr_pass = psband1;
        g_lr_stop = stband1;
        %one more situation should be added in here, which is the
        %transition band
        
        %3 gradient of deviation of group delay
        ini_gra_dev_gd_ini = Gra_Dev_Group_delay(ini_num,ini_den,num_sam,e_tau_ini,tau);
        g_dev_etau = ini_gra_dev_gd_ini;
        
        %4 gradient of deviation of linear ripple
        %passband 0-0.4
        pass_gra_dev = Deviation_Ripple(0,0.4, 'pass',num_sam,IIRcoe_ini,tau);
        g_gradient_lr_pass = pass_gra_dev;
        %stopband 0.6-1
        end_gra_dev = Deviation_Ripple(0.6,1, 'pass',num_sam,IIRcoe_ini,tau);
        g_gradient_lr_stop = end_gra_dev;
        
        %5 gradient of Phi, stability calculation
        %the function is unfinished due to some mathematical problems
        while 1
            %Solve the convex maximizing problem
            %firstly write the objective function
            gs = GlobalSearch;
            %calculate i_area, j_area
            problem = createOptimProblem('fmincon','objective',@(x)objective_deltax(x,i_area,j_area,e_tau,dev_e_tau,lambada_p, lambada_s));
        
        
        end
        
    
    
        
    
    
    end
end

