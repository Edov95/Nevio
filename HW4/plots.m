clear all; close all; clc;

% load('P_bit_DFE.mat','Pbit_DFE')
load('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded')

SNR_lin = 10.^(SNR_dB./10);
sigma_a = 2;
awgn_bound = qfunc(sqrt(SNR_lin));

% SNR = [0:14];
% figure,
% semilogy(SNR, Pbti_DFE,'g')
% ylim([10^-5 10^-1])
% grid on;
figure,
semilogy(SNR_dB, Pbit_OFDM_uncoded,'b-<')
ylim([10^-5 10^-1])
grid on;
hold on,
semilogy(SNR_dB, awgn_bound,'k')