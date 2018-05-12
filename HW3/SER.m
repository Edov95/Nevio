function [Pe, count_err] = SER(sent, detected)
% Computes the symbol-error rate, it accepts QPSK symbols
count_err = 0;
for i=1:length(sent)
    if sent(i) ~= detected(i)
        count_err = count_err + 1;
    end
end
Pe = count_err/length(sent);
end

