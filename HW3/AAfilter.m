function Hd = AAfilter
%AAFILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and DSP System Toolbox 9.5.
% Generated on: 14-May-2018 13:35:11

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are normalized to 1.

Fpass = 0.2;             % Passband Frequency
Fstop = 0.3;             % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.01;            % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop], [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
