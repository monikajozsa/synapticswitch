%% Boxplots
figure
load('LMW_3D_inh_asymm_v3.mat')
for i=1:7
    subplot(1,7,i)
    if i==1
        boxplot(LMW(:,:,i),'Labels',{'','','','','','',''},'whisker',2)
        tickval=get(gca,'YTick');
        ticklabel=get(gca,'YTickLabel');
        set(gca,'YTick',[0 0.5 1])
        set(gca,'YTickLabel',[0 0.5 1])
    else
        boxplot(LMW(:,:,i),'Labels',{'','','','','','',''})
        set(gca,'YTick',[0 0.5 1])
        set(gca,'YTickLabel',[])
    end
    set(gca,'LineWidth',1)
    ylim([0 1])
    set(gca, 'FontSize',20)
    set(findobj(gca,'type','line'),'linew',1.5)
end

set(gcf,'Color','w');
% export_fig('Fig_asymm_3D_inh','-pdf','-q101');