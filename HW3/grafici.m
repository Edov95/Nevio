
load('P_e_LE.mat','Pe_LE')
load('P_e_DFE.mat','Pe_DFE')
load('Pe_AWGNsim.mat','Pe_AWGNsim')
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
semilogy(SNR, awgn_bound,'g')
hold on,
semilogy(SNR, Pe_AWGNsim, 'g--')
ylim([10^-4 10^-1])
xlim([8 14])
xlabel('SNR [dB]')
ylabel('P_e')
legend('MF+LE@T','MF+DFE@T','MF b-T','MF b-S');