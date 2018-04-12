function [ h_ls ] = LS( x, d, L)
% x the input seq
% d filter output
% L half length PN seq
% N order of the filter

%build matrix Phi and theta by I and o (page 246)
I=zeros(L);
for column = 1:L
    I(:,column) = x(L-column+1:(2*L-column));
end
o=d(L:2*L-1);
Phi=I'*I;
theta= I'*o;

h_ls=inv(Phi)*theta;
%h_ls=h_ls(1:N);

end