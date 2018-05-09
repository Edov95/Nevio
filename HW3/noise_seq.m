clc; close all; clear global; clearvars;
%generates white noise with variance -10dB, 3 million samples 

q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];
q_c = impz(q_c_num, q_c_denom);

% cut the impulse response
q_c = [0; 0; 0; 0; 0; q_c( q_c >= max(q_c)*10^(-2) )]; 
E_qc = sum(q_c.^2);

SNR_dB = [8 9 10 11 12 13 14];
sigma_a = 2;
% SNR_dB = 10;
SNR_lin = 10.^(SNR_dB./10);
w = zeros(3*10^6, 7);
for i=1:length(SNR_dB)
    sigma=(sigma_a*E_qc*4)/SNR_lin(i);
    sigmaw=10*log10(sigma);
    w(:,i) = wgn(3*10^6,1,sigmaw,'complex');
end

save('Noise','w')
