
load('P_e_LE.mat','Pe_LE')
load('P_e_DFE.mat','Pe_DFE')
load('Pe_AWGNsim.mat','Pe_AWGNsim')
%load('Pe_c.mat','Pe_c')
%load('Pe_d.mat','Pe_d')
load('viterbi.mat','Pe_viterbi')
load('fba.mat','Pe_FBA')
Pe_c = [0.0252 0.0120 0.0052 0.0017 4.8257e-04 1.2017e-04 2.2889e-05];
Pe_d=[0.0399 0.0219 0.0107 0.0047 0.0016 5.1308e-04 1.0872e-04];

SNR=[8:14];
SNR_lin = 10.^(SNR./10);
sigma_a = 2;
awgn_bound = 2*qfunc(sqrt(SNR_lin));


figure,
semilogy(SNR, Pe_LE,'b--')
grid on;
hold on,
semilogy(SNR, Pe_DFE,'b')
hold on,
semilogy(SNR, Pe_c,'k--')
hold on,
semilogy(SNR, Pe_d,'k')
hold on,
semilogy(SNR, Pe_viterbi, 'r--')
hold on,
semilogy(SNR, Pe_FBA, 'r')
hold on,
semilogy(SNR, Pe_AWGNsim, 'g--')
hold on,
semilogy(SNR, awgn_bound,'g')
ylim([10^-4 10^-1])
xlim([8 14])
xlabel('SNR [dB]')
ylabel('P_e')
legend('MF+LE@T','MF+DFE@T','AAF+MF+DFE@T/2','AAF+DFE@T/2','VA','FBA', ... 
    'MF b-S','MF b-T');