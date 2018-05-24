 function [Pbit dec_b_l] = OFDM(a, enc_b_l, b_l, Npx, SNRlin)

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
s_up = upsample(s_n,4);

g_rcos = rcosdesign(ro, span, sps, 'sqrt');

s_up_rcos = filter(g_rcos, 1, s_up);
%s_up_rcos = s_up_rcos(length(g_rcos):end);

q_c = channel_impulse_response();

s_c = filter(q_c, 1, s_up_rcos);

Eimp = sum(conv(g_rcos,q_c).^2);

sigma_w_OFDM = ( (sigma_a/M) * Eimp )/ SNRlin;
w = wgn(length(s_c), 1, 10*log10(sigma_w_OFDM), 'complex');
r_c = s_c + w;

rec_g_rcos = rcosdesign(ro, span, sps, 'sqrt');
%r_c = r_c(length(rec_g_rcos):end);
g_up = conv(conv(g_rcos,q_c), rec_g_rcos);
g_up = g_up(25:end-25);
t0_bar = find(g_up == max(g_up));
x = filter(rec_g_rcos, 1, r_c);
g = downsample(g_up(3:end),4);
x = downsample(x(t0_bar:end), 4);
G = fft(g, 512);
G = G(:);

x = x(1 : end - mod(length(x), M+Npx));
r_matrix = reshape(x, M+Npx, []);
r_matrix = r_matrix(Npx + 1:end, :);

G_inv = G.^(-1);

x_matrix = fft(r_matrix);
% y_matrix = bsxfun(@times, x_matrix, G_inv);
y_matrix = x_matrix.*G_inv;

sigma_i = 0.5*sigma_w_OFDM*M*abs(G_inv).^2;
% 
% llr_real = -2*bsxfun(@times, real(y_matrix), sigma_i.^(-1));
% llr_imag = -2*bsxfun(@times, imag(y_matrix), sigma_i.^(-1));
llr_real = -2*times(real(y_matrix),(sigma_i.^(-1)));
llr_imag = -2*times(imag(y_matrix),(sigma_i.^(-1)));
llr_real_ar = reshape(llr_real, [], 1);
llr_imag_ar = reshape(llr_imag, [], 1);
llr = zeros(numel(llr_real) + numel(llr_imag), 1);
llr(1:2:end) = llr_real_ar;
llr(2:2:end) = llr_imag_ar;

llr = llr(1:length(enc_b_l));
llr = deinterleaver(llr);

decoderLDPC = comm.LDPCDecoder;

dstep = 64800;

tic
for i = 0:(floor(length(llr)/dstep)) - 1
    block = llr(i * dstep + 1:i * dstep + dstep);
    dec_b_l(i * dstep / 2 + 1:i * dstep / 2 + dstep / 2) = step(decoderLDPC, block.');
end
toc

Pbit = BER(b_l, dec_b_l);
end