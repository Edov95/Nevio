clc; clear all; close all;
format long g
%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");
Pe_LE = zeros(length(SNR_dB),1);
errors = zeros(length(SNR_dB),1);
r_r = zeros(length(s_c), length(SNR_dB));

%% Receiver filter

% Match filter
g_m = conj(flipud(q_c));

% Compute the h impulse response
h = conv(q_c, g_m);
h = downsample(h,4);
%h = h(h ~= 0);

for i=1:length(SNR_dB)
    r_r(:,i) = filter(g_m, 1, r_c(:,i));
end
% For debugging purpose
s_r = filter(g_m, 1, s_c);

%% Sampling
%t_0 equal to the peak of h
t_0_bar = length(g_m);
x_no_noise = downsample(s_r(t_0_bar:end), 4);

x = zeros(length(x_no_noise), length(SNR_dB));
for i=1:length(SNR_dB)
    x(:,i) = downsample(r_r(t_0_bar:end, i), 4);
end

%scatterplot(x)
%% Filtering thorugh C and equalization

r_gm = xcorr(g_m);
% r_w = N0 .* downsample(r_gm, 4);
for i=1:length(SNR_dB)
    r_w_up(:,i)= N0(i) * r_gm;
    r_w(:,i) = downsample(r_w_up(:,i), 4);
end

D = 2;
M1 = 5;
%M1 = 5; D = 4;

c =zeros(M1, length(SNR_dB));
for i=1:length(SNR_dB)
    
    c(:,i) = WienerC_LE(h, r_w(:,i), sigma_a, M1, D);
    
    psi(:,i) = conv(c(:,i), h);
    %psi(:,i) = psi(:,i)/max(psi(:,i));
        
    decisions = equalization_LE(x(:,i), c(:,i), D, max(psi(:,i)));
    
    [Pe_LE(i), errors(i)] = SER(a(1:length(decisions)), decisions);
end

%save('P_e_LE.mat','Pe_LE')

%% plots
if plot_figure == true
    
    [Q_c, f] = freqz(q_c_num, q_c_denom, 'whole');
%     figure, plot(real(a(1:50))), title('a'), ylim([-1.5 1.5])
%     figure, plot(real(a_prime(1:50))), title('a_pr'),ylim([-1.5 1.5])
%     figure, plot(real(s_c(1:50))), title('s_c'),ylim([-1.5 1.5])
%     figure, plot(real(s_r(1:50))), title('s_r'), ylim([-1.5 1.5])
%     figure, plot(real(r_c(1:50,3))), title('r_c'),ylim([-3 3])
%     figure, plot(real(x(1:50,3))), title('x'),ylim([-3 3])
    
    figure, stem(h)
    title('h_i'), xlabel('nT')
    
    figure, stem([0:length(q_c)-1], q_c), xlabel('nT/4'), title('q_c')
    figure, stem(g_m), xlabel('nT/4'), title('g_M')
    
    figure
    plot(f/(0.5*pi), 10*log10(abs(Q_c))), xlim([0 2])
    title('Frequency response Q_c')
    xlabel('Normalized frequency, T=1')
    ylabel('Q_c [dB]')
    
    figure, stem([-4:8], abs(psi(:,3))), xlabel('nT'), title('|\Psi|, D=2, M1=5')
    figure, stem([0:length(c(:,3))-1], abs(c(:,3))), xlabel('nT'), title('|c|')
end



