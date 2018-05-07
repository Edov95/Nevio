function [a_hat_kD] = threshold_detector(y_k)

if (real(y_k) > 0)
    if (imag(y_k) > 0)
        a_hat_kD = 1+1i;
    else
        a_hat_kD= 1-1i;
    end
else
    if (imag(y_k) > 0)
        a_hat_kD = -1+1i;
    else
        a_hat_kD = -1-1i;
    end
end

end

