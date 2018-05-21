clear all; close all; clc;

load('P_e_DFE.mat','Pe_DFE')

SNR = [0:14];
figure,
semilogy(SNR, Pe_DFE,'g')
ylim([10^-5 10^-1])
grid on;
