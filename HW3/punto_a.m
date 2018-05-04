clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Configuration parameters

t_0_tilde = 12;
SNR_dB = 10;


%% Reciver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter

scatterplot(r_c);

g_m = q_c(end:-1:1);
figure, stem(q_c, '.');
figure, stem(g_m,'.')

r_r = filter(g_m, 1, r_c);

eyediagram(r_r, 4,4);
scatterplot(r_r);


%% Sampling

t_0_bar = 3;

r_r = r_r(t_0_bar:end);

x = downsample(r_r, 4);
scatterplot(x);

%% Filtering through C

y = filter([0 0 1],1,x);
%             |    | `- Segnale da filtrare
%             |    `- Denominatore della funzione di trasferimento
%             `- Numeratore della funzione di trasferimento

%% Decision point


%% plots
figure
plot(10*log10(abs(freqz(q_c_num,q_c_denom))));



