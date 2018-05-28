clear all; close all; clc;

% load('P_bit_DFE.mat','Pbit_DFE')
load('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded')
load('DFE_uncoded.mat','Pbit_DFEunc');
load('DFE_coded.mat','Pbit_DFEenc');
load('OFDM_coded.mat','Pbit_OFDM_coded');

SNR_lin = 10.^(SNR_dB./10);
sigma_a = 2;
awgn_bound = qfunc(sqrt(SNR_lin));

figure,
semilogy(SNR_dB, Pbit_OFDM_uncoded,'b-<')
ylim([10^-5 10^-1])
grid on;
hold on,
semilogy(SNR_dB, awgn_bound,'k')
hold on,
semilogy(SNR_dB, Pbit_DFEunc,'g-*')
xlabel('SNR [dB]')
ylabel('P_{bit}')
title('Uncoded')

SNR_dB_encDFE = [1.2:0.05:1.75];
SNR_dB_encOFDM = [2.2:0.05:2.5];
figure,
semilogy(SNR_dB_encDFE, Pbit_DFEenc,'g-*')
hold on,
ylim([10^-5 10^-1])
xlim([1 3]);
semilogy(SNR_dB_encOFDM, Pbit_OFDM_coded,'b-<')
% grid on;
% hold on,
% semilogy(SNR_dB, awgn_bound,'k')
% hold on,
% semilogy(SNR_dB, Pbit_DFEunc,'g-*')
xlabel('SNR [dB]')
ylabel('P_{bit}')
title('Coded')