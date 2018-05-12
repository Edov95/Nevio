function [decisions] = equalization_LE(x, c, D, norm_factor)
%EQUALIZATION+detection for LE 

y = conv(x,c);
y = y(1:length(x)+D);
y_tilde = y./norm_factor;
detected = zeros(length(x) + D, 1); 
for k=0:length(y)-1
detected(k + 1) = threshold_detector(y_tilde(k + 1));
end
%scatterplot(y_tilde);
decisions = detected(D + 1:end);
end