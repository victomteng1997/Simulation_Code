function [ num_best, den_best ] = IIR_Design( N_red, Rip_pb, Rip_sb, f_ct, tau, r_max, b) %b is the fir filter initial coe

%Firstly indicate those variables based on the calculation, and are needed
%in later result
global g_etau g_dev_etau g_lr_pass g_lr_tran g_lr_stop g_gradient_lr_pass g_gradient_lr_stop
%Then indicate those variables that pre-set to this IIR filter, including
%passband and stopband
global g_sample_num g_pass_area g_tran_area g_stop_area g_lambada_p g_lambada_s rho
g_sample_num = 314;
g_pass_area = [0,0.4];
g_tran_area = [0.4001 0.0599];
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
        
        IIRcoe_ini = [ini_num,ini_den];  %I didn't consider the dimension problem here. Remain to be tested
        %2 linear ripple
        %function Linear_Ripple gives the linear ripple in specific region
        psband1 = Linear_Ripple(0,0.4, 'pass',num_sam,ini_num,ini_den,tau);
        trband1 = Linear_Ripple(0.4,0.6,'tran',num_sam,ini_num,ini_den,tau);
        stband1 = Linear_Ripple(0.6,1,'stop',num_sam,ini_num,ini_den,tau);
        g_lr_pass = psband1;
        g_lr_tran = trband1;
        g_lr_stop = stband1;
        %one more situation should be added in here, which is the
        %transition band
        
        %3 gradient of deviation of group delay
        ini_gra_dev_gd_ini = Gra_Dev_Group_delay(ini_num,ini_den,num_sam,e_tau_ini,tau);
        g_dev_etau = ini_gra_dev_gd_ini;
         
        %4 gradient of deviation of linear ripple
        %passband 0-0.4
        pass_gra_dev = Deviation_Ripple(0,0.4, 'pass',num_sam,ini_num,ini_den,tau);
        g_gradient_lr_pass = pass_gra_dev;
        %stopband 0.6-1
        end_gra_dev = Deviation_Ripple(0.6,1, 'pass',num_sam,ini_num,ini_den,tau);
        g_gradient_lr_stop = end_gra_dev;
        
        %5 gradient of Phi, stability calculation
        %the function is unfinished due to some mathematical problems
        
        
        %let IIRcoe = IIRcoe_ini
        IIRcoe = IIRcoe_ini;
        IIRnum = ini_num;
        IIRden = ini_den;
        while 1
            %Solve the convex maximizing problem
            %firstly write the objective function
            x_guess = zeros(1,length(IIRcoe));
            A = []; b = [];      %linear constraints
            Aeq = []; beq = [];  %equality constraints
            lb = []; ub = [];    %lower and upper bound constraints
            options = optimoptions(@fmincon);
            %in most cases those are not useful
            delta_x = fmincon( @(x)objective, x_guess, A, b, Aeq, beq, lb, ub, @(x)constraint, options);
            
            %calculate new performances
            IIRcoe = IIRcoe + delta_x;
            new_num = IIRcoe(1:length(IIRnum));
            new_den = IIRcoe(length(IIRnum)+1:length(IIRcoe));
            %1. deviation of group delay
            [new_gd,new_w] = grpdelay(new_num,new_den, num_sam);
            new_etau = new_gd - matrix;
            %2. gradient of deviation of group delay
            new_gra_dev_gd_ini = Gra_Dev_Group_delay(new_num,new_den,num_sam,new_etau,tau); 
            if (norm(g_etau,inf) - norm(new_etau,inf))/(norm(g_etau,inf) - norm(g_etau+g_dev_etau,inf)) < 0.5
                rho = 0.5*rho;
            else
                IIRnum = new_num;
                IIRden = new_den;
                rho = 1.1*rho;
                %calculate new ripple
                pass_ripple = Get_ripple(0,0.4,IIRnum,IIRden);
                stop_ripple = Get_ripple(0.6,1,IIRnum,IIRden);
                new_lambada_p = 10^5 * pass_ripple;
                new_lambada_s = 10^5 * stop_ripple;
                if abs(new_lambada_p-g_lambada_p)<1e-4 && abs(new_lambada_s-g_lambada_s)<1e-4
                    %calculate full adder cost and Q_tau
                        %if acceptable
                        %update IIRcoe_best
                        %end if
                end
            break
            end
        end   
    end
    N_red = N_red + 1;
    %return IIRcoe_best
end

