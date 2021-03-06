function [h0, h1, r_0, r_1] = LSest(x, d0, d1, Ncurrent)
%computes the estimate h_0 and h_1 and the outputs of the 2 filter with the
%LS method
L=length(x)/2;
%split even and odd samples of the output of the channel
% Ed0=sum(d0(L:2*L-1).^2);
% Ed1=sum(d1(L:2*L-1).^2);

I=zeros(L);
for k=1:L
    I(:,k)=x(L-k+1:(2*L-k));
end
o0=d0(L:2*L-1);
o1=d1(L:2*L-1);
Phi=I'*I;
theta0=I'*o0;
theta1=I'*o1;
h0=Phi\theta0;
h1=Phi\theta1;

if (Ncurrent<L)
h0=h0(1:ceil(Ncurrent/2));
h1=h1(1:floor(Ncurrent/2));
theta0=theta0(1:ceil(Ncurrent/2));
theta1=theta1(1:floor(Ncurrent/2));
end

% Emin0=Ed0-theta0'*h0;
% Emin1=Ed1-theta1'*h1;
%computes the outputs of the two polyphase estimated components
r_0=filter(h0,1,x);
r_1=filter(h1,1,x);

end