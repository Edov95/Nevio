clear all; close all; clc;
set(0,'defaultTextInterpreter','latex')
ro = 0.0625;
span = 30;
sps = 4;
g_rcos = rcosdesign(ro, span, sps, 'sqrt');

[H f] = freqz(g_rcos, 1);
figure, plot(f/(0.5*pi), 10*log10(abs(H)))
xlim([0 1])
ylim([-20 7])
xlabel('$f/T_c$')
ylabel('$|G_{\sqrt{rcos}|} [dB]$')
figure, stem(g_rcos)
figure, stem(conv(g_rcos,g_rcos))

gdown = downsample(conv(g_rcos,g_rcos),4);
figure, stem(gdown)
[Hdown fd] = freqz(gdown, 1, 'whole');
figure, plot(fd/pi, abs(Hdown)), ylim([0 3])