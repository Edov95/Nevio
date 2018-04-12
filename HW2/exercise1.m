clc; close all; clear global; clearvars;

%% COMPUTE r(k)
L=127;
Nlim=20;

%additive noise
sigdB=-8;
sigmaw=10^(sigdB/10);
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
%figure, stem(0:19,h), title('h'), xlabel('n'), ylim([-0.3 1.2]), xlim([-2 20])

%h_0, even samples
h_0=zeros(Nlim/2,1);
for k=1:(Nlim/2)
    h_0(k)=h(2*k-1); %it seems they re the odd samples but matlab starts from 1 so they are the even ones
end

%h_1, odd samples
h_1=zeros(Nlim/2,1);
for k=1:Nlim/2
    h_1(k)=h(2*k); %it seems they re the even samples but matlab starts from 1 so they are the odd ones
end

%% ESTIMATE OF h WITH THE CORRELATION METHOD

r_0=filter(h_0,1, x);
r_1=filter(h_1,1, x);

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
figure, stem(0:19,h_est), hold on,
stem(0:19,h,'r*'), title('h_{analytic} vs h_{estimate-CORR}'), xlabel('n'), ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-CORR}','h_{analytic}')

%% LS
d0=r_0;
d1=r_1;

h0_ls=LS(x, d0, L);
h1_ls=LS(x, d1, L);

h_ls=zeros(Nlim,1);
for i=1:Nlim
    if (i<=L)
    h_ls(2*i-1)=h0_ls(i);
    h_ls(2*i)=h1_ls(i);
    end
end
h_ls=h_ls(1:Nlim);
figure, stem(0:19, h_ls),title('h_{ls}'), hold on,
stem(0:19,h,'r*'), title('h_{analytic} vs h_{estimate-LS}'), xlabel('n'), ylim([-0.5 1.2]), xlim([-2 20])
legend('h_{est-LS}','h_{analytic}')

%estimate of sigmaw 