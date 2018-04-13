clc; close all; clear global; clearvars;

%% COMPUTE r(k)
L=63;
Nlim=5;

%additive noise
sigdB=-8;
sigmaw=10^(sigdB/10);
w=sigmaw*randn(2*L,1);
w_alt=sigmaw*randn(2*L,1);
w_0=sigmaw*randn(2*L,1);
w_1=sigmaw*randn(2*L,1);

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
h=h(1:Nlim);
%output of the system
d_true=filter(1,[1 a1 a2],x)+w;

%h_0, even samples
for k=1:(Nlim/2)
    h_0(k)=h(2*k-1); %it seems they re the odd samples but matlab starts from 1 so they are the even ones
end

%h_1, odd samples
for k=1:Nlim/2
    h_1(k)=h(2*k); %it seems they re the even samples but matlab starts from 1 so they are the odd ones
end

%% ESTIMATE OF h WITH THE CORRELATION METHOD
%we approximate the filter h with an FIR filter so the taps of h_0, h_1
%become the coefficients b_i of the frequency response
r_0=filter(h_0,1, x)+w_0;
r_1=filter(h_1,1, x)+w_1;

h0_est=r_dx(x, r_0);
h1_est=r_dx(x, r_1);

h_est=zeros(Nlim,1);
for i=1:Nlim
    if (i<=L)
    h_est(2*i-1)=h0_est(i);
    h_est(2*i)=h1_est(i);
    end
end
h_est=h_est(1:Nlim);
figure, stem(0:Nlim-1,h_est), hold on,
stem(0:Nlim-1,h,'r*'), title('h_{analytic} vs h_{estimate-CORR}'), xlabel('n'), ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-CORR}','h_{analytic}')

d_hatCORR=filter(h_est, 1, x)+w_alt;

delta_dCORR=d_true-d_hatCORR;
Epsilon_minCORR=sum(delta_dCORR(L:2*L-1).^2);
sw_hatCORR_dB=10*log10(Epsilon_minCORR/L);

%% LS
d0=r_0;
d1=r_1;

[h0_ls]=LS(x, d0, L);
[h1_ls]=LS(x, d1, L);

h_ls=zeros(Nlim,1);
for i=1:Nlim
    if (i<=L)
    h_ls(2*i-1)=h0_ls(i);
    h_ls(2*i)=h1_ls(i);
    end
end
h_ls=h_ls(1:Nlim);
figure, stem(0:Nlim-1, h_ls),title('h_{ls}'), hold on,
stem(0:Nlim-1,h,'r*'), title('h_{analytic} vs h_{estimate-LS}'), xlabel('n'), ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-LS}','h_{analytic}')

%estimate of sigmaw 
d_hatLS=filter(h_ls, 1, x)+w_alt;

delta_dLS=d_true-d_hatLS;
Epsilon_minLS=sum(delta_dLS(L:2*L-1).^2);
sw_hatLS_dB=10*log10(Epsilon_minLS/L);

