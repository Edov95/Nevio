function [decisions] = equalization_DFE(x, c, b, D)
%EQUALIZATION for DFE
M2 = length(b);
y = conv(x,c);
y = y(1:length(x)+D);
detected = zeros(length(x) + D, 1); 
for k=0:length(y)-1
     if (k <= M2)
        a_past = [flipud(detected(1:k)); zeros(M2 - k, 1)];
    else
        a_past = flipud(detected(k - M2 + 1: k));
    end
detected(k + 1) = threshold_detector(y(k + 1) + b.' * a_past);
end
%scatterplot(y)
decisions = detected(D + 1:end);
end