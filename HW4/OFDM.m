function [x] = OFDM(a, Npx, t0_bar, SNRlin)
% works with already coded bits

% pad the last symbols with -1-1i to have an integer multiple of 512
M = 512; % number of subchannels
sigma_a = 2;
a = [a; ones(M - mod(length(a), M), 1) * (-1-1i)];

a_mat = reshape(a, M, []);

A_no_pr = ifft(a_mat);

A = [A_no_pr(M - Npx:M,:); A_no_pr];

s_n = reshape(A, [], 1);

%channel contruction
ro = 0.0625;
span = 12;
sps = 4;
s_n_up = upsample(s_n,4);

g_rcos = rcosdesign(ro, span, sps, 'sqrt');

s_up_rcos = filter(g_rcos, 1, s_up);
s_up_rcos = s_up_rcos(length(g_rcos):end);

q_c = channel_impulse_response();

s_c = filter(q_c, 1, s_up_rcos);

Eimp = sum(conv(g_rcos,q_c).^2);

sigma_w_OFDM = ( (sigma_a/M) * Eimp )/ SNRlin;
w = wgn(length(s_c), 1, 10*log10(sigma_w_OFDM), 'complex');
r_c = s_c + w;

rec_g_rcos = rcosdesign(ro, span, sps, 'sqrt');
r_c = r_c(length(rec_g_rcos):end);

x = filter(rec_g_rcos, 1, r_c);













end