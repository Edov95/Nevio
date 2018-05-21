function [b_i] = IBMAP(a_k)
    % Check if the input array has even length
    L = length(a_k);
    
    b_i = zeros(2*L,1);
    
    % Map each couple of values to the corresponding symbol
    % The real part gives the bit 
    for k = 1:2:length(b_i)-1
        symbol = a_k((k+1)/2);
        if (real(symbol) == 1)
           b2k = 1;
        else
           b2k = 0;
        end
        
        if (imag(symbol) == 1)
            b2k1 = 1;
        else
            b2k1 = 0;
        end
        
        b_i(k)= b2k;
        b_i(k+1)= b2k1;
    end    
end