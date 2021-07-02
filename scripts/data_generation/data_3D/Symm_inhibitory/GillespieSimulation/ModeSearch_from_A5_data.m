%% Here, we run the mode search algorithm (LargestMode_complete_alg) on data and save it in a separate file
% addpath(genpath('C:\Users\jozsa\Dropbox (Cambridge University)\Monika-Tim\Synaptic switch paper\Random chemical systems\Mode search'))
% addpath(genpath('C:\Users\jozsa\Dropbox (Cambridge University)\Monika-Tim\Synaptic switch paper\Random chemical systems\Gillespie_and_Distribution'))
% addpath(genpath('C:\Users\jozsa\Dropbox (Cambridge University)\Monika-Tim\Synaptic switch paper\Random chemical systems\shared functions'))
% addpath(genpath('C:\Users\jozsa\Dropbox (Cambridge University)\Monika-Tim\Synaptic switch paper\Random chemical systems\Data_2D\Data_2D_IE'))

clear all
close all
nEq=10;
nSys=13;
Prop_th=0; % this is a threshold for W_sparse
DataFile_str_vec=["Data_A5_k_001.mat",...
"Data_A5_k_0019.mat",...
"Data_A5_k_0028.mat",...
"Data_A5_k_0037.mat",...
"Data_A5_k_0046.mat",...
"Data_A5_k_0055.mat",...
"Data_A5_k_0064.mat",...
"Data_A5_k_0073.mat",...
"Data_A5_k_0082.mat",...
"Data_A5_k_0091.mat"];

DataFile_str_vec=flip(DataFile_str_vec);

points_mode_id_all=cell(nEq,nSys);
LargestModeWeight=zeros(nSys,nEq);
NofModes=zeros(nSys,nEq);
tic
for i=1:nEq
    load(DataFile_str_vec(i))
    for j=1:nSys
        H_sparse_temp=H_sparse{j};
        H_sparse_1D_temp=H_sparse_1D{j};
        W_sparse_temp=W_sparse{j};
        %[H_sparse_temp,H_sparse_1D_temp,W_sparse_temp] = Thresholding_Hsparse_Wsparse(H_sparse_temp,H_sparse_1D_temp,W_sparse_temp);
        xbar=xbar_vec(i);
        SizeWeight=(W_sparse_temp.^2)./max(W_sparse_temp.^2)*max(H_sparse_temp(:));
        try
            [LargestModeWeight(j,i),NofModes(j,i),points_mode_id] = LargestMode_complete_alg(H_sparse_temp,W_sparse_temp,H_sparse_1D_temp,Prop_th,xbar);
            points_mode_id_all{i,j}=points_mode_id;
        catch
            disp('failed')
        end
    end
    disp(i)
    toc
end
FileName="Data_A5_mode";
save(FileName,'LargestModeWeight','NofModes','points_mode_id_all')

imagesc(flip(LargestModeWeight)')
