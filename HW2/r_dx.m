function [rx]=r_dx(x,r)
L=length(x)/2;
rx=zeros(L, 1);
for m=1:L-1
    rtemp=zeros(L,1);
    for k=1:L
        rtemp(k)=r(L-2+k)*conj(x(L-1+k-m));
    end
    rx(m)=sum(rtemp)/L;
end
end