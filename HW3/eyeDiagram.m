%% EYEDIAGRAM
% plots the eye diagram for all the possible values of t0: 0 1 2 3
%plots both real and imaginary parts
symb_per = 4;
transient = length(q_c) - 1;
t0 = [0 1 2 3];

for k=1:4
    
    s_r_eye = s_r(transient+1+t0(k):end);
    fin = 4 * floor(length(s_r_eye)/4);
    
    figure,
    for i=1:4:fin-4
        s_r_seq_I = real(s_r_eye(i:i + 4 ));
        s_r_seq_Q = imag(s_r_eye(i:i + 4 ));
        subplot(211)
        plot([0 0.25 0.5 0.75 1], s_r_seq_I, 'k'), hold on ,
        subplot(212)
        plot([0 0.25 0.5 0.75 1], s_r_seq_Q, 'k'), hold on ,
    end
    title(['t0 = ' int2str(t0(k))]);
end