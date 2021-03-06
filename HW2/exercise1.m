clc; close all; clear global; clearvars;

%% COMPUTE r(k)
L=31;
Ncurrent=9;

%additive noise
sigdB=-8;
sigmaw=10^(sigdB/10);

load('Noise_try.mat','w')


%PN sequence
x=[PN(L); PN(L)];
%map all zeros to -1
for i=1:length(x)
    if x(i)==0
        x(i)=-1;
    end
end

%filter polyphase components
a1=-0.9635;
a2=0.4642;
h=impz(1, [1 a1 a2]);

h_even=h(1:2:end);
h_odd=h(2:2:end);
%to seave the previous results using the same noise
wcut=w(1:2*length(x));
w_even=wcut(1:2:end);
w_odd=wcut(2:2:end);
r_even=filter(h_even,1,x)+w_even;
r_odd=filter(h_odd,1,x)+w_odd;
%total output with a P/S converter
d_true=zeros(length(x),1);
for i=1:length(r_even)
    d_true(2*i-1)=r_even(i);
    d_true(2*i)=r_odd(i);
end

%% ESTIMATE OF h WITH THE CORRELATION METHOD
%we approximate the filter h with an FIR filter so the taps of h_0, h_1
%become the coefficients b_i of the frequency response

[h0_corr, h1_corr, r0_corr, r1_corr] = corrEst(x, r_even, r_odd, Ncurrent);

%total estimated impulse response
h_corr=zeros(Ncurrent,1);
for i=1:length(h0_corr)
    h_corr(2*i-1)=h0_corr(i);
end
for i=1:length(h1_corr)
    h_corr(2*i)=h1_corr(i);
end
figure, stem(0:Ncurrent-1,h_corr), hold on,
stem(0:length(h)-1,h,'r*'), ...
    title(['Correlation method N=' int2str(Ncurrent),', ...
           L=' int2str(L)]), xlabel('nT_y'), ... 
           ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-CORR}','h_{analytic}')

d_hatCORR=zeros(length(x),1);
%P/S converter
for i=1:2*L
    d_hatCORR(2*i-1)=r0_corr(i);
    d_hatCORR(2*i)=r1_corr(i); 
end
%estimate of sigmaw
delta_dCORR=d_true-d_hatCORR;
Epsilon_minCORR=sum(delta_dCORR(L:2*L-1).^2);
sw_hatCORR_dB=10*log10(Epsilon_minCORR/L);
%sw_hatCORR_dB=10*log10((var(h0_corr)+var(h1_corr))/(2*L));


%% LS
%the receiver knows only x(k) and the output d_true

[h0_ls, h1_ls, r0_ls, r1_ls] = LSest(x, r_even, r_odd, Ncurrent);

%total estimated impulse response
h_ls=zeros(Ncurrent,1);
for i=1:length(h0_ls)
    h_ls(2*i-1)=h0_ls(i);
end
for i=1:length(h1_ls)
    h_ls(2*i)=h1_ls(i);
end
figure, stem(0:Ncurrent-1, h_ls), hold on,
stem(0:length(h)-1,h,'r*'), title(['LS method N=' int2str(Ncurrent) ', L=' int2str(L)]), xlabel('nT_y'), ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-LS}','h_{analytic}')

%estimate of sigmaw
d_hatLS=zeros(length(d_true),1);
%P/S converter
for i=1:2*L
    d_hatLS(2*i-1)=r0_ls(i);
    d_hatLS(2*i)=r1_ls(i); 
end
delta_dLS=d_true-d_hatLS;
Epsilon_minLS=sum(delta_dLS(L:2*L-1).^2);
sw_hatLS_dB=10*log10(Epsilon_minLS/L);

% Emin=(1/2)*(Emin0+Emin1);
% sw_hatLS_dB=10*log10(Emin/L);
