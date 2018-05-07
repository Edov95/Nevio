clc; clear all; close all;

%% Configuration parameters
r = 20;
SNR_dB = 10;
SNR_lin = 10^(SNR_dB/10);

T = 1;
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];
q_c = impz(q_c_num, q_c_denom);
q_c = [0; 0; 0; 0; 0; q_c(find(q_c>=max(q_c)*10^(-2)))];
E_qc = sum(q_c.^2);

%% Generation of the input signal

pn = PN(r); % Si potrebbe fare un load di una cosa già calcolata

pn(pn == 0) = -1;


for i=1:2:(length(pn)-3)
   a((i+1)/2)=  pn(i) + 1i * pn(i+1);
end

% pn_i = pn(1:ceil(length(pn)/2)-1);
% pn_q = pn(ceil(length(pn)/2)+1:end);

%% Filtering through the channel

% a = pn_i + 1i * pn_q;
sigma_a = 2;
N0 =  (sigma_a * E_qc) / SNR_lin;
a_prime = upsample(a, 4);

s_c = filter(q_c_num, q_c_denom, a_prime);

%% Add noise

% w = wgn(SNR_dB, 'complex');
%r_c = s_c;
r_c = awgn(s_c, SNR_dB, 'measured');

%% Save the workspace

save("common.mat");