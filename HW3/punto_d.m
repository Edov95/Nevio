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
x = downsample(r_r(t0_bar:end), 2);
figure, stem(x(1:100)), title('x'), xlabel('nT/2')
x_NN=downsample(s_r(t0_bar:end), 2);
figure, stem(x_NN(1:100)), title('x without noise'), xlabel('nT/2')

%scatterplot(x_NN)
h = downsample(qg_up,2);
figure, stem(h), title('h'), xlabel('nT/2')
h = h.';
r_gAA = xcorr(g_AA);
figure, stem(r_gAA), title('r_g'), xlabel('nT/2')
N0 = (sigma_a * E_qc)/(4*SNR_lin(3));
r_w = N0 * downsample(r_gAA, 2);
r_w = r_w.';
figure, stem(r_w), title('r_g'), xlabel('nT/2')

N1 = 7;
N2 = 9;

M1 = 8;
D = 2;
M2 = N2 + M1 - 1 - D;

[c, Jmin]= WienerC_frac(h, r_w, sigma_a, M1, M2, D, N1, N2);
figure, stem(c), title('c'), xlabel('nT/2')
psi = conv(c, h);
figure, stem(psi), title('psi'), xlabel('nT')
b = -psi(find(psi==max(psi))+1:end); 
figure, stem(b), title('b'), xlabel('nT')
decisions = equalization_DFE(x, c, b, D);
decisions = downsample(decisions(2:end),2);

%detection
[Pe_d, errors] = SER(a(1:end-4), decisions);


