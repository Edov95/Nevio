clc; close all; clear global; clearvars;
%generates white noise with variance 1, 10 million samples
length_w = 10e6;
w = 1/sqrt(2).*randn(length_w, 1);
save('Noise','w')
