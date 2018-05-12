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

Hd = dfilt.dffir(g_AA);

%REMEMBER TO CHANGE N1 AND N2 WHEN CHANGING h
N1 = 7;
N2 = 9;

M1 = 5;
D = 1;
M2 = N2 + M1 - 1 - D;

for i=1:length(SNR_dB)
    
r_r(:,i) = filter(g_AA , 1, r_c(:,i));

s_r=filter(g_AA, 1, s_c);

qg_up = conv(q_c, g_AA);

t0_bar = find(qg_up==max(qg_up));
x(:,i) = downsample(r_r(t0_bar:end,i), 2);

x_NN=downsample(s_r(t0_bar:end), 2);

%scatterplot(x_NN)
h = downsample(qg_up,2);

h = h.';
r_gAA = xcorr(g_AA)';

N0(i) = (sigma_a * E_qc)/(4*SNR_lin(i));
r_w(:,i) = N0(i) * downsample(r_gAA, 2);

c(:,i)= WienerC_frac(h, r_w, sigma_a, M1, M2, D, N1, N2);

psi(:,i) = conv(c(:,i), h);

b(:,i) = [-psi(find(psi==max(psi))+1:end,i); 0]; 

%figure, stem(b), title('b'), xlabel('nT')
%scatterplot(x_NN)

% decisions = equalization_DFE(x(:,i), c(:,i), b(:,i), D);
% decisions = downsample(decisions(2:end),2);

y_up = filter(c(:,i),1,x(:,i));
y = downsample(y_up,2);
%y = y(1:length(a)+D);
detected = zeros(length(y), 1); 
for k=0:length(y)-1
     if (k <= M2)
        a_past = [flipud(detected(1:k)); zeros(M2 - k, 1)];
    else
        a_past = flipud(detected(k-M2+1:k));
    end
detected(k + 1) = threshold_detector(y(k + 1) + b(:,i).'*a_past);
end

%detection
[Pe_d(i), errors(i)] = SER(a(1:length(detected)), detected);

end

save('Pe_d.mat','Pe_d')


%% plots

figure, stem(g_AA), title('g_AA'), xlabel('nT/4')
figure, stem(r_c(1:100,3)), title('r_c'), xlabel('nT/4')
figure, stem(r_r(1:100,3)), title('r_r'), xlabel('nT/4')
figure, stem(s_r(1:100)), title('s_r'), xlabel('nT/4')
figure, stem(qg_up), title('convolution of g_AA and q_c'), xlabel('nT/4')
figure, stem(x(1:100,3)), title('x'), xlabel('nT/2')
figure, stem(x_NN(1:100)), title('x without noise'), xlabel('nT/2')
figure, stem(h), title('h'), xlabel('nT/2')
figure, stem(r_gAA), title('r_g'), xlabel('nT/2')
figure, stem(r_w(:,3)), title('r_g'), xlabel('nT/2')
figure, stem(c(:,3)), title('c'), xlabel('nT/2')
figure, stem(psi(:,3)), title('psi'), xlabel('nT/2')
