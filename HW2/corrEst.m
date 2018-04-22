function [h0, h1, r_0, r_1] = corrEst(x, d0, d1, Ncurrent)
%computes the estimates h_0 and h_1 and the outputs ot the 2 filters with
%the correlation method
L=length(x)/2;

h0=zeros(L, 1);
h1=zeros(L, 1);
for m=1:L-1
    rtemp0=zeros(L,1);
    rtemp1=zeros(L,1);
    for k=1:L
        %starts using the samples of d after a transient of ength L-1
        rtemp0(k)=d0(L-2+k)*conj(x(L-1+k-m));
        rtemp1(k)=d1(L-2+k)*conj(x(L-1+k-m));
    end
    h0(m)=sum(rtemp0)/L;
    h1(m)=sum(rtemp1)/L;
end

if (Ncurrent<L)
h0=h0(1:ceil(Ncurrent/2));
h1=h1(1:floor(Ncurrent/2));
end
%computes the outputs of the two polyphase estimated components
r_0=filter(h0,1,x);
r_1=filter(h1,1,x);

end