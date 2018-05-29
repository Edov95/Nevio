clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l','uncoded_a')

%% CODED

% SNR_dB = [0.9:0.05:1.6];
% for i=1:length(SNR_dB)
% [Pbit_OFDM_coded(i) b_l_hat] = OFDM_coded(a, b_l, 11, 91, 10^(SNR_dB(i)/10));
% end

SNR_dB = 1.2;
[Pbit_OFDM_coded b_l_hat] = OFDM_coded(a, b_l, 11, 91, 10^(SNR_dB/10));

% SNR_dB = 1.1;
% for i=7:20
% [Pbit_coded(i) b_l_hat] = OFDM_coded(a, b_l, i, 91, 10^(SNR_dB./10));
% end
% save('OFDM_coded.mat','Pbit_OFDM_coded')


%% UNCODED
% SNR_dB = 10;
% for i=10:100 
% [Pbit_OFDM_uncoded(i) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 11, i, 10^(SNR_dB/10));
% end


% SNR_dB = [4:0.5:14];
% for i=1:length(SNR_dB)
% [Pbit_OFDM_uncoded(i) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 11, 91, 10^(SNR_dB(i)/10));
% end
%save('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded1');
% 

% [Pbit_uncoded b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8, 21, 10.^(SNR_dB/10));



