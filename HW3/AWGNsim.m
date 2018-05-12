%% AWGN BOUND SIMULATION

Pe_AWGNsim = zeros(length(SNR_dB), 1);
for i=1:length(SNR_dB)
    
    a_dist(:,i) = a + w(1:length(a), i);
    
    a_det = zeros(length(a), length(SNR_dB));
    for k=1:length(a)
        a_det(k,i) = threshold_detector(a_dist(k,i));
    end
    
    [Pe_AWGNsim(i), ~] = SER(a, a_det(:,i));
end

save('Pe_AWGNsim.mat','Pe_AWGNsim')