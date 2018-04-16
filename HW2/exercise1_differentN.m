clc; close all; clear global; clearvars;

%% COMPUTE r(k)
Lvect=[7 15 31 63 127];
N=20;
Nstart=2;
%additive noise
sigdB=-8;
sigmaw=10^(sigdB/10);

load('Noise.mat','w')
sw_collectLS=zeros(N,1);

for n=1:length(Lvect)
    
    L=Lvect(n);
    
    for Ncurrent=1:N
        
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
        h=h(1:Ncurrent);
        x_up=upsample(x,2);
        w1=w(1:length(x_up));
        %output of the system
        d_true=filter(1,[1 a1 a2],x_up)+w1;
        
        %% ESTIMATE OF h WITH THE CORRELATION METHOD
        %we approximate the filter h with an FIR filter so the taps of h_0, h_1
        %become the coefficients b_i of the frequency response
        
        [h0_corr, h1_corr, r0_corr, r1_corr] = corrEst(x, d_true, Ncurrent);
        
        %total estimated impulse response
        % h_corr=zeros(Ncurrent,1);
        % for i=1:length(h0_corr)
        %     h_corr(2*i-1)=h0_corr(i);
        % end
        % for i=1:length(h1_corr)
        %     h_corr(2*i)=h1_corr(i);
        % end
        % figure, stem(0:Ncurrent-1,h_corr), hold on,
        % stem(0:Ncurrent-1,h,'r*'), title('h_{analytic} vs h_{estimate-CORR}'), xlabel('nT_y'), ylim([-0.5 1.2]), xlim([-2 20])
        % legend('h_{est-CORR}','h_{analytic}')

        
        d_hatCORR=zeros(length(d_true),1);
        %P/S converter
        for i=1:2*L
            d_hatCORR(2*i-1)=r0_corr(i);
            d_hatCORR(2*i)=r1_corr(i);
        end
        %estimate of sigmaw
        delta_dCORR=d_true-d_hatCORR;
        Epsilon_minCORR=sum(delta_dCORR(L:2*L-1).^2);
        sw_hatCORR_dB=10*log10(Epsilon_minCORR/L);
        sw_collectCORR(Ncurrent)=sw_hatCORR_dB;
        
        %% LS
        %the receiver knows only x(k) and the output d_true
        
        [h0_ls, h1_ls, r0_ls, r1_ls] = LSest(x, d_true, Ncurrent);
        
        %total estimated impulse response
        % h_ls=zeros(Ncurrent,1);
        % for i=1:length(h0_ls)
        %     h_ls(2*i-1)=h0_ls(i);
        % end
        % for i=1:length(h1_ls)
        %     h_ls(2*i)=h1_ls(i);
        % end
        % figure, stem(0:Ncurrent-1, h_ls),title('h_{ls}'), hold on,
        % stem(0:Ncurrent-1,h,'r*'), title('h_{analytic} vs h_{estimate-LS}'), xlabel('nT_y'), ylim([-0.5 1.2]), xlim([-2 20])
        % legend('h_{est-LS}','h_{analytic}')

        
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
        
        sw_collectLS(Ncurrent)=sw_hatLS_dB;
        
        
    end
    
    SWcorr(:,n)=sw_collectCORR;
    SWls(:,n)=sw_collectLS;
end
SWcorr=SWcorr(2:end,:);
SWls=SWls(2:end,:);
save('swCORR.mat','SWcorr')
save('swLS.mat','SWls')