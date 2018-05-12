clc; clear all; close all;

%% Configuration parameters
if ~exist("Noise.mat", 'file')
    noise_seq;
end
load('Noise','w','sigma_w');
verbose = false;
plot_figure = false;

r = 20;
SNR_dB = [8 9 10 11 12 13 14];
SNR_lin = 10.^(SNR_dB./10);
sigma_a = 2;

T = 1;
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];
q_c = impz(q_c_num, q_c_denom);

% cut the impulse response when too small
q_c = [0; 0; 0; 0; 0; q_c( q_c >= max(q_c)*10^(-2) )]; 
E_qc = sum(q_c.^2);

N0 = sigma_w./4;

%% Generation of the input signal

pn = PN(r); 

pn(pn == 0) = -1;

a = zeros(floor(length(pn)/2),1);
for i=1:2:(length(pn) - 1)
   a((i+1)/2)=  pn(i) + 1i * pn(i+1);
end

clear pn;

%% Filtering through the channel

a_prime = upsample(a, 4);

s_c = filter(q_c_num, q_c_denom, a_prime);

%% Add noise

r_c = zeros(length(s_c), length(SNR_dB));

for i = 1:length(SNR_dB)
    r_c(:,i) = s_c + w(1:length(s_c),i);
end

%% Save the workspace

save("common.mat");