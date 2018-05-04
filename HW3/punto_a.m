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
% 
% r_r_i = r_c_i;
% r_r_q = r_c_q;

% MATCHED filter find on 
%   https://it.mathworks.com/matlabcentral/answers/4502-matched-filter

g_m = q_c(end:-1:1);
figure, stem(g_m,'.')

r_r = filter(g_m, 1, r_c);

eyediagram(r_r, 4,4);


%% Sampling

t_0_bar = 3;

r_r = r_r(3:end);

x = downsample(r_r, 4);
% r_r_i = r_r_i(t_0:end);
% r_r_q = r_r_q(t_0:end);
% 
% x_i = downsample(r_r_i,4*T);
% x_q = downsample(r_r_q,4*T);

%% Filtering through C

y_i = filter([0 0 1],1,x_i);
%               |    |  `- Segnale da filtrare
%               |    `- Denominatore della funzione di trasferimento
%               `- Numeratore della funzione di trasferimento

y_q = filter([0 0 1],1,x_q);
%               |    |  `- Segnale da filtrare
%               |    `- Denominatore della funzione di trasferimento
%               `- Numeratore della funzione di trasferimento

%% Decision point


%% plots
figure
plot(10*log10(abs(freqz(q_c_num,q_c_denom))));



