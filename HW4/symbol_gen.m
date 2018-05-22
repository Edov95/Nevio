clear all; close all; clc;

%% THIS SCRIPT GENERATES THE SYMBOLS BY USING A PN SEQUENCE 
%% AND APPLYING LDP ENCODING AND INTERLEAVING

b_l = [PN(20); PN(20)];
sstep = 32400;
num_bits = floor(length(b_l) / sstep) * sstep;
b_l = b_l(1:num_bits);

sigma_a = 2;

%% ENCODE VIA LDPC

%create LDPC encoder with the dafault matrix (rate=2)
encoderLDPC = comm.LDPCEncoder;
enc_b_l = zeros(2*length(b_l),1);
for i = 0:(ceil(length(b_l)/sstep))-1
    %encodes block by block the input bits
    %block length is equal to 32400
    block = b_l(i * sstep + 1:i * sstep + sstep);
    enc_b_l(2 * i * sstep + 1:2 * i * sstep + 2 * sstep) = step(encoderLDPC, block);
end

%% INTERLEAVING

interl_b_l = interl(enc_b_l);

%% MAP 0 TO -1

interl_b_l = 2 * interl_b_l - 1;

%% BITMAP

a = BMAP(interl_b_l);

save('generated_symbols.mat','a')