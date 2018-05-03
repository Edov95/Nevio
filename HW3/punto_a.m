clc; clear all; close all;
%%%%%%%%%%%%%%%
% Possibile modifica, estrarre le parti comuni a tutti gli esercizi come:
%   * Configuration parameters
%   * Generation of the input signal
%   * filtering through the channel, il rumore va aggiunto una volta che so
%       l'SNR

%% Configuration parameters

t_0_tilde = 5;
T = 1;
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];

Q_c = freqz(q_c_num,q_c_denom);

SNR_dB = 10;

%% Generation of the input signal

pn = pn_seq(ord); % Si potrebbe fare un load di una cosa già calcolata

%% Filtering thorugh the channel

a_i_prime = upsample(pn_i,4);
a_q_prime = upsample(pn_q,4);

s_c_i = filter(q_c_num, q_c_denom, a_i_prime);
%                 |         |        `- Segnale da filtrare
%                 |         `- Denominatore della funzione di trasferimento
%                 `- Numeratore della funzione di trasferimento

s_c_q = filter(q_c_num, q_c_denom, a_q_prime);
%                 |         |        `- Segnale da filtrare
%                 |         `- Denominatore della funzione di trasferimento
%                 `- Numeratore della funzione di trasferimento

%% Add noise

r_c_i = awgn(s_c_i, SNR_dB);
r_c_q = awgn(s_c_q, SNR_dB);

%% Reciver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter



%% Sampling

t_0 = t_0_tilde * T / 4;

r_q_c = r_q_c(t_0:end);

x = downsample(r_q_c,T);

%% Filtering through C

y = filter([0 0 1],1,x);
%             |    | `- Segnale da filtrare
%             |    `- Denominatore della funzione di trasferimento
%             `- Numeratore della funzione di trasferimento

%% Decision point


%% plots
figure
plot(10*log10(abs(Q_C)));

