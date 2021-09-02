clc
clear all
close all

load("Data_II_sym_LNA")
P_in_II=1-P_out;

load("Data_IE_sym_LNA")
P_in_IE=1-P_out;

load("Data_EE_sym_LNA")
P_in_EE=1-P_out;

load("Data_II_sym_modes")
LMW_II=LargestModeWeight;

load("Data_IE_sym_modes")
LMW_IE=LargestModeWeight;

load("Data_EE_sym_modes")
LMW_EE=LargestModeWeight;

figure
hold on
CM = 0.1:-0.01:0.01;
for rate_const_ind=1:10

    scatter(P_in_II(rate_const_ind,:),LMW_II(rate_const_ind,:),[],'b','o','LineWidth',2,'HandleVisibility','off')
    scatter(P_in_IE(rate_const_ind,:),LMW_IE(rate_const_ind,:),[],'g','v','LineWidth',2,'HandleVisibility','off')
    scatter(P_in_EE(rate_const_ind,:),LMW_EE(rate_const_ind,:),[],'r','x','LineWidth',2,'HandleVisibility','off')
end

scatter(NaN,NaN,'b','o','LineWidth',2)
scatter(NaN,NaN,'g','v','LineWidth',2)
scatter(NaN,NaN,'r','x','LineWidth',2)
hleg=legend({'$S_{II}$','$S_{IE}$','$S_{EE}$'},'FontSize',25,'Interpreter','Latex');

plot([0 1.1],0.5*[1 1] ,'LineWidth',2,'LineStyle','--','Color','k','HandleVisibility','off') 

set(gca,'FontSize',25)
set(gca, 'FontName', 'Helvetica')
label_x = xlabel('$P_{in}$','Interpreter','Latex','FontSize',25);
label_y =ylabel('$LMW$','Interpreter','Latex','FontSize',25);
set(gca, 'FontName', 'Helvetica')
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
    'LineWidth', 1)
ax = gca;
ax.YRuler.Exponent = 0;
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',0,'VerticalAlignment','middle')
axis([0 1.05 0 1.05])
set(gca,'XLim',[0 1.05],'XTick',[0 0.5 1]) %x_bar=1
set(gca,'YLim',[0 1.05],'YTick',[0 0.5 1])
label_y.Position(1)=0.6*label_y.Position(1); % change horizontal position of ylabel
label_y.Position(2)=1.05*label_y.Position(2); % change vertical position of ylabel

set(gcf,'Color','w');
export_fig('Fig_scatter','-pdf','-q101');