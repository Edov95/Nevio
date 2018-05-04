clc; clear all; close all;

%% Configuration parameters
r = 10;
SNR_dB = 10;

T = 1;
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];
q_c = impz(q_c_num, q_c_denom);

figure, stem(q_c,'.')

%% Generation of the input signal

pn = PN(r); % Si potrebbe fare un load di una cosa già calcolata

pn(pn == 0) = -1;

pn_i = pn(1:ceil(length(pn)/2)-1);
pn_q = pn(ceil(length(pn)/2)+1:end);

%% Filtering through the channel

a_i_prime = upsample(pn_i,4);
a_q_prime = upsample(pn_q,4);
a_prime = a_i_prime + 1i * a_q_prime;

% s_c_i = filter(q_c_num, q_c_denom, a_i_prime);
% %                 |         |        `- Segnale da filtrare
% %                 |         `- Denominatore della funzione di trasferimento
% %                 `- Numeratore della funzione di trasferimento
% 
% s_c_q = filter(q_c_num, q_c_denom, a_q_prime);
% %                 |         |        `- Segnale da filtrare
% %                 |         `- Denominatore della funzione di trasferimento
% %                 `- Numeratore della funzione di trasferimento

s_c = filter(q_c_num, q_c_denom, a_prime);

%% Add noise


r_c = awgn(s_c, SNR_dB);

% r_c_i = awgn(s_c_i, SNR_dB);
% r_c_q = awgn(s_c_q, SNR_dB);

%% Save the workspace

save("common.mat");