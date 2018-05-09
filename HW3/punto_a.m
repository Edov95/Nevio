clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");
Pe = zeros(length(SNR_dB),1);
errors = zeros(length(SNR_dB),1);
r_r = zeros(length(s_c), length(SNR_dB));

%% Receiver filter

% Costruzione del filtro g_M
% Per l'esercizio a ши un "semplice" matched filter
g_m = conj(flipud(q_c));

% Calculate the h impulse response
h = conv(q_c, g_m);
h = downsample(h,4);
h = h(h ~= 0);

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

%scatterplot(x)
%% Filtering thorugh C and equalization

r_gm = xcorr(g_m, g_m);
r_w = N0 .* downsample(r_gm, 4);
D = 2;
M1 = 5;
M2 = 0;
    
c = WienerC_DFE(h, r_w, sigma_a, M1, M2, D);

psi = conv(c, h);


for i=1:length(SNR_dB)
    decisions = equalization_LE(x(:,i), c, M1, D, max(psi));
    
    [Pe(i), errors(i)] = SER(a(1:length(decisions)), decisions);
end
%% plots
% if plot_figure == true
%     
%     [Q_c, f] = freqz(q_c_num, q_c_denom, 'whole');
%     
%     figure, stem(h)
%     title('h_i'), xlabel('nT')
% 
%     figure, stem(q_c), xlabel('nT/4'), title('q_c')
%     figure, stem(g_m), xlabel('nT/4'), title('g_M')
%     
%     figure
%     plot(f/(2*pi), 10*log10(abs(Q_c))), 
%     title('Frequency response Q_c')
% end



