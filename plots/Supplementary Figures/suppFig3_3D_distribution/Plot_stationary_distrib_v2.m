function [] = Plot_stationary_distrib_v2(H,W,Nspecies,points_mode_id,data_cut)

%% Plot stationary distribution for 2D or 3D reaction network
% Inputs: H - state-space coordinates (accepts also H_sparse_1D for the 3D)
%         W - probability distribution 
%         Nspecies - number of species ina athe network (either 2 or 3)

Prop_th=0.001; % this is a threshold to avoid plotting points with very small probability mass
cut_prctile=1;
if ~exist('data_cut','var')
    data_cut=max(max(W)*Prop_th,prctile(W,cut_prctile));
end
cut_ind=W>data_cut;
H=H(cut_ind,:);
W=W(cut_ind);
if Nspecies==2     
    D_rchange= Marginal_Sparse_to_grid(H,W,[1,2]);
    x_axis_p=0:(size(D_rchange,1)-1);
    y_axis_p=0:(size(D_rchange,2)-1);
    if exist('points_mode_id','var')
        points_mode_id_mat  = Marginal_Sparse_to_grid(H,points_mode_id,[1 2]);
        mesh(y_axis_p,x_axis_p,D_rchange,points_mode_id_mat,'FaceAlpha',1,'EdgeColor','none','FaceColor','flat')
    end
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
    SizeWeight=20*log(exp(1)+ceil(W/max(W)*100));
    if exist('points_mode_id','var')
        if ~isempty(points_mode_id)
            scatter3(H(:,1),H(:,2),H(:,3),SizeWeight,points_mode_id,'filled','o','MarkerFaceAlpha',0.1);
        else
            ind_faint=W<prctile(W,80);
            scatter3(H(ind_faint,1),H(ind_faint,2),H(ind_faint,3),SizeWeight(ind_faint),W(ind_faint),'filled','o','MarkerFaceAlpha',0.2);
            hold on
            ind_cear=W>=prctile(W,80) & W<prctile(W,90);
            scatter3(H(ind_cear,1),H(ind_cear,2),H(ind_cear,3),SizeWeight(ind_cear),W(ind_cear),'filled','o','MarkerFaceAlpha',0.4);
            hold on
            ind_cearer=W>=prctile(W,90);
            scatter3(H(ind_cearer,1),H(ind_cearer,2),H(ind_cearer,3),SizeWeight(ind_cearer),W(ind_cearer),'filled','o','MarkerFaceAlpha',0.6);
        end
    else
        ind_faint=W<prctile(W,80);
        scatter3(H(ind_faint,1),H(ind_faint,2),H(ind_faint,3),SizeWeight(ind_faint),W(ind_faint),'filled','o','MarkerFaceAlpha',0.1);
        hold on
        ind_cear=W>=prctile(W,80) & W<prctile(W,90);
        scatter3(H(ind_cear,1),H(ind_cear,2),H(ind_cear,3),SizeWeight(ind_cear),W(ind_cear),'filled','o','MarkerFaceAlpha',0.3);
        hold on
        ind_cearer=W>=prctile(W,90);
        scatter3(H(ind_cearer,1),H(ind_cearer,2),H(ind_cearer,3),SizeWeight(ind_cearer),W(ind_cearer),'filled','o','MarkerFaceAlpha',0.4);
    end
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
% colormap(flip(copper))
colormap(lines)
xticks([])
yticks([])
zticks([])
set(gcf,'Color','w');
end

