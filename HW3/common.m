clc; clear all; close all;

%% Configuration parameters
ord = 255;

T = 1;
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];

%% Generation of the input signal

pn = PN(ord); % Si potrebbe fare un load di una cosa già calcolata

pn(pn == 0) = -1;

pn_i = pn;
pn_q = pn;

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

%% Save the workspace

save("common.mat");