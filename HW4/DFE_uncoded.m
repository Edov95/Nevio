clear all; close all; clc;
format long g;

sigma_a = 2;
load('generated_symbols.mat','b_l','uncoded_a')

% Generate the channel input response
[q_c, E_qc] = channel_impulse_response();

a_prime = upsample(uncoded_a, 4);

% Filter through the channel
s_c = filter(q_c, 1, a_prime);

SNR_vector = [4:0.5:14];
Pbit_DFEunc = zeros(length(SNR_vector),1);

for snr_index = 1:length(SNR_vector)
    SNR = SNR_vector(snr_index);
    % Add Gaussian Noise
    snrlin = 10^(SNR/10);
    sigma_w = sigma_a * E_qc / snrlin;
    w = wgn(length(s_c), 1, 10 * log10(sigma_w), 'complex');
    rcv_bits = s_c + w;
    
    % Reciver structure
    g_m = conj(flipud(q_c));
    
    % compute the impulse response h
    h = conv(q_c, g_m);
    h = downsample(h,4);
    h = h(h ~= 0);
    
    N1 = floor(length(h)/2);
    N2 = N1;
    
    r_r = filter(g_m, 1, rcv_bits);
    
    t_0_bar = length(g_m);
    
    x = downsample(r_r(t_0_bar:end), 4);
    
    % Filtering through C and equalization
    r_gm = xcorr(g_m);
    % r_w = N0 .* downsample(r_gm, 4);
    r_w_up = sigma_w / 4 * r_gm;
    r_w = downsample(r_w_up, 4);
    
    M1 = 5;
    D = 4;
    M2 = N2 + M1 - 1 - D;
    
    
    [c Jmin]= WienerC_DFE(h, r_w, sigma_a, M1, M2, D);
    
    psi = conv(c, h);
    
    M1 = 5; D = 4;
    M2 = N2 + M1 - 1 - D;
    
    b = -psi(find(psi==max(psi))+1:end);
    
    y_k = equalization_DFE(x, c, b, D, max(psi));
    
    decisions = zeros(length(y_k),1);
    for i = 1:length(y_k)
        decisions(i) = threshold_detector(y_k(i));
    end
    
    detected_bits = IBMAP(decisions);
    
    [Pbit_DFEunc(snr_index), errors] = BER(detected_bits, b_l(1:length(detected_bits)));
end

save('DFE_uncoded.mat','Pbit_DFEunc');