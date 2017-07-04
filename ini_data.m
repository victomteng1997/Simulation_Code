%% Get a set of initial datatau = 20
tau = 10;
rho = 0.01;
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



%  Here the given example is a low pass filter. All the other situations
%  may be added in later


N_fir = 2*tau;
ini_den = [1,-4.74815088182944,12.1471312883652,-21.5343200012895,28.9395301973257,-30.6658408806818,26.0063166851241,-17.6107273749384,9.33580746927685,-3.70170382356906,0.994665743800890,-0.138855277624260];
ini_num = [-0.00210427763723882,0.00969631188833582,-0.0188806629724763,0.0160031411330495,0.00323495502543608,-0.0193895398022410,0.0153121622289032,-0.00359731600213243,-0.00592529678943957,0.0384285651350061,-0.0903153831547270,0.0818855815615984];
Rip_pb0 = Get_ripple(0,0.4,ini_num,ini_den);
Rip_sb0 = Get_ripple(0.6,1,ini_num,ini_den);
g_lambada_p = 10^5 * Rip_pb0;
g_lambada_s = 10^5 * Rip_sb0;
        %compute deviation of group delay, linear ripple, gradient of deviation of group delay, gradient of linear ripple and gradient of ¦µ for initial IIR filter
        %before all this, calculate the group delay first
        num_sam = 314;       %number of sampling points
        [gd_ini,w_ini] = grpdelay(ini_num,ini_den, num_sam);           %gd and w are the group delay response and respective frequency ,314 is the number of sampled points
        %1. deviation of group delay
        matrix = zeros(num_sam,1);
        matrix(:,:) = tau;
        e_tau_ini =  gd_ini - matrix;
        max_index = find(e_tau_ini==(max(e_tau_ini)));
        min_index = find(e_tau_ini==(min(e_tau_ini)));
        
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
         
        %3.1 After this we import a very useful thing, sensitivity map:
        s_map = get_smap(ini_gra_dev_gd_ini,max_index,min_index);
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