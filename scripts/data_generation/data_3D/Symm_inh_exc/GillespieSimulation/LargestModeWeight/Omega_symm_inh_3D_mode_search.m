clear all
% close all
% addpath(genpath('/Users/mj555l/Dropbox (Cambridge University)/Monika-Tim/Synaptic switch paper/Synaptic switch matlab simulations/shared functions'))
% addpath(genpath('/Users/mj555l/Dropbox (Cambridge University)/Monika-Tim/Synaptic switch paper/Synaptic switch matlab simulations/Gillespie_and_Distribution'))
% addpath(genpath('/Users/mj555l/Dropbox (Cambridge University)/Monika-Tim/Synaptic switch paper/Synaptic switch matlab simulations/Mode search'))

for Ai=5:7
    [LargestModeWeight,NofModes] = Mode_Search_Ai(Ai);
end

function [LargestModeWeight,NofModes] = Mode_Search_Ai(Ai)
    FileNameLoad=strcat('A',num2str(Ai),'_gill_omega.mat');
    load(FileNameLoad)
    [Nlambda,NW]=size(Hall);
    LargestModeWeight=zeros(Nlambda,NW);
    NofModes=zeros(Nlambda,NW);
    points_mode_id_all=cell(Nlambda,NW);
    Prop_th=0;
    xbar=2;
    for i=1:NW
        for j=1:Nlambda
            H_sparse_1D_temp=double(Hall{j,i});
            H_sparse_temp=H1D_to_H(H_sparse_1D_temp,3,maxXXall{j,i});
            W_sparse_temp=Wall{j,i};
            [LargestModeWeight(j,i),NofModes(j,i),points_mode_id] = LargestMode_complete_alg(H_sparse_temp,W_sparse_temp,H_sparse_1D_temp,Prop_th,xbar,0.5);
            points_mode_id_all{j,i}=points_mode_id;
        end
        disp(i)
    end
    FileNameSave=strcat("Data_A",num2str(Ai),"_mode");
    save(FileNameSave,'LargestModeWeight','NofModes','points_mode_id_all')
end
