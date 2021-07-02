%%
clc 
clear all
close all

N_lambda=5;
epsilon=1e-4;
x_bar=2;
k=0.01;
lambda_vec=10.^linspace(0,-3,N_lambda);
NWvec=[15,32,9,16,10,8,4];
for Ai=1:7
    NW=NWvec(Ai);
    for l=1:NW
        W_temp=W_list(3,Ai);
        W=W_temp{l};
        for i=1:N_lambda
            lambda = lambda_vec(i);
            [~,Cov_LNA{i,l},P_out(i,l)] = automatic_LNA(k,x_bar,W,epsilon,lambda);
        end
    end
    FileName=strcat('Data_A',num2str(Ai),'_LNA','.mat'); 
    save(FileName,'Cov_LNA','P_out')
    clear Cov_LNA P_out W W_temp
end
