clc; clear all; close all;
format long g
%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

g_m = flipud(q_c);
figure, stem(0:length(g_m)-1,g_m), title('g_m'), xlabel('nT/4')
figure, stem(0:length(q_c)-1,q_c), title('q_c'), xlabel('nT/4')

h_up = conv(q_c, g_m);
figure, stem(0:length(h_up)-1, h_up), title('h_up'), xlabel('nT/4')
h = downsample(h_up, 4);
%h = h(h ~= 0);
figure, stem(0:length(h)-1,h), title('h'), xlabel('nT')

s_r =filter(g_m,1,s_c);
r_r=filter(g_m,1,r_c(:,3));
figure, stem(s_r(1:100)), title('s_r'), xlabel('nT/4')
figure, stem(r_r(1:100)), title('r_r'), xlabel('nT/4')


t0_bar=find(h_up==max(h_up));
x = downsample(r_r(t0_bar:end), 4);
x_no_noise = downsample(s_r(t0_bar:end),4);
scatterplot(x_no_noise)

r_gm = xcorr(g_m);
N0 = (sigma_a * E_qc)/(4*SNR_lin(3));
r_w = N0 * downsample(r_gm, 4);

D = 2;
M1 = 5;
M1vect = [2:20];
for i=1:length(M1vect);
[c Jmin(i)]= WienerC_LE(h, r_w, sigma_a, M1vect(i), D);
end
figure,
plot(2:20, Jmin)
xlabel('M_1')
title('A) D=2')
ylabel('J_{min} [dB]')

psi = conv(c, h);

%equalization no noise
%decisions = equalization_LE(x_no_noise, c, M1, D, max(psi));
%equalization with noise
decisions = equalization_LE(x, c, D, max(psi));
%detection
[Pe_LE, errors] = SER(a(1:length(decisions)), decisions);