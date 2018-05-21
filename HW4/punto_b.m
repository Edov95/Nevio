clc;
clear all;
close all;
format long g
%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");
Pe_DFE = zeros(length(SNR_dB),1);
errors = zeros(length(SNR_dB),1);
r_r = zeros(length(s_c), length(SNR_dB));

%% Receiver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter
g_m = conj(flipud(q_c));

% Calculate the h impulse response
h = conv(q_c, g_m);
h = downsample(h,4);
%h = h(h ~= 0);

N1 = floor(length(h)/2);
N2 = N1;

for i=1:length(SNR_dB)
    r_r(:,i) = filter(g_m, 1, r_c(:,i));
end

% For debuggig purpose
s_r = filter(g_m, 1, s_c);

%% Sampling

t_0_bar = length(g_m);
x_no_noise = downsample(s_r(t_0_bar:end), 4);
x = zeros(length(x_no_noise), length(SNR_dB));
for i=1:length(SNR_dB)
    x(:,i) = downsample(r_r(t_0_bar:end, i), 4);
end

%% Filtering through C and equalization

r_gm = xcorr(g_m);
% r_w = N0 .* downsample(r_gm, 4);
for i=1:length(SNR_dB)
    r_w_up(:,i)= N0(i) * r_gm;
    r_w(:,i) = downsample(r_w_up(:,i), 4);
end

% M1_span = [2:20];
% D_span = [2:20];
% 
% % M1_span = 4;
% % D_span = 2;
% 
% Jvec = zeros(19);
% for k=1:length(M1_span)
%     for l=1:length(D_span)
%         M1 = M1_span(k);
%         D = D_span(l);
%         M2 = N2 + M1 - 1 - D;
%         [c, Jmin] = WienerC_DFE(h, r_w, sigma_a, M1, M2, D);
%         Jvec(k,l) = Jmin;
%     end
% end
% 
% for i=1:length(D_span)
%    figure,
%    plot(2:20, Jvec(:,i))
% end

% psi = conv(c, h);
% psi = psi/max(psi);
% 
% b = - psi(end - M2 + 1:end);
% 
% for i=1:length(SNR_dB)
%     decisions = equalization_DFE(x(:,i), c, b, M1, M2, D);
%     
%     [Pe(i), errors(i)] = SER(a(1:length(decisions)), decisions);
% end

% M1 = 5;
% D = 0;
M1 = 5; D = 4;
M2 = N2 + M1 - 1 - D;

c =zeros(M1, length(SNR_dB));
b = zeros(M2,1);
for i=1:length(SNR_dB)
    
    c(:,i) = WienerC_DFE(h, r_w(:,i), sigma_a, M1, M2, D);
    
    psi(:,i) = conv(c(:,i), h);
    %psi(:,i) = psi(:,i)/max(psi(:,i));
    b(:,i) = -psi(find(psi==max(psi))+1:end,i); 
    decisions = equalization_DFE(x(:,i), c(:,i), b(:,i), D);
    
    [Pe_DFE(i), errors(i)] = SER(a(1:length(decisions)), decisions);
end
%save('P_e_DFE.mat','Pe_DFE')

%% plots
if plot_figure == true
    
    [Q_c, f] = freqz(q_c_num, q_c_denom, 'whole');
    
    %figure, stem(h)
    %title('h_i'), xlabel('nT')
    
    %figure, stem(q_c), xlabel('nT/4'), title('q_c')
    figure, stem([0:length(g_m)-1],g_m), xlabel('nT/4'), title('g_M')
    
    figure
    plot(f/(2*pi), 10*log10(abs(Q_c))), xlim([0 0.5])
    title('Frequency response Q_c')
    
    figure, stem([-4:8],abs(psi(:,3))), xlabel('nT'), ...
        title('|\Psi|, D=4, M1=5')
    figure, stem([0:length(c(:,3))-1], abs(c(:,3))), xlabel('nT'), ...
        title('|c|'), xlim([0 6])
    figure, stem([0:length(b(:,3))-1], abs(b(:,3))), xlabel('nT'), ...
        title('|b|'), xlim([-1 6])
end