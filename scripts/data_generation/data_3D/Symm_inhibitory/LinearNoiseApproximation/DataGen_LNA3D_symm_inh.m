clc
clear all
close all

%Data_FileName_vec=["Data_II_sym","Data_IE_sym","Data_EE_sym"];
rate_const_interval_vec=[0.01 0.019 0.028 0.037 0.046 0.055 0.064 0.073 0.082 0.091];

Data_Filename_vec=["Data_A1_k_001.mat","Data_A2_k_001.mat","Data_A3_k_001.mat","Data_A4_k_001.mat","Data_A5_k_001.mat","Data_A6_k_001.mat","Data_A7_k_001.mat"];

%%
for Ai=1:7
    
    load(Data_Filename_vec(Ai))
    
    for rate_const_ind=1:size(rate_const_interval_vec,2)
        
        k=rate_const_interval_vec(rate_const_ind);
        epsilon=1e-4;
        
        for i=1:size(xbar_vec,2)
            x_bar=xbar_vec(i);
            [~,Cov_LNA{rate_const_ind,i},P_out(rate_const_ind,i)] = automatic_LNA(k,x_bar,W,epsilon);
        end
    end
    
    FileName=strcat('Data_A',num2str(Ai),'_LNA_symm_inh','.mat'); 
    save(FileName,'Cov_LNA','P_out')
end
