load('data/data_3D/Symm_inhibitory/GillespieSimulation/A1/Data_A1_mode.mat')
load('data/data_3D/Symm_inhibitory/LinearNoiseApproximation/Data_A1_LNA_symm_inh.mat')

%fix k, change n
i=8;
figure
plot(LargestModeWeight(:,i),'o-','LineWidth',2)
hold on
p_Pin=plot(1-P_out(i,:),'o-','LineWidth',2.5);
p_Pin.Color(4) = 0.5;
xlim([1,13])
ylim([0.3,1.02])
set(gcf,'Color','w');
% export_fig('fix_k','-pdf','-q101');

%fix n, change k
j=3;
LMW=flip(LargestModeWeight(j,:));
LMWn=normalize(LMW);
Pin=(1-P_out(:,j));
Pinn=normalize(Pin);
figure
plot(LMWn,'o-','LineWidth',2)
hold on
p_Pin=plot(Pinn,'o-','LineWidth',2);
p_Pin.Color(4) = 0.5;
set(gcf,'Color','w');
% export_fig('fix_n','-pdf','-q101');

figure
plot(LMW,'o-','LineWidth',2)
hold on
plot(Pin,'o-','LineWidth',2)
set(gcf,'Color','w');
% export_fig('fix_n_notnorm','-pdf','-q101');

% LMW_slope=diff(LMW)/(max(LMW)-min(LMW));
% plot(LMW_slope,'o-','LineWidth',2)
% hold on
% Pin=1-P_out(:,3);
% Pin_slope=diff(Pin)/(max(Pin)-min(Pin));
% plot(Pin_slope,'o-','LineWidth',2)
% 
% colormap(viridis(prod(size(LMW))));
% 
% figure;
% imagesc(Pin'-min(Pin(:)))
% 
% [a,b]=sort(Pin);
