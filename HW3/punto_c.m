clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% AA filter

Fpass = 0.35;             % Passband Frequency
Fstop = 0.55;             % Stopband Frequency
Dpass = 0.057501127785;   % Passband Ripple
Dstop = 0.0031622776602;  % Stopband Attenuation
dens  = 20;               % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop], [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
g_AA  = firpm(N, Fo, Ao, W, {dens});
figure, stem(g_AA), title('g_AA'), xlabel('nT/4')
Hd = dfilt.dffir(g_AA);

F0=2;
r_r = filter(g_AA , 1, r_c(:,3));
figure, stem(r_r(1:100)), title('r_r'), xlabel('nT/4')
s_r=filter(g_AA, 1, s_c);
figure, stem(s_r(1:100)), title('s_r'), xlabel('nT/4')
qg_up = conv(q_c, g_AA);
figure, stem(qg_up), title('convolution of g_AA and q_c'), xlabel('nT/4')
t0_bar = find(qg_up==max(qg_up));
x_prime = downsample(r_r(t0_bar:end), 2);
figure, stem(x_prime(1:100)), title('xprime'), xlabel('nT/2')
x_NN_prime=downsample(s_r(t0_bar:end), 2);
figure, stem(x_NN_prime(1:100)), title('xprime without noise'), xlabel('nT/2')

g_m = flipud(qg_up);

x = filter(g_m,1,x_prime);
x = x(length(g_m):end);
figure, stem(x(1:100)), title('x'), xlabel('nT/2')
x_NN=filter(g_m,1,x_NN_prime);
x = x(length(g_m):end);
figure, stem(x_NN(1:100)), title('x without noise'), xlabel('nT/2')
%scatterplot(x_NN)
h = downsample(conv(qg_up,g_m),2);
figure, stem(h), title('h'), xlabel('nT/2')
h = h.';
r_g = xcorr(conv(g_AA,g_m));
figure, stem(r_g), title('r_g'), xlabel('nT/2')
N0 = (sigma_a * E_qc)/(4*SNR_lin(3));
r_w = N0 * downsample(r_g, 2);
r_w = r_w.';
figure, stem(r_w), title('r_g'), xlabel('nT/2')

N1 = 14;
N2 = 18;

M1 = 9;
D = 1;
M2 = N2 + M1 - 1 - D;

[c, Jmin]= WienerC_frac(h, r_w, sigma_a, M1, M2, D, N1, N2);
figure, stem(c), title('c'), xlabel('nT/2')
psi = filter(c,1, h);
figure, stem(psi), title('psi'), xlabel('nT')
b = -psi(find(psi==max(psi))+1:end); 
figure, stem(b), title('b'), xlabel('nT')
decisions = equalization_DFE(x, c, b, D);
decisions = downsample(decisions(2:end),2);

%detection
[Pe_c, errors] = SER(a(1:length(decisions)), decisions);





