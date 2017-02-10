%IIR FILTER DOCMENTATION

%THIS IIR FILTER DOCUMENTATION IS SPECIALLY DESIGNED FOR MYSELF TO CHECK
%THOSE PREVIOUS WORKS

%% Variable Names

%{
Global part:
    deviation of group delay: g_etau
    linear ripple (pass, stop band included):g_lr_pass,  g_lr_stop
    gradient of deviation of group delay: g_dev_etau
    gradient of linear ripple: g_gradient_lr_pass, g_gradient_lr_stop
    
    sample number: g_sample_num
    passband area(from the first number to the second number): g_pass_area
    stopband area(from the first number to the second number): g_stop_area
    lambada_p: g_lambada_p
    lambada_s: g_lambada_s





%}


%% version 1.0

%try to realize the function of the provided paper