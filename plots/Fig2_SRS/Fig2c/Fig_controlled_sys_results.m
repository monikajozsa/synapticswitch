% close all
% clear all
% clc
%% This code relies on the following data files: Changing_x_0,Changing_t_per,Changing_t_dur,Changing_t_act,Changing_n_0,Changing_m_inp,Changing_k,Changing_delta_n

k_vec=linspace(0.01,0.3,10); % inhibition constant
delta_n_vec=linspace(0.001,0.1,10); % plasticity constant
n_0_vec=linspace(1,5.5,10); % initial macro-size
t_act_vec=linspace(0,9,10); % activaition time threshold
m_inp_vec=linspace(1,10,10); % input magnitude
t_per_vec=linspace(10,100,10); % input period
x_0_vec=linspace(1,10,10); % initial state
t_dur_vec=linspace(0.1,1,10); % input time duration

%% baseline indices
baseline_val.k=k_vec(5);
baseline_val.delta_n=delta_n_vec(5);
baseline_val.n_0=n_0_vec(5);
baseline_val.t_act=t_act_vec(4);
baseline_val.m_inp=m_inp_vec(5);
baseline_val.t_per=t_per_vec(5);
baseline_val.x_0=x_0_vec(5);
baseline_val.t_dur=t_dur_vec(5);


Data_FileName_vec=["Changing_x_0.mat","Changing_n_0.mat","Changing_k.mat","Changing_delta_n.mat","Changing_t_act.mat","Changing_m_inp.mat","Changing_t_per.mat","Changing_t_dur.mat"];
Baseline_ind_vec=ones(1,8)*5;
val_interval_vec=[min(x_0_vec), max(x_0_vec); min(n_0_vec),max(n_0_vec);min(k_vec),max(k_vec);min(delta_n_vec),max(delta_n_vec);min(t_act_vec),max(t_act_vec);min(m_inp_vec),max(m_inp_vec);min(t_per_vec),max(t_per_vec); min(t_dur_vec), max(t_dur_vec)];
cb_label_vec=["$x_0$","$n_0$","$k$","$\delta_n$","$t_{act}$","$m_{inp}$","$t_{per}$","$t_{dur}$"];

for i=1:length(Data_FileName_vec)
    figure
    MakeSubFig_left(Data_FileName_vec(i),Baseline_ind_vec(i),val_interval_vec(i,:),cb_label_vec(i),1,1,1)
    set(gcf,'Color','w');
%     SaveFileName_i=strcat('Controlled_sys_scatter_',num2str(i));
%     export_fig(SaveFileName_i,'-pdf','-q101');
end

% for i=1:8
%     MakeSubFig_left(Data_FileName_vec(i),Baseline_ind_vec(i),val_interval_vec(i,:),cb_label_vec(i),4,2,i)
% end
% set(gcf,'Color','w');
% export_fig('Controlled_sys_scatter','-pdf','-q101');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% time series plot %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %clear all
% N_real=20;
% load('With_without_input.mat')
% n_change_without_inp=n_change{1};
% n_change_with_inp=n_change{2};
% cmap = distinguishable_colors(N_real);%hsv(N_real);%rand(N_real,3);%jet(20);
% 
% figure
% for i=1:N_real
%     subplot(1,2,1)
%     Temp=n_change_without_inp{i};
%     plot([0;Temp(:,1)],[3;Temp(:,2)],'LineWidth',1.8, 'Color', cmap(i, :))
%     xlim([0 10000])
%     hold on
% end
% 
% xlim_for_ticks = xlim;
% xticks([xlim_for_ticks(1) xlim_for_ticks(end)])
% xticklabels({round(xlim_for_ticks(1)) round(xlim_for_ticks(end))})
% a = get(gca,'XTickLabel');  
% set(gca,'TickLabelInterpreter','latex')
% set(gca,'XTickLabel',a,'FontSize',18)
% %
% ylim_for_ticks = ylim;
% yticks([ylim_for_ticks(1) ylim_for_ticks(end)])
% yticklabels({round(ylim_for_ticks(1)) round(ylim_for_ticks(end))})
% a = get(gca,'YTickLabel');  
% set(gca,'YTickLabel',a,'FontSize',18)
% for i=1:N_real
%     subplot(1,2,2)
%     Temp=n_change_with_inp{i};
%     plot([0;Temp(:,1)],[3;Temp(:,2)],'LineWidth',1.8, 'Color', cmap(i, :))
%     xlim([0 10000])
%     hold on
% end
% %
% xlim_for_ticks = xlim;
% xticks([xlim_for_ticks(1) xlim_for_ticks(end)])
% xticklabels({round(xlim_for_ticks(1)) round(xlim_for_ticks(end))})
% a = get(gca,'XTickLabel');  
% set(gca,'TickLabelInterpreter','latex')
% set(gca,'XTickLabel',a,'FontSize',18)
% %
% ylim_for_ticks = ylim;
% yticks([ylim_for_ticks(1) ylim_for_ticks(end)])
% yticklabels({round(ylim_for_ticks(1)) round(ylim_for_ticks(end))})
% a = get(gca,'YTickLabel');  
% set(gca,'YTickLabel',a,'FontSize',18)
% 
% set(gcf,'Color','w');
% export_fig('Controlled_sys_time_series','-pdf','-q101');

%%%%%%%%%%%%%%%%%%%%%%%
%%% Helper function %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [] = MakeSubFig_left(Data_FileName,Baseline_ind,val_interval,cb_label,nrows,ncols,subfig_ind)
    n_samples=1;
    n_real_per_sample=200;
    load(Data_FileName)
    ColoringViridis=viridis(N_param);
    subplot(nrows,ncols,subfig_ind)
    for param_ind=1:N_param
        N_survived_temp=N_survived{param_ind};
        temp_ind=find(Blown_up_ind{param_ind});
        n_avg_temp=n_avg{param_ind};
        if param_ind~=Baseline_ind
            for i=1:n_samples
                temp_ind_i=temp_ind(temp_ind<i*n_real_per_sample+1);
                scatter(mean(N_survived_temp(temp_ind_i)), mean(n_avg_temp(temp_ind_i)),100,ColoringViridis(param_ind,:),'MarkerEdgeAlpha',.85,'LineWidth',3)
%                 scatter(mean(N_survived_temp(temp_ind_i)), mean(n_avg_temp(temp_ind_i)),50,ColoringViridis(param_ind,:),'MarkerEdgeAlpha',.85,'LineWidth',2)
                hold on
            end
        end
    end
    param_ind=Baseline_ind;
    N_survived_temp=N_survived{param_ind};
    temp_ind=find(Blown_up_ind{param_ind});
    n_avg_temp=n_avg{param_ind};
    for i=1:n_samples
        temp_ind_i=temp_ind(temp_ind<i*n_real_per_sample+1);
        scatter(mean(N_survived_temp(temp_ind_i)), mean(n_avg_temp(temp_ind_i)),100,'MarkerEdgeColor',ColoringViridis(param_ind,:),'MarkerFaceColor','red','MarkerEdgeAlpha',.85,'LineWidth',3)
%         scatter(mean(N_survived_temp(temp_ind_i)), mean(n_avg_temp(temp_ind_i)),50,'MarkerEdgeColor',ColoringViridis(param_ind,:),'MarkerFaceColor','red','MarkerEdgeAlpha',.85,'LineWidth',2)
        hold on
    end
    
    colormap(ColoringViridis)
    cb=colorbar;

    min_val=val_interval(1);
    max_val=val_interval(2);
    mid_val=(ColoringViridis(N_param))/2;
    set(cb,'Ticks',[0,mid_val,ColoringViridis(N_param)])
    set(cb,'TickLabelInterpreter','latex')
    set(cb,'TickLabels',{min_val,cb_label,max_val},'FontSize',25)
    xlim([0,1])

    xticks_old = xticks;
    xticklabels_old = xticklabels;
    xticks([xticks_old(1) xticks_old(end)])
    xticklabels({xticklabels_old{1} xticklabels_old{end}})
    a = get(gca,'XTickLabel');  
    set(gca,'XTickLabel',a,'FontSize',25)
    set(gca,'TickLabelInterpreter','latex')
    
    ylim_for_ticks = ylim;
    yticks([ylim_for_ticks(1) ylim_for_ticks(end)])
    yticklabels({round(ylim_for_ticks(1)) round(ylim_for_ticks(end))})
    a = get(gca,'YTickLabel');  
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'YTickLabel',a,'FontSize',25)
end