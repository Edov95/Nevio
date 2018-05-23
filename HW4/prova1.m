clear all; close all; clc;

load('generated_symbols.mat','a','enc_b_l','b_l')

[Pbit b_l_hat] = OFDM(a, enc_b_l, b_l, 50, 2);