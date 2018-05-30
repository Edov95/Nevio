clear all; close all; clc;

load('AWGN_coded.mat', 'Pbit_AWGN');
load('OFDM_uncoded.mat','Pbit_OFDM_uncoded')
load('DFE_uncoded.mat','Pbit_DFEunc');
load('DFE_coded1.mat','Pbit_DFEenc');
load('OFDM_coded3.mat','Pbit_OFDM_coded');

SNR_dB = [4:0.5:14];
SNR_lin = 10.^(SNR_dB./10);
sigma_a = 2;
awgn_bound = qfunc(sqrt(SNR_lin));

figure,
semilogy(SNR_dB, Pbit_DFEunc,'g-o')
ylim([10^-5 10^-1])
grid on;
hold on,
semilogy(SNR_dB, Pbit_OFDM_uncoded,'b-<')
hold on,
semilogy(SNR_dB, awgn_bound,'k')
xlabel('SNR [dB]')
ylabel('P_{bit}')
title('Uncoded')
legend({'DFE','OFDM','AWGN'})

SNR_dB_encDFE = [1.4:0.025:1.75];
SNR_dB_encOFDM = [0.9:0.05:1.6];
SNR_dB_awgn =[0.4:0.05:1];
figure,
semilogy(SNR_dB_encDFE, Pbit_DFEenc,'g-o')
hold on,
ylim([10^-5 10^-1])
xlim([0 3]);
semilogy(SNR_dB_encOFDM, Pbit_OFDM_coded,'b-<')
grid on;
hold on,
semilogy(SNR_dB_awgn, Pbit_AWGN,'k')
xlabel('SNR [dB]')
ylabel('P_{bit}')
title('Coded')
legend({'DFE','OFDM','AWGN'})