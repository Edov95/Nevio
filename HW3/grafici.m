clear all; close all; clc;

Pbit=[0.0134 0.0117 0.0101 0.0081 0.0069 0.0054 0.0040];
SNR=[8:14];
figure,
plot(SNR, 10*log10(Pbit))