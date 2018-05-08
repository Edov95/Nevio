clear all; close all; clc;

Perr=[0.0155 0.0068 0.0024 0.000638 1.16e-04 5.72e-06 0];
SNR=[8:14];
SNR_lin = 10.^(SNR./10);
sigma_a = 2;
M = 4;
awgn_bound = 4*(1-1/sqrt(M))*qfunc(sqrt(SNR_lin/(sigma_a/2)));


figure,
plot(SNR, 10*log10(Perr),'b--'), hold on, plot(SNR, 10*log10(awgn_bound),'g')
ylim([10*log10(10^-4) 10*log10(10^-1)])
xlim([8 14])
yticks([-40 -30 -20 -10])
yticklabels({'10^{-4}','10^{-3}','10^{-2}','10^{-1}'})
xlabel('SNR [dB]')
ylabel('P_e')
