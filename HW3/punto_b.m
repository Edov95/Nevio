clc; clear all; close all;

%% Load common variable
if ~exist("common.mat", 'file')
    common;
end

load("common.mat");

%% Receiver filter

% Costruzione del filtro g_M
% Per l'esercizio a è un "semplice" matched filter
g_m = conj(flipud(q_c));

% Calculate the h impulse response
h = conv(q_c, g_m);
h = downsample(h,4);

N1 = floor(length(h)/2);
N2 = N1;

r_r = filter(g_m, 1, r_c(:,1));

% For debuggig pourpose
% s_r = filter(g_m, 1, s_c);

%% Sampling

t_0_bar = length(g_m);
r_cut = r_r(t_0_bar:end);

x = downsample(r_cut, 4);
scatterplot(x)

%% Filtering through C and equalization

r_gm = xcorr(g_m, g_m);
r_w = N0 .* r_gm;


% M1_span = [2:20];
% D_span = [2:20];

M1_span = 4;
D_span = 2;

Jvec = zeros(19);
for k=1:length(M1_span)
    for l=1:length(D_span)
        M1 = M1_span(k);
        D = D_span(l);
        M2 = N2 + M1 - 1 - D;
        [c, Jmin] = WienerC_DFE(h, r_w, sigma_a, M1, M2, D);
        Jvec(k,l) = Jmin;
    end
end

% for i=1:length(D_span)
%    figure,
%    plot(2:20, Jvec(:,i))
% end

psi = conv(c, h);

b = - psi(end-M2+1:end);

decisions = equalization_DFE(x, c, b, M1, M2, D);

[Pe, errors] = SER(a(1:length(decisions)), decisions);



