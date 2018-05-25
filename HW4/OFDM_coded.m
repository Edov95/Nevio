 function [Pbit dec_b_l] = OFDM_coded(a, b_l, Npx, SNRlin)

% pad the last symbols with -1-1i to have an integer multiple of 512
M = 512; % number of subchannels
sigma_a = 2;
a = [a; ones(M - mod(length(a), M), 1) * (-1-1i)];

a_mat = reshape(a, M, []);

A_no_pr = ifft(a_mat);

A = [A_no_pr(M - Npx + 1:M,:); A_no_pr];

s_n = reshape(A, [], 1);

% only to try with ideal channel
% sigma_w_OFDM = ( (sigma_a/M))/ SNRlin;
% w = wgn(length(s_n), 1, 10*log10(sigma_w_OFDM), 'complex');
% x = s_n + w;


%channel contruction
ro = 0.0625;
span = 30;
sps = 2;
g_rcos = rcosdesign(ro, span, sps, 'sqrt');
s_up = upsample(s_n,4);

s_up_rcos = filter(g_rcos, 1, s_up);
%s_up_rcos = s_up_rcos(length(g_rcos):end);

q_c = channel_impulse_response();

s_c = filter(q_c, 1, s_up_rcos);

Eimp = sum(conv(g_rcos,q_c).^2);

sigma_w_OFDM = (sigma_a * Eimp)/ (M * SNRlin);
w = wgn(length(s_c), 1, 10*log10(sigma_w_OFDM), 'complex');
r_c = s_c + w;
% r_c = s_c;

q_r_up = conv(conv(g_rcos,q_c), g_rcos);
q_r_up = q_r_up(find(abs(q_r_up)>=(max(q_r_up)*10^-2)));
q_r = downsample(q_r_up(1:end),4);
% t0_bar = find(q_r_up == max(q_r_up));
 t0_bar = 17;
x = filter(g_rcos, 1, r_c);
x = downsample(x(t0_bar:end), 4);

K_i = fft(q_r, 512);
K_i = K_i(:);

x = x(1: end - mod(length(x), M+Npx));

r_matrix = reshape(x, M+Npx, []);
r_matrix = r_matrix(Npx + 1:end, :);

K_i_inv = K_i.^(-1);

x_matrix = fft(r_matrix);

y_matrix = x_matrix .* K_i_inv;

sigma_i = 0.5*sigma_w_OFDM * M * abs(K_i_inv).^2;

llr_real = -2 * real(y_matrix) .* (sigma_i.^(-1));
llr_imag = -2 * imag(y_matrix) .* (sigma_i.^(-1));
llr_real_ar = reshape(llr_real, [], 1);
llr_imag_ar = reshape(llr_imag, [], 1);
llr = zeros(length(llr_real_ar) + length(llr_imag_ar), 1);
llr(1:2:end) = llr_real_ar;
llr(2:2:end) = llr_imag_ar;

% to try with ideal channel
% y = reshape(x_matrix, [], 1);
% llr = zeros(2*length(y),1);
% sigma_i = 0.5*sigma_w_OFDM*M;
% llr_real = -2*times(real(y),(sigma_i.^(-1)));
% llr_imag = -2*times(imag(y),(sigma_i.^(-1)));
% llr_real_ar = reshape(llr_real, [], 1);
% llr_imag_ar = reshape(llr_imag, [], 1);
% llr(1:2:end) = llr_real_ar;
% llr(2:2:end) = llr_imag_ar;
% 
% llr = llr(1:end - mod(length(llr),32400));


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