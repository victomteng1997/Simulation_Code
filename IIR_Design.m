function [ IIRcoe_best ] = IIR_Design(num_sam,Rip_pb, Rip_sb) %b is the fir filter initial coe
num_sam = 314;       %number of sampling points
addpath 'c:\Program Files\mosek\7\toolbox\r2013a' 
addpath(genpath('F:\IIR filter\YALMIP-master'))
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



N_red = 10;
global tau
while N_red <= (2/3*N_fir)
    disp(N_red);
    rho = 0.01;
    %the following part is about getting the initial iir filter coef
    %before this, wp and ws are needed to be stated
    %hence, I added this part into Model Reduction
    [ini_num,ini_den] = another_mr(N_red);             %2017/1/26 change ini_coe to ini_num and ini_den to minimize the dimensional problem
    %calculate ripple of inital IIR      here assume wp = 0.4, ws = 0.6
    Rip_pb0 = Get_ripple(0,0.4,ini_num,ini_den);
    Rip_sb0 = Get_ripple(0.6,1,ini_num,ini_den);
    g_lambada_p = 100 * Rip_pb0;
    g_lambada_s = 100 * Rip_sb0;
    while rho > 10^(-4) && g_lambada_p <= 10^5 && g_lambada_s <= 10^5
        %compute deviation of group delay, linear ripple, gradient of deviation of group delay, gradient of linear ripple and gradient of ¦µ for initial IIR filter
        %before all this, calculate the group delay first
        
        [gd_ini,w_ini] = grpdelay(ini_num,ini_den, num_sam);           %gd and w are the group delay response and respective frequency ,314 is the number of sampled points
        %1. deviation of group delay
        matrix = zeros(num_sam,1);
        matrix(:,:) = tau;
        e_tau_ini =  gd_ini - matrix;
        disp('inital etau')
        disp(norm(e_tau_ini(1:round(0.4*num_sam)),inf))
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
        
        
        %let IIRcoe = IIRcoe_ini
        IIRcoe = IIRcoe_ini;
        IIRnum = ini_num;
        IIRden = ini_den;
        global IIRnum IIRden
        while 1
            %Solve the convex maximizing problem
            dbstop if error
            delta_x = mosek_optimzer(0.999,IIRden);
            delta_x = transpose(delta_x);
            %calculate new performances
            IIRcoe = IIRcoe + delta_x;
            new_num = IIRcoe(1:length(IIRnum));
            new_den = IIRcoe(length(IIRnum)+1:length(IIRcoe));
            %1. deviation of group delay
            [new_gd,new_w] = grpdelay(new_num,new_den, num_sam);
            new_etau = new_gd - matrix;
            %2. gradient of deviation of group delay
            new_gra_dev_gd = Gra_Dev_Group_delay(new_num,new_den,num_sam,new_etau,tau); 
            %check passband only
            c_etau = g_etau(1:round(0.4*num_sam));
            cn_etau = new_etau(1:round(0.4*num_sam));
            
            c_dev_etau = g_dev_etau(1:round(0.4*num_sam),:);
            if (norm(c_etau,2) - norm(cn_etau,2)) < 0 || (norm(c_etau,2) - norm(cn_etau,2))/(norm(c_etau,2) - norm(c_etau+c_dev_etau*transpose(delta_x),2)) < 0.3
                rho = 0.5*rho;
                disp('situation 1');
                disp(norm(c_etau,2) - norm(cn_etau,2))
                disp(norm(c_etau,2) - norm(cn_etau+c_dev_etau*transpose(delta_x),2))
                IIRcoe = IIRcoe - delta_x;
            else
                disp('situation 2');
                IIRnum = new_num;
                IIRden = new_den;
                disp(norm(c_etau,2) - norm(cn_etau,2))
                disp(norm(c_etau,2) - norm(cn_etau+c_dev_etau*transpose(delta_x),2))
                rho = 1.1*rho;
               
                
                
                
                % Recalculate everything
                [gd,w] = grpdelay(IIRnum,IIRden, num_sam);           %gd and w are the group delay response and respective frequency ,314 is the number of sampled points
                %1. deviation of group delay
                matrix = zeros(num_sam,1);
                matrix(:,:) = tau;
                e_tau =  gd - matrix;
                max_index = find(e_tau==(max(e_tau)));
                min_index = find(e_tau==(min(e_tau)));

                g_etau = e_tau;
                %2 linear ripple
                %function Linear_Ripple gives the linear ripple in specific region
                psband1 = Linear_Ripple(0,0.4, 'pass',num_sam,IIRnum,IIRden,tau);
                trband1 = Linear_Ripple(0.4,0.6,'tran',num_sam,IIRnum,IIRden,tau);
                stband1 = Linear_Ripple(0.6,1,'stop',num_sam,IIRnum,IIRden,tau);
                g_lr_pass = psband1;
                g_lr_tran = trband1;
                g_lr_stop = stband1;
                %one more situation should be added in here, which is the
                %transition band

                %3 gradient of deviation of group delay
                ini_gra_dev_gd = Gra_Dev_Group_delay(IIRnum,IIRden,num_sam,e_tau,tau);
                g_dev_etau = ini_gra_dev_gd;

                %4 gradient of deviation of linear ripple
                %passband 0-0.4
                pass_gra_dev = Deviation_Ripple(0,0.4, 'pass',num_sam,IIRnum,IIRden,tau);
                g_gradient_lr_pass = pass_gra_dev;
                %stopband 0.6-1
                end_gra_dev = Deviation_Ripple(0.6,1, 'pass',num_sam,IIRnum,IIRden,tau);
                g_gradient_lr_stop = end_gra_dev;
                pass_ripple = Get_ripple(0.1,0.3,IIRnum,IIRden);
                stop_ripple = Get_ripple(0.6,1,IIRnum,IIRden);
                g_lambada_p = 10^5 * pass_ripple;
                g_lambada_s = 10^5 * stop_ripple;
                disp('pass ripple')
                disp(abs(pass_ripple-Rip_pb))
                
                if abs(Rip_pb-pass_ripple)<1e-2 && abs(Rip_sb-stop_ripple)<1e-2
                    IIRcoe_best = IIRcoe;
                    disp('one best coeff generated');
                    %Get the current sensitivity map, current coeffs
                    s_map = get_smap(new_gra_dev_gd,max_index,min_index);
                
                    %Call python code here.
                    System(Python, discrete_dotting.py);
                    break
                end
            
            end
        end   
    end
    N_red = N_red + 1;
    tau = N_fir/2;
end

