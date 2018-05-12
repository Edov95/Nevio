function [c_opt, Jmin] = WienerC_LE(h, r_w, sigma_a, M1, D)
%calls Wiener for DFE passing M2=0
[c_opt, Jmin] = WienerC_DFE(h, r_w, sigma_a, M1, 0, D);
end