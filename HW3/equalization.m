function [decisions] = equalization(x, c, M1, M2, D)
%EQUALIZATION Summary of this function goes here
%   Detailed explanation goes here
%EQUALIZATION

% y = filter(c_opt, 1, x)/max(psi);
% scatterplot(y)

% %% Decision point
% 
% for k=1:length(y) - D
% a_hat(k) = threshold_detector(y(k+D));
% end

y = zeros(length(x) + D , 1); % output of ff filter
detected = zeros(length(x) + D, 1); % output of td

for k = 0:length(x) - 1 + D
    
    if (k < M1 - 1)
        xconv = [flipud(x(1:k+1)); zeros(M1 - k - 1, 1)];
        
    elseif k > length(x)-1 && k < length(x) - 1 + M1
        xconv = [zeros(k-length(x)+1, 1); flipud(x(end - M1 + 1 + k - ...
            length(x) + 1:end) ) ];
        
    elseif k >= length(x) - 1 + M1 % just in case D is greater than M1
        xconv = zeros(M1, 1);
        
    else
        xconv = flipud(x(k - M1 + 1 + 1:k + 1));
    end 

    
    if (k <= 0)
        a_old = [flipud(detected(1:k)); zeros(0 - k, 1)];
    else
        a_old = flipud(detected(k - 0 + 1:k));
    end

    y(k+1) = c.'*xconv;
    detected(k + 1) = threshold_detector(y(k + 1));
end

decisions = detected(D + 1:end);
end

