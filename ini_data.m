%% Get a set of initial datatau = 20
tau = 20;
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
ini_num = [-0.00332396476858489,0.00907345083529089,-0.0127263115404434,0.0144009933374123,-0.0127423321204385,0.00777504764648083,-0.00524632396938914,0.00261015123717658,0.000698325295528249,0.00119766875456374,-0.00111190231744554,0.00187103796197792,-0.0129380233050938,0.0204217554541046,-0.0340724420516470,0.0572359025487357,-0.0464003957768796,0.0627681446966535,-0.0248866084106148,0.0227288754295488];
ini_den = [1,-4.22900828921032,9.55925949876034,-14.6636253862966,16.9107155239152,-15.5023841018185,11.6698971484826,-7.30527573899595,3.76215735769725,-1.52967464714253,0.439184382520533,-0.0417064525352619,-0.0545424029145210,0.0539674258760853,-0.0284983703028653,0.00356620597696464,0.00838822250579143,-0.00787566148287203,0.00338104515513182,-0.000500303468784228];
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