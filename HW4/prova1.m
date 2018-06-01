clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l','uncoded_a')

parpool;

%% CODED
% SNR_dB = [0.9:0.05:1.6];
% parfor i=1:length(SNR_dB)
%     [Pbit_OFDM_coded(i) b_l_hat] = OFDM_coded(a, b_l, 18, 43, 10^(SNR_dB(i)/10));
% end

% save('OFDM_coded.mat','Pbit_OFDM_coded')

% SNR_dB = 1.3;
% [Pbit_OFDM_coded b_l_hat] = OFDM_coded(a, b_l, 16, 43, 10^(SNR_dB/10));

% SNR_dB = 1.3;
% parfor i=1:60
%     [Pbit_coded(i) b_l_hat] = OFDM_coded(a, b_l, 16, i, 10^(SNR_dB./10));
% end
% save('OFDM_coded.mat','Pbit_OFDM_coded')

% SNR_dB = 1.3 ;
% parfor i=10:30
%     [Pbit_coded(i) b_l_hat] = OFDM_coded(a, b_l, i, 17, 10^(SNR_dB./10));
% end

%% UNCODED
% SNR_dB = 10;
% for i=10:100
% [Pbit_OFDM_uncoded(i) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 20, i, 10^(SNR_dB/10));
% end


% SNR_dB = [4:0.5:14];
% parfor i=1:length(SNR_dB)
% [Pbit_OFDM_uncoded(i) b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 18, 43, 10^(SNR_dB(i)/10));
% end
%save('OFDM_uncoded.mat','SNR_dB','Pbit_OFDM_uncoded1');
%

% [Pbit_uncoded b_l_hat] = OFDM_uncoded(uncoded_a, b_l, 8, 21, 10.^(SNR_dB/10));



