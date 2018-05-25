clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l')

% Pbit = zeros(100,1);
% for i=45:100
% [Pbit(i) ~] = OFDM(a, enc_b_l, b_l, 18, 2, i);
% end

[Pbit b_l_hat] = OFDM_coded(a, b_l, 17, 2);
