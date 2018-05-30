clear all; close all; clc;
format long g;

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

a = zeros(floor(length(interl_b_l)/2),1);
for i=1:2:(length(interl_b_l) - 1)
   a((i+1)/2) =  interl_b_l(i) + 1i * interl_b_l(i+1);
end

clear pn;

SNR_vector = [0.4:0.05:1];
Pbit_AWGN = zeros(length(SNR_vector),1);

for snr_index = 1:length(SNR_vector)
SNR = SNR_vector(snr_index);
% Add Gaussian Noise
snrlin = 10^(SNR/10);
sigma_w = sigma_a * E_qc / snrlin;
w = wgn(length(a), 1, 10 * log10(sigma_w), 'complex');
y_k = a + w;

% Compute Log Likelihood Ratio

llr = zeros(2*length(y_k),1);
llr(1:2:end, 1) = -2*real(y_k)/(sigma_w/2);
llr(2:2:end, 1) = -2*imag(y_k)/(sigma_w/2);
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

[Pbit_AWGN(snr_index), errors] = BER(dec_b_l, b_l(1:length(dec_b_l)));
end