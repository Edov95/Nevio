clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Receiver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter

%scatterplot(r_c);

%g_m = conj(q_c(end:-1:1));
g_m = conj(flipud(q_c));

h = conv(q_c, g_m);
figure, stem(h)
title('h_i'), xlabel('nT/4')

figure, stem(q_c), xlabel('nT/4'), title('q_c')
figure, stem(g_m), xlabel('nT/4'), title('g_M')

r_r = filter(g_m, 1, r_c);
% r_r=filter(h , 1, awgn(a_prime, SNR_dB, 'measured'));
s_r = filter(g_m, 1, s_c);
% transient = length(q_c) - 1;
% s_r_eye = s_r(transient+1:end);
% eyediagram(s_r_eye, 4)
scatterplot(r_r);


%% Sampling

t_0_bar = find(h==max(h));

r_cut = r_r(t_0_bar:end);

x = downsample(r_cut, 4);
scatterplot(x);

[Q_c f]= freqz(q_c_num, q_c_denom, 'whole');

%% plots
figure
plot(f/(2*pi), 10*log10(abs(Q_c))), 
title('Frequency response Q_c')



