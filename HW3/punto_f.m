clc;
clear all;
%close all;
format long g
%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

Pe_FBA = zeros(length(SNR_dB),1);
errors = zeros(length(SNR_dB),1);
r_r = zeros(length(s_c), length(SNR_dB));

%% Receiver filter

% match filter
g_m = conj(flipud(q_c));

% Computes the impulse response h
h = conv(q_c, g_m);
h = downsample(h,4);
h = h(h ~= 0);

N1 = floor(length(h)/2);
N2 = N1;

for i=1:length(SNR_dB)
    r_r(:,i) = filter(g_m, 1, r_c(:,i));
end

% For debuggig pourpose
s_r = filter(g_m, 1, s_c);

%% Sampling

t_0_bar = length(g_m);
x_no_noise = downsample(s_r(t_0_bar:end), 4);
x = zeros(length(x_no_noise), length(SNR_dB));
for i=1:length(SNR_dB)
    x(:,i) = downsample(r_r(t_0_bar:end, i), 4);
end

%% Filtering through C and equalization

r_gm = xcorr(g_m);
% r_w = N0 .* downsample(r_gm, 4);
for i=1:length(SNR_dB)
    r_w_up(:,i)= N0(i) * r_gm;
    r_w(:,i) = downsample(r_w_up(:,i), 4);
end

M1 = 5; D = 4;
M2 = N2 + M1 - 1 - D;

c =zeros(M1, length(SNR_dB));
b = zeros(M2,1);

for i=1:length(SNR_dB)
    
    [c(:,i) Jmin(i)]= WienerC_DFE(h, r_w(:,i), sigma_a, M1, M2, D);
    psi(:,i) = conv(c(:,i), h);
    %psi(:,i) = psi(:,i)/max(psi(:,i));
    b(:,i) = -psi(find(psi==max(psi))+1:end,i);
    y = conv(x(:,i),c(:,i));
    y = y ./ max(psi(:,i));
    %var_w(i) = 10^(Jmin(i)/10) - (abs(1-max(psi(:,i)))^2)*sigma_a;
    indexD = find(psi(:,i) == max(psi(:,i)));
    L1 = 0; L2 = 4;
    psi_pad = [psi(:,i); 0; 0];
    indexD = find(psi_pad == max(psi_pad));
    decisions = FBA(y, psi_pad(indexD:end), L1, L2);
    [Pe_FBA(i), errors(i)] = SER(a(1:end-4), decisions(5:end));
end

%save('fba.mat', 'Pe_FBA');