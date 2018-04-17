function [h0, h1, r_0, r_1] = LSest(x, d_true, Ncurrent)
%computes the estimate h_0 and h_1 and the outputs of the 2 filter with the
%LS method
L=length(x)/2;
%split even and odd samples of the output of the channel
d0=d_true(1:2:end);
d1=d_true(2:2:end);
Ed0=sum(d0.^2);
Ed1=sum(d1.^2);

[h0]=LS(x, d0, L);
[h1]=LS(x, d1, L);

if (Ncurrent<L)
h0=h0(1:ceil(Ncurrent/2));
h1=h1(1:floor(Ncurrent/2));
end
%computes the outputs of the two polyphase estimated components
r_0=filter(h0,1,x);
r_1=filter(h1,1,x);

end