clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Receiver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter
g_m = conj(flipud(q_c));

% Calculate the h impulse response
h = conv(q_c, g_m);

r_r = filter(g_m, 1, r_c(:,1));

% For debuggig pourpose
% s_r = filter(g_m, 1, s_c);

%% Sampling

t_0_bar = find(h==max(h));

r_cut = r_r(t_0_bar:end);

x = downsample(r_cut, 4);

%% Filtering thorugh C and equalization

r_gm = xcorr(g_m, g_m);
r_w = N0 .* r_gm;

D = 2;
    
c = WienerC_DFE(h, r_w, sigma_a, 4, 0, D);

psi = conv(c, h);

decisions = equalization(x, c, 4, 0, D);

[Pe errors] = SER(a(1:length(decisions)), decisions);
% [pbit, errors] = BER(a(1:length(decisions)), decisions);

%% plots
if plot_figure == true
    
    [Q_c f] = freqz(q_c_num, q_c_denom, 'whole');
    
    figure, stem(h)
    title('h_i'), xlabel('nT/4')

    figure, stem(q_c), xlabel('nT/4'), title('q_c')
    figure, stem(g_m), xlabel('nT/4'), title('g_M')
    
    figure
    plot(f/(2*pi), 10*log10(abs(Q_c))), 
    title('Frequency response Q_c')
end



