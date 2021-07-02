function [] = Plot_stationary_distrib(H,W,Nspecies)

%% Plot stationary distribution for 2D or 3D reaction network
% Inputs: H - state-space coordinates (accepts also H_sparse_1D for the 3D)
%         W - probability distribution 
%         Nspecies - number of species ina athe network (either 2 or 3)

Prop_th=0.01; % this is a threshold
cut_prctile=1;
data_cut=max(max(W)*Prop_th,prctile(W,cut_prctile));
cut_ind=W>data_cut;
H=H(cut_ind,:);
W=W(cut_ind);
if Nspecies==2     
    D_rchange= Marginal_Sparse_to_grid(H,W,[1,2]);
    x_axis_p=0:(size(D_rchange,1)-1);
    y_axis_p=0:(size(D_rchange,2)-1);
    mesh(y_axis_p,x_axis_p,D_rchange,'FaceAlpha',1,'EdgeColor','none','FaceColor','interp')
    set(gca,'FontSize',20)
    set(gca, 'FontName', 'Helvetica')
    set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
    'LineWidth', 1)
    ax = gca;
    ax.YRuler.Exponent = 0;
    xlabel('$x_1$','Interpreter','Latex','FontSize',25);
    ylabel('$x_2$','Interpreter','Latex','FontSize',25);
    zlabel('$\hat{P}^s$','Interpreter','Latex','FontSize',25);
    set(get(gca,'ZLabel'),'Rotation',0)
    axis tight
    
elseif Nspecies==3
    if size(H,2)==1
        H = H1D_to_H(H,Nspecies);
    end
    SizeWeight=ceil(W/max(W)*100);
    scatter3(H(:,1),H(:,2),H(:,3),SizeWeight,W,'filled','o','MarkerFaceAlpha',0.7);
    set(gca,'FontSize',20)
    set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
    'XMinorTick', 'off', 'YMinorTick', 'off', ...
    'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
    'LineWidth', 1)
    ax = gca;
    ax.YRuler.Exponent = 0;
    set(get(gca,'ZLabel'),'Rotation',0)
    xlabel('$x_1$','Interpreter','Latex','FontSize',25);
    ylabel('$x_2$','Interpreter','Latex','FontSize',25);
    zlabel('$x_3$','Interpreter','Latex','FontSize',25);
    c = colorbar;
    set(c,'FontSize',20)
    c.Label.Interpreter = 'latex';
    c.Label.FontSize = 25;
    c.Label.String = '$\hat{P}^s$';
    set(get(c,'YLabel'),'Rotation',0)
end

end

