clc; close all; clear global; clearvars;
%generates white noise with variance -8dB, 1 million samples 
sigdB=-8;
sighalf=0.5*10^(-sigdB/10);
sigdBhalf=10*log10(sighalf);
sigmaw=10^(sigdB/10);
w = wgn(10000,1,sigdB,'real'); 
save('Noise_try','w')