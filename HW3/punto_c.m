clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Configuration parameters



%% Reciver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter

scatterplot(r_c);



figure, stem(q_c, '.');
figure, stem(g_AA, '.')

r_r = filter(g_AA, 1, r_c);

eyediagram(r_r(33:end), 4,4);
scatterplot(r_r);


%% Sampling

t_0_bar = 5;

r_r = r_r(t_0_bar:end);

x = downsample(r_r, 2);
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



