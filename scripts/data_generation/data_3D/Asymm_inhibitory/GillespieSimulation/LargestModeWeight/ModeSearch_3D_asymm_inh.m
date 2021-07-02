clear all
% relies on folder Mode search, Gillespie_and_Distribution and shared functions
LMW=zeros(20,7,7);

% Mode Search
for Ai=1:7
    FileNameLoad=strcat('A',num2str(Ai),'_gill_asymm_inh.mat');
    LargestModeWeight=Mode_Search_Ai(Ai,FileNameLoad);
    LMW(:,:,Ai)=LargestModeWeight;
end

%% Save largest mode weight for all connectivities 
FileNameSave=strcat("LMW_3D_inh_asymm.mat");
save(FileNameSave,'LMW')

%% Boxplots
xbar_vec=[4 8 12; 5 11 15; 3 10 15; 4 8 12; 5 12 20; 5 12 20; 3 1 1]; %each row represents the choices of xbar for an inhibitory architecture
figure
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

%% helper function
function [LargestModeWeight,NofModes] = Mode_Search_Ai(Ai,FileNameLoad)
    xbarvec=[3 5 7 9 11 13 15];
    load(FileNameLoad)
    [Nk,Nxbar]=size(Hall);
    LargestModeWeight=zeros(Nk,Nxbar);
    NofModes=zeros(Nk,Nxbar);
    points_mode_id_all=cell(Nk,Nxbar);
    Prop_th=0;
    xbar=2;
    for j=1:Nxbar
        for i=1:Nk
            H_sparse_1D_temp=double(Hall{i,j});
            H_sparse_temp=H1D_to_H(H_sparse_1D_temp,3,maxXXall{i,j});
            W_sparse_temp=Wall{i,j};
            [LargestModeWeight(i,j),NofModes(i,j),points_mode_id] = LargestMode_complete_alg(H_sparse_temp,W_sparse_temp,H_sparse_1D_temp,Prop_th,xbar,0);
            points_mode_id_all{i,j}=points_mode_id;
            disp([Ai,j,i])
        end
    end
end