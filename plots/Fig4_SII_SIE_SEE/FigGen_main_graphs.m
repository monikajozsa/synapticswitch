clear all
close all
clc
%% first dimension of saved H_sparse_all, etc is rate constant! second is system size

Data_vec=["Data_II_sym","Data_IE_sym","Data_EE_sym", "Data_II_asym","Data_IE_asym","Data_EE_asym"];
Mode_vec=["Data_II_sym_modes","Data_IE_sym_modes","Data_EE_sym_modes", "Data_II_asym_modes","Data_IE_asym_modes","Data_EE_asym_modes"];

figure
min_val=zeros(6,1);
max_val=zeros(6,1);
sys_type_name=["S_{II}","S_{IE}","S_{EE}"];
plot_ind_vec=[1,2,3,7,8,9];
for sys_type=1:6
    tic
    load(Data_vec(sys_type));
    load(Mode_vec(sys_type));
    subplot(3,3,plot_ind_vec(sys_type))
    imagesc(LargestModeWeight)
    min_val(sys_type)=min(LargestModeWeight(:));
    max_val(sys_type)=max(LargestModeWeight(:));
    if sys_type==1
        ylabel('\fontsize{20}{k_{12}=k_{21}}','interpreter','tex')
    end
    if sys_type==4
        ylabel('\fontsize{20}{k_{21}}  \fontsize{14}{(k_{12}=0.055)}','interpreter','tex')
    end
    if sys_type==5
        xlabel('$macroscopic \hspace{0.2cm} size \hspace{0.2cm} (n)$','interpreter','latex','FontSize',18)
    end
    yticks_ind=yticks;
    yticklabels(rate_const_interval_vec(yticks_ind))
    xticks_ind=xticks;
    xticklabels(xbar_vec(xticks_ind))
end

for sys_type=1:6
    subplot(3,3,plot_ind_vec(sys_type))
    caxis manual
    caxis([min(min_val),max(max_val)]);
    colormap(viridis(100))
end

for i=1:3
    pos_sp=get(subplot(3,3,i),'Position');
    sp=subplot(3,3,i);
    sp.Position=[pos_sp(1) pos_sp(2)-0.12 pos_sp(3) pos_sp(4)];
    if i==1
        hp1 = pos_sp;
    end
end

for sys_type=4:6
    subplot(3,3,plot_ind_vec(sys_type))
    caxis manual
    caxis([min(min_val),max(max_val)]);
    colormap(viridis(100))
end

hp6 = get(subplot(3,3,9),'Position');
colorbar('Position', [hp6(1)+hp6(3)+0.03  hp6(2)  0.01  hp6(2)+hp6(3)*3.3])

run('FigGen_graphs.m')
set(gcf,'Color','w');
%it needs a little manual adjustment at this point
% export_fig('Fig_1_4','-pdf','-q101');