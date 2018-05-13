function [Pe, count_errors] = SER(sent, detected)
% Computes the symbol-error rate, it accepts QPSK symbols
% count_err = 0;
% for i=1:length(sent)
%     if sent(i) ~= detected(i)
%         count_err = count_err + 1;
%     end
% end
count_errors = sum((sent-detected)~=0);
Pe = count_errors/length(sent);
end

