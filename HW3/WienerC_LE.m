%% WINER SOLUTION FOR THE FILTER c (L.E. CASE) + EQUALIZATION + DETECTION (T.D.)
%close all;
%parameters of h
N1 = floor(length(h)/2);
N2 = N1;
padding = 60;
hpad = padarray(h, padding);
%M1_span = [2:20];
M1_span = 4;
%D_span = [2:20];
D_span = 2;
r_gm =xcorr(g_m, g_m);
r_w = N0 * r_gm;
r_w_pad = padarray(r_w, padding);

Jmin = zeros(19, length(M1_span));
for n=1:length(M1_span)
    for m = 1:length(D_span )
        M1 = M1_span(n);
        D = D_span(m);
        p = zeros(M1 ,1);
        for i = 0 : M1-1
            p(i+1) = sigma_a * conj(hpad(N1+padding+1+D-i));
        end

        R = zeros(M1);
        for row = 0:(M1-1)
            for col = 0:(M1-1)
%                 temp = zeros(N1+N2+1, 1);
%                 for j = 0:N1+N2
%                     temp(j+1) = hpad(j+padding+1) * conj(hpad(j+padding+1-(row-col)));   
%                 end
%                 fsum=sum(temp);
%                 R(row+1, col+1) = sigma_a * fsum + r_w_pad(padding+1+row-col+(floor(length(r_w)/2))); 
             fsum = (hpad((padding+1):(N1+N2+padding+1))).' * conj(hpad((padding+1-(row-col)):(N1+N2+padding+1-(row-col))));
            R(row+1, col+1) = sigma_a * fsum + r_w_pad(padding+1+row-col+(floor(length(r_w)/2))); 
           end
        end
        %solves ill conditioning
        % R = R + 0.01*eye(M1);
        c_opt = R \ p;

        temp2 = zeros(M1, 1);
        for l = 0:M1-1
            temp2(l+1) = c_opt(l+1) * hpad(N1+padding+1+D-l); 
        end
        ssum = sum(temp2);
        Jmin(m, n) = 10*log10(sigma_a * (1 - ssum));
    end 
end

for i = 1:length(D_span)
   figure, plot(M1_span, Jmin(i,:)), xlabel('value of M1'), ylabel('Jmin') 
end

%c_opt = c_opt/max(c_opt);
% figure, plot(M1_span, Jmin), xlabel('value of M1'), ylabel('Jmin')
psi = conv(h, c_opt);
figure, stem(psi)
%figure, plot3(2:20, M1_span, Jmin)

%%
%EQUALIZATION

% y = filter(c_opt, 1, x)/max(psi);
% scatterplot(y)

% %% Decision point
% 
% for k=1:length(y) - D
% a_hat(k) = threshold_detector(y(k+D));
% end
x=x.';
y = zeros(length(x) + D , 1); % output of ff filter
detected = zeros(length(x) + D, 1); % output of td
for k = 0:length(x) - 1 + D
    if (k < M1 - 1)
        xconv = [flipud(x(1:k+1)); zeros(M1 - k - 1, 1)];
    elseif k > length(x)-1 && k < length(x) - 1 + M1
        xconv = [zeros(k-length(x)+1, 1); flipud(x(end - M1 + 1 + k - length(x) + 1:end))];
    elseif k >= length(x) - 1 + M1 % just in case D is greater than M1
        xconv = zeros(M1, 1);
    else
        xconv = flipud(x(k-M1+1 + 1:k + 1));
    end
    
    if (k <= 0)
        a_old = [flipud(detected(1:k)); zeros(0 - k, 1)];
    else
        a_old = flipud(detected(k-0+1:k));
    end
    
    y(k+1) = c_opt.'*xconv;
    detected(k+1) = threshold_detector(y(k+1));
    
end
scatterplot(y);
decisions = detected(D+1:end);
[Pe errors] = SER(a(1:length(decisions)), decisions);
%[pbit, errors] = BER(a(1:length(decisions)), decisions);