%% LNA computation and Probability outside positive orthant - 2D symmetric case

clc
clear all
close all

Data_FileName_vec=["Data_II_sym","Data_IE_sym","Data_EE_sym"];


for sys_type=1:3
    
    load(Data_FileName_vec(sys_type))
    
    for rate_const_ind=1:size(rate_const_interval_vec,2)
        
        k=rate_const_interval_vec(rate_const_ind);
        epsilon=1e-4;
        
        for i=1:size(xbar_vec,2)
            x_bar=xbar_vec(i);
            [~,Cov_LNA{rate_const_ind,i},P_out(rate_const_ind,i)] = automatic_LNA(k,x_bar,W,epsilon);
        end
    end
    
    FileName=strcat(Data_FileName_vec(sys_type),'_LNA');
    FileName=strcat(FileName,'.mat');   
    save(FileName,'Cov_LNA','P_out')
end

%% LNA computation and Probability outside positive orthant - 2D asymmetric case


clc
clear all
close all

Data_FileName_vec=["Data_II_asym","Data_IE_asym","Data_EE_asym"];
k_12=0.055;

for sys_type=1:3
    
    load(Data_FileName_vec(sys_type))
    
    for rate_const_ind=1:size(rate_const_interval_vec,2)
        
        k=rate_const_interval_vec(rate_const_ind);
        epsilon=1e-4;
        
        for i=1:size(xbar_vec,2)
            x_bar=xbar_vec(i);
            [~,Cov_LNA{rate_const_ind,i},P_out(rate_const_ind,i)] = automatic_LNA([0 k; k_12 0],x_bar,W,epsilon);
        end
    end
    
    FileName=strcat(Data_FileName_vec(sys_type),'_LNA');
    FileName=strcat(FileName,'.mat');   
    save(FileName,'Cov_LNA','P_out')
end
