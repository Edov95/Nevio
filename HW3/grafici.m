clear all; close all; clc;

Perr=[0.0267 0.0231 0.0201 0.0167 0.0134 0.0105 0.0079];
SNR=[8:14];
SNR_lin = 10.^(SNR./10);
sigma_a = 2;
M = 4;
awgn_bound = 4*(1-1/sqrt(M))*qfunc(sqrt(SNR_lin/(sigma_a/2)));


figure,
plot(SNR, 10*log10(Perr),'<-'), hold on, plot(SNR, 10*log10(awgn_bound))
ylim([10*log10(10^-4) 10*log10(10^-1)])
xlabel('SNR [dB]')
ylabel('P_e')
