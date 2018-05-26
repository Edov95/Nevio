function [Pbit, count_errors] = BER(sent, detected)
% Computes the symbol-error rate, it accepts QPSK symbols
count_errors = 0;
for i=1:length(sent)
    if sent(i) ~= detected(i)
        count_errors = count_errors + 1;
    end
end
Pbit = count_errors/length(sent);
end

