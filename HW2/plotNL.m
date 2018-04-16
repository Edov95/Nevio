
%% MAKES THE PLOT REQUIRED TO CHOOSE L AND N  
% load('swCORR.mat','SWcorr')
% load('swLS.mat','SWls')
sigdB=-8;
N=[2:20];

figure,

plot(N,sigdB*ones(19,1),'b--','LineWidth',2), hold on,
plot(N,SWcorr(:,1),'r--'), hold on,
plot(N,SWcorr(:,2),'g--'), hold on,
plot(N,SWcorr(:,3),'k--'), hold on,
plot(N,SWcorr(:,4),'y--'), hold on,
plot(N,SWcorr(:,5),'c--'), hold on,
plot(N,SWls(:,1),'r'), hold on,
plot(N,SWls(:,2),'g'), hold on,
plot(N,SWls(:,3),'k'), hold on,
plot(N,SWls(:,4),'y'), hold on,
plot(N,SWls(:,5),'c'), hold on,
legend('\sigma_w^2','L=7','L=15','L=31','L=63','L=127','L=7','L=15','L=31','L=63','L=127','Location','South','Orientation','horizontal')
ylabel('\epsilon/L')
xlabel('N')
title('\epsilon/L vs N')


