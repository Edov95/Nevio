function [symbols] = BMAP(bits)

% bits are given as a row vector because of the interleaver function output
L = length(bits);
symbols = zeros(L,1);
    % gray coding of the input bits for QPSK symbols
    for k = 1:2:L-1
        if (isequal(bits(k:k+1), [0 0] ))
            symbols(k) = -1-1i;
        elseif (isequal(bits(k:k+1), [1 0] ))
            symbols(k) = 1-1i;
        elseif (isequal(bits(k:k+1), [0 1] ))
            symbols(k) = -1+1i;
        elseif (isequal(bits(k:k+1), [1 1] ))
            symbols(k) = +1+1i;
        end
    end
    symbols = symbols(1:2:end);   
end