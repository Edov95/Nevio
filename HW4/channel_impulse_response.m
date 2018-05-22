function [q_c, E_qc] = channel_impulse_response()
q_c_num   = [0 0 0 0 0 0.7424];
q_c_denom = [1 -0.67];

q_c = impz(q_c_num, q_c_denom);

% cut the impulse response when too small
q_c = [0; 0; 0; 0; 0; q_c(q_c >= max(q_c)*10^(-2) )]; 
E_qc = sum(q_c.^2);

end