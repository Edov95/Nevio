clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l','uncoded_a')

% SNR_dB = [5:0.5:15];
% for i=1:length(SNR_dB)
% [Pbit_OFDM_uncoded(i) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8, 10^(SNR_dB(i)/10));
% end

%save('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded');
SNR_dB = 2.5;
[Pbit_coded b_l_hat] = OFDM_coded(a, b_l, 8, 10^(SNR_dB./10));

% [Pbit_uncoded b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8, 10^(SNR_dB/10));
