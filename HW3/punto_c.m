 clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

select = 3;

%% AA filter

Fpass = 0.45;            % Passband Frequency
Fstop = 0.55;            % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.01;            % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop], [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
g_AA  = firpm(N, Fo, Ao, W, {dens});
[Hd f1]= freqz(g_AA,1);

figure, plot(f1/(pi),20*log10(abs(Hd))), xlim([0 1]),
title('|G_{AA}|')
ylabel('|G_{AA}| [dB]')
xlabel('n*2/T')
grid on;

r_r = filter(g_AA , 1, r_c(:,select));
s_r = filter(g_AA, 1, s_c);

figure, stem(s_r(1:100)), title('s_r'), xlabel('nT/4')
figure, stem(r_r(1:100)), title('r_r'), xlabel('nT/4')

qg_up = conv(q_c, g_AA);
qg_up = qg_up.';
%freqz(qg_up, 1,'whole');
figure, stem(qg_up), title('convolution of g_AA and q_c'), xlabel('nT/4')

%% Timing phase and decimation

t0_bar = find(qg_up == max(qg_up));
x_prime = downsample(r_r(t0_bar:end), 2);
x_NN_prime = downsample(s_r(t0_bar:end), 2);

figure, stem(x_NN_prime(1:100)), title('xprime without noise'), xlabel('nT/2')
figure, stem(x_prime(1:100)), title('xprime'), xlabel('nT/2')

qg = downsample(qg_up(1:end), 2);

g_m = conj(flipud(qg));
[Hgm f2] =  freqz(g_m,1,'whole');
figure, plot(f2/(2*pi),20*log10(abs(Hgm))), xlim([0 1]),
title('|G_M|')
ylabel('|G_M| [dB]')
xlabel('n*2/T')
grid on;

figure, stem(g_m), title('g_m'), xlabel('nT/2')

x = filter(g_m, 1, x_prime);
x = x(13:end);
figure, stem(x(1:100)), title('x'), xlabel('nT/2')

x_NN = filter(g_m, 1, x_NN_prime);

h = conv(qg, g_m);
h = h(h ~= 0);

%scatterplot(x_NN)
figure, stem(h), title('h'), xlabel('nT/2')
figure, stem(x_NN(1:100)), title('x without noise'), xlabel('nT/2')

%% Equalization and symbol detection

r_g = xcorr(conv(g_AA, flipud(qg_up)));
N0 = (sigma_a * E_qc) / (4 * SNR_lin(select));
r_w = N0 * downsample(r_g, 2);

figure, stem(r_w), title('r_w'), xlabel('nT/2')
figure, stem(r_g), title('r_g'), xlabel('nT/2')

N1 = floor(length(h)/2);
N2 = N1;

M1 = 9;
D = 4;
M2 = N2 + M1 - 1 - D;

[c, Jmin] = WienerC_frac(h, r_w, sigma_a, M1, M2, D, N1, N2);
psi = conv(h,c);

figure, stem([0:length(c)-1], abs(c)), title('|c|'), xlabel('nT/2')
xlim([0 length(c)])
figure, stem([-23:23],abs(psi)), title('|\psi|, M_1=9, D=4'), xlabel('nT/2')

psi_down = downsample(psi(2:end),2); % The b filter acts at T
b = -psi_down(find(psi_down == max(psi_down)) + 1:end); 

figure, stem([0:length(b)-1],abs(b)), title('|b|'), xlabel('nT')
xlim([-1 length(b)-1])
decisions = equalization_pointC(x, c, b, D);

%detection
[Pe_c, errors] = SER(a(1:length(decisions)), decisions)