clear all; close all; clc;

Perr_LE=[0.2127 0.1662 0.1228 0.0848 0.0543 0.0308 0.0156];
Perr_DFE = [0.211 0.165 0.121 0.0828 0.0524 0.029 0.0143];
SNR=[8:14];
SNR_lin = 10.^(SNR./10);
sigma_a = 2;
M = 4;
awgn_bound = 4*(1-1/sqrt(M))*qfunc(sqrt(SNR_lin/(sigma_a/2)));


figure,
plot(SNR, 10*log10(Perr_LE),'b--'),hold on, 
plot(SNR, 10*log10(Perr_DFE),'b'), hold on,
plot(SNR, 10*log10(awgn_bound),'g')
ylim([10*log10(10^-4) 10*log10(10^-1)])
xlim([8 14])
yticks([-40 -30 -20 -10])
yticklabels({'10^{-4}','10^{-3}','10^{-2}','10^{-1}'})
xlabel('SNR [dB]')
ylabel('P_e')
