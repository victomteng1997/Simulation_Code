% test inital iir
f = [0 0.4  0.6 1];                   %a passband of 0.4-0.6
a = [1.0 1.0 0.0 0];
b = firpm(30,f,a,[100,200]);
len = length(b);
a = zeros(1,len);
a(1) = 1;
sys = tf(b,a,0.05);
GRED = balancmr(sys);
es = 0.01; %stability margin
tau = 15;

A_t = GRED.A;
B_t = GRED.B;
C_t = GRED.C;
D = GRED.D;
%then generate iir
[b,a] = ss2tf(A_t,B_t,C_t,D);     %a, b are numerators and denominators ( a very special case here, the author use a as num and b as den)
[h,w] = freqz(b,a,'whole',2001);

figure('Name','magnitude');
plot(w/pi,20*log10(abs(h)))
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')


figure('Name','group delay');
[gd,w] = grpdelay(b,a,314);
plot(w/pi,gd);