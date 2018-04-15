function [h0, h1, r_0, r_1] = corrEst(x, d_true, Ncurrent)
%computes the estimates h_0 and h_1 and the outputs ot the 2 filters with
%the correlation method
L=length(x)/2;
%split even and odd samples of the output of the channel
r_0_true=d_true(1:2:end);
r_1_true=d_true(2:2:end);

h0=r_dx(x, r_0_true);
h1=r_dx(x, r_1_true);

if (Ncurrent<L)
h0=h0(1:ceil(Ncurrent/2));
h1=h1(1:floor(Ncurrent/2));
end
%computes the outputs of the two polyphase estimated components
r_0=filter(h0,1,x);
r_1=filter(h1,1,x);

end