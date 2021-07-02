clear all
clc

%% first dimension of saved H_sparse_all, etc is rate constant! second is equilibrium
FileName_vec=["Data_II_sym","Data_IE_sym","Data_EE_sym", "Data_II_asym","Data_IE_asym","Data_EE_asym"];
for sys_type=1:6
    tic
    load(FileName_vec(sys_type));

    N_xbar=length(xbar_vec);
    nrate_const=length(rate_const_interval_vec);

    points_mode_id_all=cell(nrate_const,N_xbar);
    LargestModeWeight=zeros(nrate_const,N_xbar);
    NofModes=zeros(nrate_const,N_xbar);

    for i=1:nrate_const
        for j=1:N_xbar
            H_sparse=H_sparse_all{i,j}; 
            W_sparse=W_sparse_all{i,j};
            H_sparse_1D=H_to_H1D(H_sparse);
            Prop_th=0.01;
            xbar=xbar_vec(j);
            [LargestModeWeight(i,j),NofModes(i,j),points_mode_id] = LargestMode_complete_alg(H_sparse,W_sparse,H_sparse_1D,Prop_th,xbar);
            points_mode_id_all{i,j}=points_mode_id;
        end
    end
    FileName=strcat(FileName_vec(sys_type),'_modes');
    FileName=strcat(FileName,'.mat');   
    save(FileName,'LargestModeWeight','NofModes','points_mode_id_all')
    toc
end
