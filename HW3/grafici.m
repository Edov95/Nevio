
load('P_e_LE.mat','Pe_LE')
load('P_e_DFE.mat','Pe_DFE')
load('Pe_AWGNsim.mat','Pe_AWGNsim')
%load('Pe_c.mat','Pe_c')
%load('Pe_d.mat','Pe_d')
load('viterbi.mat','Pe_viterbi')
load('fba.mat','Pe_FBA')
Pe_c = [0.0277  0.0139 0.00642 0.00244 0.000808 0.0002670 6.866e-05];
Pe_d=[0.0798 0.0569 0.0385 0.0245 0.0149 0.0079 0.0040];

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