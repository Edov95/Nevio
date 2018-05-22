clear all; close all; clc;
format long g;

% THIS SCRIPT GENERATES THE SYMBOLS BY USING A PN SEQUENCE 
% AND APPLYING LDP ENCODING AND INTERLEAVING

b_l = [PN(20); PN(20)];
sstep = 32400;
num_bits = floor(length(b_l) / sstep) * sstep;
b_l = b_l(1:num_bits + 54);

sigma_a = 2;

% ENCODE VIA LDPC

%create LDPC encoder with the dafault matrix (rate=1/2)
encoderLDPC = comm.LDPCEncoder;
enc_b_l = zeros(2*length(b_l),1);
for i = 0:(floor(length(b_l)/sstep))-1
    %encodes block by block the input bits
    %block length is equal to 32400
    block = b_l(i * sstep + 1:i * sstep + sstep);
    enc_b_l(2 * i * sstep + 1:2 * i * sstep + 2 * sstep) = step(encoderLDPC, block);
end

% INTERLEAVING
interl_b_l = interl(enc_b_l);

% MAP 0 TO -1
interl_b_l = 2 * interl_b_l - 1;

% Generate the channel input response
[q_c, E_qc] = channel_impulse_response();

a = zeros(floor(length(interl_b_l)/2),1);
for i=1:2:(length(interl_b_l) - 1)
   a((i+1)/2) =  interl_b_l(i) + 1i * interl_b_l(i+1);
end

clear pn;

a_prime = upsample(a, 4);

% Filter through the channel
s_c = filter(q_c, 1, a_prime);

SNR_vector = [1.6:0.01:1.8];
Pbit_DFEenc = zeros(length(SNR_vector),1);

for snr_index = 1:length(SNR_vector)
    SNR = SNR_vector(snr_index);
% Add Gaussian Noise
snrlin = 10^(SNR/10);
sigma_w = sigma_a * E_qc / snrlin;
w = wgn(length(s_c), 1, 10 * log10(sigma_w), 'complex');
rcv_bits = s_c + w;

% Reciver structure
g_m = conj(flipud(q_c));

% Calculate the h impulse response
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

Jmin_lin = 10^(Jmin/10);
noise_var = (Jmin_lin-sigma_a*abs(1-max(psi))^2)/(abs(max(psi))^2);
% Compute Log Likelihood Ratio
llr = zeros(2*length(y_k),1);
llr(1:2:end, 1) = -2*real(y_k)/(noise_var/2);
llr(2:2:end, 1) = -2*imag(y_k)/(noise_var/2);
new_length = floor(length(llr) / 64800) * 64800;
llr = llr(1:new_length, 1);

% Decode the bits
llr = deinterleaver(llr); % Deinterleave the loglikelihood ratio first

decoderLDPC = comm.LDPCDecoder;

dstep = 2 * sstep;

tic
for i = 0:(floor(length(llr)/dstep)) - 1
    %decodes block by block the input bits
    %block length is equal to 64800
    block = llr(i * dstep + 1:i * dstep + dstep);
    dec_b_l(i * dstep / 2 + 1:i * dstep / 2 + dstep / 2) = step(decoderLDPC, block.');
end
toc

[Pbit_DFEenc(snr_index), errors] = BER(dec_b_l, b_l(1:length(dec_b_l)));

end


