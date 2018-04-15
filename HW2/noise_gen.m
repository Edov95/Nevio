clc; close all; clear global; clearvars;
%generates white noise with variance -8dB, 1 million samples 
sigdB=-8;
sigmaw=10^(sigdB/10);
w = wgn(1000000,1,sigdB,'real'); 
save('Noise','w')