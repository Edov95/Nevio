clc; close all; clear global; clearvars;
%generates white noise with variance -10dB, 3 million samples

q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];
q_c = impz(q_c_num, q_c_denom);

length_w = 3 * 10^6;
% cut the impulse response
q_c = [0; 0; 0; 0; 0; q_c( q_c >= max(q_c)*10^(-2) )];
E_qc = sum(q_c.^2);

SNR_dB = [8:14];
sigma_a = 2;
SNR_lin = 10.^(SNR_dB./10);
w = zeros(length_w, 7);
sigma_w = zeros(length(SNR_dB),1);
for i=1:length(SNR_dB)
    sigma_w(i) = (sigma_a * E_qc) / SNR_lin(i);
    w(:,i) = sqrt(sigma_w(i))/sqrt(2).*(randn(length_w, 1) + 1i*randn(length_w, 1));
    %w(:,i) = wgn(length_w, 1, 10*log10(sigma_w(i)), 'complex');
end

save('Noise','w','sigma_w')
