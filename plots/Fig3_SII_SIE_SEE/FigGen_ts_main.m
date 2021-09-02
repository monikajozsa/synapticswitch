FileName_vec=["DataXT_II_exampl.mat","DataXT_IE_exampl.mat","DataXT_EE_exampl.mat"];
% Save_FileName_vec=["Small_II","Small_IE","Small_EE";"Large_II","Large_IE","Large_EE"];

f_size=26;
close all

for network_i=1:3
    load(FileName_vec(network_i))
    ind_vec=1:35000;
    figure
    co = get(gca,'ColorOrder');
    % Change to new colors.
    set(gca, 'ColorOrder', [0  0 0.5; 0.8516    0.6445    0.1250], 'NextPlot', 'replacechildren');

    plot(T_small,X_small(:,:),'LineWidth',1.2)
    xlim([T_small(1), T_small(ind_vec(end))])
    AxesLabelFunc(f_size)
    set(gcf,'Color','w');
%     export_fig(Save_FileName_vec(1,network_i),'-pdf','-q101');
    
    figure
    co = get(gca,'ColorOrder');
    % Change to new colors.
    set(gca, 'ColorOrder', [0  0 0.5; 0.8516    0.6445    0.1250], 'NextPlot', 'replacechildren');
    plot(T_large,X_large(:,:),'LineWidth',1.2)
    xlim([T_large(1), T_large(ind_vec(end))])
    AxesLabelFunc(f_size)

    set(gcf,'Color','w');
%     export_fig(Save_FileName_vec(2,network_i),'-pdf','-q101');
end

%% to get the symbols for labeling
title('$x_1 \quad x_2$', 'Interpreter','latex','FontSize',50)
% export_fig(Save_FileName_vec(2,network_i),'-pdf','-q101');

function [] = AxesLabelFunc(f_size)
    xlim_for_ticks = xlim;
    xticks([xlim_for_ticks(1) xlim_for_ticks(end)])
    xticklabels({[],[]})
    a = get(gca,'XTickLabel');  
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'XTickLabel',a,'FontSize',f_size)
    
    ylim_for_ticks = ylim;
    yticks([ylim_for_ticks(1) ylim_for_ticks(end)])
    %yticklabels({ylim_for_ticks(1) ylim_for_ticks(end)})
    yticklabels({[], []})
    a = get(gca,'YTickLabel');  
    set(gca,'YTickLabel',a,'FontSize',f_size)
    x_length=xlim_for_ticks(end)-xlim_for_ticks(1);
    y_length=ylim_for_ticks(end)-ylim_for_ticks(1);
    ylim([ylim_for_ticks(1), ylim_for_ticks(end)])
    daspect([x_length y_length*3 1])
    axis off
end