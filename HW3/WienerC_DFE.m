function [c_opt, Jmin] = WienerC_DFE(h, r_w, sigma_a, M1, M2, D)
    %% WINER SOLUTION FOR THE FILTER c (L.E. + D.F.E. CASE)

    N1 = floor(length(h)/2);
    N2 = N1;
    padding = 60;
    hpad = padarray(h, padding);

    % Padding the noise correlation 
    r_w_pad = padarray(r_w, padding);
    
    p  = zeros(M1 ,1);

    for i = 0 : M1-1
        p(i + 1) = sigma_a * conj(hpad(N1 + padding + 1 + D - i));
    end

    R = zeros(M1);
    for row = 0:(M1-1)
        for col = 0:(M1-1)
            
            fsum = (hpad((padding + 1):(N1 + N2 + padding + 1))).' ...
                * conj(hpad((padding + 1 - (row - col)):( N1 + N2 + ...
                padding + 1 - (row - col))));
            
            R(row + 1, col + 1) = sigma_a * fsum + r_w_pad(padding + 1 ...
                + row - col + (floor( length(r_w) / 2 ))); 
       end
    end
    
    c_opt = R \ p;

    temp2 = zeros(M1, 1);
    
    for l = 0:M1-1
        temp2(l + 1) = c_opt(l + 1) * hpad(N1 + padding + 1 + D - l); 
    end 
    
    ssum = sum(temp2);
    Jmin = 10*log10(sigma_a * (1 - ssum));
end