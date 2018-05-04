clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Configuration parameters

t_0_tilde = 12;
SNR_dB = 10;


%% Add noise

r_c_i = awgn(s_c_i, SNR_dB);
r_c_q = awgn(s_c_q, SNR_dB);

% eyediagram(r_c_i,4);

%% Reciver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter
% 
% r_r_i = r_c_i;
% r_r_q = r_c_q;

% MATCHED filter find on 
%   https://it.mathworks.com/matlabcentral/answers/4502-matched-filter

b_i = r_c_i(end:-1:1);
b_q = r_c_q(end:-1:1);

r_r_i = filter(b_i, 1, r_c_i);
r_r_q = filter(b_q, 1, r_c_q);

eyediagram(r_r_i, 5);
eyediagram(r_r_q, 5);


%% Sampling

t_0 = t_0_tilde * T / 4;

r_r_i = r_r_i(t_0:end);
r_r_q = r_r_q(t_0:end);

x_i = downsample(r_r_i,4*T);
x_q = downsample(r_r_q,4*T);

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



