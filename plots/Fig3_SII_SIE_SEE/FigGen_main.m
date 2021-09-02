FileName_vec=["DataXT_II_exampl.mat","DataXT_IE_exampl.mat","DataXT_EE_exampl.mat"];

figure
f_size=18;
datatip_font=16;
k=1;
for network_i=1:3
    load(FileName_vec(network_i))
    
    %% small sys size
    subplot(2,3,network_i)
    ind_cut=find(WW_sparse_small>mean(WW_sparse_small)*0.0001);
    H_sparse_small=H_sparse_small(ind_cut,:);
    WW_sparse_small=WW_sparse_small(ind_cut);
    D_rchange= Marginal_Sparse_to_grid(H_sparse_small,WW_sparse_small,[1,2]);
    below_threshold_ind=D_rchange<prctile(D_rchange(:),0.1);
    D_rchange(below_threshold_ind)=0;
    x_axis_p=0:(size(D_rchange,1)-1);
    y_axis_p=0:(size(D_rchange,2)-1);
    mesh(y_axis_p,x_axis_p,D_rchange,'EdgeColor','none','FaceColor','interp');
    hold on
    if network_i==1
        sp1_z=round(D_rchange(1,32)*10e2)/10e2;
        sp1 = plot3(0,31,sp1_z);
        sp1.DataTipTemplate.DataTipRows(1).Label ="$x_1$";
        sp1.DataTipTemplate.DataTipRows(2).Label ="$x_2$";
        sp1.DataTipTemplate.DataTipRows(3).Label ="$P^s(x)$";
        datatip(sp1,0,31,sp1_z);
        sp2_z=round(D_rchange(32,1)*10e2)/10e2;
        sp2 = plot3(31,0,sp2_z);
        datatip(sp2,31,0,sp2_z);
        sp2.DataTipTemplate.DataTipRows(1).Label ="$x_1$";
        sp2.DataTipTemplate.DataTipRows(2).Label ="$x_2$";
        sp2.DataTipTemplate.DataTipRows(3).Label ="$P^s(x)$";
    elseif network_i==2
        sp3_z=round(D_rchange(5,4)*10e2)/10e2;
        sp3 = plot3(3,4,sp3_z);
        datatip(sp3,3,4,sp3_z);
        sp3.DataTipTemplate.DataTipRows(1).Label ="$x_1$";
        sp3.DataTipTemplate.DataTipRows(2).Label ="$x_2$";
        sp3.DataTipTemplate.DataTipRows(3).Label ="$P^s(x)$";
    else
        sp4_z=round(D_rchange(1,1)*10e2)/10e2;
        sp4 = plot3(0,0,sp4_z);
        dtip=datatip(sp4,0,0,sp4_z);
        sp4.DataTipTemplate.DataTipRows(1).Label ="$x_1$";
        sp4.DataTipTemplate.DataTipRows(2).Label ="$x_2$";
        sp4.DataTipTemplate.DataTipRows(3).Label ="$P^s(x)$";
    end
    if network_i==2
        xlim([min(y_axis_p) max(y_axis_p)])
        ylim([min(x_axis_p) max(x_axis_p)])
    else
        xlim([0 min([max(x_axis_p),max(y_axis_p)])])
        ylim([0 min([max(x_axis_p),max(y_axis_p)])])
    end
    AxesLabelFunc()
    set(gca,'Position',get(gca,'Position')+[0 0.05 0 0])
    set(gca,'linewidth',2)
    
    %% large sys size
    subplot(2,3,3+network_i)
    ind_cut=find(WW_sparse_large>mean(WW_sparse_large)*0.0001);
    H_sparse_large=H_sparse_large(ind_cut,:);
    WW_sparse_large=WW_sparse_large(ind_cut);
    D_rchange= Marginal_Sparse_to_grid(H_sparse_large,WW_sparse_large,[1,2]);
    below_threshold_ind=D_rchange<prctile(D_rchange(:),0.1);
    D_rchange(below_threshold_ind)=0;
    x_axis_p=0:(size(D_rchange,1)-1);
    y_axis_p=0:(size(D_rchange,2)-1);
    mesh(y_axis_p,x_axis_p,D_rchange,'EdgeColor','none','FaceColor','interp');
    hold on
    
    sp5_z=round(D_rchange(101,101)*10e3)/10e3;
    sp5 = plot3(100,100,sp5_z);
    datatip(sp5,100,100,sp5_z);
    sp5.DataTipTemplate.DataTipRows(1).Label ="$ x_1$";
    sp5.DataTipTemplate.DataTipRows(2).Label ="$ x_2$";
    sp5.DataTipTemplate.DataTipRows(3).Label ="$ P^s(x)$";
    if network_i==2
        xlim([min(y_axis_p) max(y_axis_p)])
        ylim([min(x_axis_p) max(x_axis_p)])
    else
        xlim([0 min([max(x_axis_p),max(y_axis_p)])])
        ylim([0 min([max(x_axis_p),max(y_axis_p)])])
    end
    AxesLabelFunc()
    set(gca,'Position',get(gca,'Position')+[0 -0.05 0 0])
    set(gca,'linewidth',2)
    
end
set(datacursormode,'updatefcn',@mydatatip,'interpreter','latex')

% sp1.DataTipTemplate.FontSize =datatip_font;
% sp2.DataTipTemplate.FontSize =datatip_font;
% sp3.DataTipTemplate.FontSize =datatip_font;
% sp4.DataTipTemplate.FontSize =datatip_font;
% sp5.DataTipTemplate.FontSize =datatip_font;

alldatacursors = findall(gcf,'type','hggroup');
set(alldatacursors,'FontSize',datatip_font)
cmap_vir=viridis(100);
cmap_vir=[0.8 0.8 0.8; cmap_vir];
colormap(cmap_vir)

matlab.graphics.internal.setPrintPreferences('DefaultPaperPositionMode','manual')
set(groot,'defaultFigurePaperPositionMode','manual')
set(gcf,'Color','w');


function [] = AxesLabelFunc()
    xlim_for_ticks = xlim;
    xticks([xlim_for_ticks(1) xlim_for_ticks(end)])
    xticklabels({xlim_for_ticks(1) xlim_for_ticks(end)})
    a = get(gca,'XTickLabel');  
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'XTickLabel',a,'FontSize',22)
    
    ylim_for_ticks = ylim;
    yticks([ylim_for_ticks(1) ylim_for_ticks(end)])
    yticklabels({ylim_for_ticks(1) ylim_for_ticks(end)})
    a = get(gca,'YTickLabel');  
    set(gca,'YTickLabel',a,'FontSize',22)
    
    zlim_for_ticks = zlim;
    zticks([zlim_for_ticks(1) zlim_for_ticks(end)])
    %zticklabels({zlim_for_ticks(1) zlim_for_ticks(end)})
    zticklabels({[],[]})
    %a = get(gca,'ZTickLabel');  
    %set(gca,'ZTickLabel',a,'FontSize',18)
    %ztickformat('%.2f')
end