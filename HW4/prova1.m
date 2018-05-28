clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l','uncoded_a')

% SNR_dB = [2.2:0.05:2.5];
% for i=1:length(SNR_dB)
% [Pbit_OFDM_coded(i) b_l_hat] = OFDM_coded(a, b_l, 8, 21, 10^(SNR_dB(i)/10));
% end
% save('OFDM_coded.mat','Pbit_OFDM_coded')
%save('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded');
% SNR_dB = 2.5;
% [Pbit_coded b_l_hat] = OFDM_coded(a, b_l, 8, 21, 10^(SNR_dB./10));

% [Pbit_uncoded b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8, 21, 10.^(SNR_dB/10));

%[Pbit_vc b_l_hat] = OFDM_uncoded_Vc(uncoded_a, b_l, 8, 10.^(SNR_dB/10));

% for k=1:50
%     [Pbit_OFDM_uncoded(k) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8,k, 10^(SNR_dB(1)/10));
% end

% for k=1:30
%     [Pbit_OFDM_uncoded(k) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, k,21, 10^(SNR_dB(1)/10));
% end
