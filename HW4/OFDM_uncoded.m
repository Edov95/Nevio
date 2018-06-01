 function [Pbit b_l_hat] = OFDM_uncoded(a, b_l, Npx, t0_bar, SNRlin)

% pad the last symbols with -1-1i to have an integer multiple of 512
M = 512; % number of subchannels
sigma_a = 2;
a = [a; ones(M - mod(length(a), M), 1) * (-1-1i)];

a_mat = reshape(a, M, []);

%IFFT should be computed at sampling time Tblock=Tofdm*(M+Npx) according to
%the book
A_no_prefix = ifft(a_mat);
%A_no_pr = A_no_pr(1:512,:);

A = [A_no_prefix(M - Npx + 1:M,:); A_no_prefix];

s_n = reshape(A, [], 1);

%channel contruction
ro = 0.0625;
span = 30;
sps = 4;
g_rcos = rcosdesign(ro, span, sps, 'sqrt');
g_rcos = g_rcos(abs(g_rcos)>=(max(g_rcos)*10^-2));
s_up = upsample(s_n,4);

s_up_rcos = filter(g_rcos, 1, s_up);
%s_up_rcos = s_up_rcos(length(g_rcos):end);

q_c = channel_impulse_response();

s_c = filter(q_c, 1, s_up_rcos);
%s_c = s_c(length(q_c):end);

Eimp = sum(conv(g_rcos,q_c).^2);

sigma_w_OFDM = (sigma_a * Eimp)/ (M * SNRlin);
w = wgn(length(s_c), 1, 10*log10(sigma_w_OFDM), 'complex');
r_c = s_c + w;
% r_c = s_c;

gq = conv(g_rcos,q_c);
q_r_up = conv(gq, g_rcos);
q_r_up = q_r_up(abs(q_r_up)>=(max(q_r_up)*10^-3));
% t0_bar = find(q_r_up == max(q_r_up));

index = find(q_r_up==max(q_r_up));
rem = mod(index,4);
if rem==0
    start = 4;
else
    start = rem;
end
q_r = downsample(q_r_up(start:end),4);
q_r = q_r(abs(q_r)>=(max(q_r)*10^-3));

x = filter(g_rcos, 1, r_c);
x = downsample(x(t0_bar:end), 4);

K_i = fft(q_r, M);
K_i = K_i(:);

x = x(1: end - mod(length(x), M+Npx));

r_matrix = reshape(x, M+Npx, []);
r_matrix = r_matrix(Npx + 1:end, :);

K_i_inv = K_i.^(-1);

x_matrix = fft(r_matrix);

y_matrix = x_matrix .* K_i_inv;

y = reshape(y_matrix, 1, []);

dec_a_k = zeros(length(y),1);
for k=1:length(y)
    dec_a_k(k) = threshold_detector(y(k));
end
b_l_hat = IBMAP(dec_a_k);

[Pbit ~]= BER(b_l, b_l_hat(1:end));
 end