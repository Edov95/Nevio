

%% MAKES THE PLOT REQUIRED TO CHOOSE L AND N  
% load('swCORR.mat','SWcorr')
% load('swLS.mat','SWls')
sigdB=-8;
N=[2:20];
%N=[1:5];
figure,

plot(N,sigdB*ones(19,1),'b--','LineWidth',2), hold on,
plot(N,SWcorr(:,1),'r--o'), hold on,
plot(N,SWcorr(:,2),'g--x'), hold on,
plot(N,SWcorr(:,3),'k--d'), hold on,
plot(N,SWcorr(:,4),'y--v'), hold on,
plot(N,SWcorr(:,5),'c--*'), hold on,
plot(N,SWcorr(:,6),'m--s'), hold on,
plot(N,SWls(:,1),'-ro'), hold on,
plot(N,SWls(:,2),'-gx'), hold on,
plot(N,SWls(:,3),'-kd'), hold on,
plot(N,SWls(:,4),'-yv'), hold on,
plot(N,SWls(:,5),'-c*'), hold on,
plot(N,SWls(:,6),'-ms')
legend('\sigma_w^2','L=7','L=15', ...
       'L=31','L=63','L=127', ...
       'L=255','L=7','L=15', ...
       'L=31','L=63','L=127',...
       'L=255','Location','South', ...
       'Orientation','horizontal')
ylabel('\epsilon/L')
xlabel('N')
title('\epsilon/L vs N')

% figure,
% 
% plot(N,sigdB*ones(5,1),'b--','LineWidth',2), hold on,
% plot(N,SWls(1,:),'r--'), hold on,
% plot(N,SWls(4,:),'g--'), hold on,
% plot(N,SWls(10,:),'k--'), hold on,
% plot(N,SWls(15,:),'y--'), hold on,
% plot(N,SWls(19,:),'c--')
