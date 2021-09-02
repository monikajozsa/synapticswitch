%% The goal of this code is to find suitable equilibrium points and parameters for each relevant architecture from W_list = W_list(Nspecies,nIE)
clear all
clc

warning ('off','all')
%%Interesting case: Nspecies=2, rIE=0.5, xbar=2, max_rate_const=0.05;
Nspecies=2;
N_steps=1000000;%5 could be 10!!!
N_realisations=100;
rIE=1;

%% Architecture to be tested (only inhibitory at the moment)
W_all = W_list(Nspecies,rIE);
W=W_all{1};
        
%% equilibrium point to be tested
xbar_min=2;
xbar_max=40;%could be 100 and the rates could be maybe smaller to have more multimodal cases
xbar_vec=xbar_min:2:xbar_max;
N_xbar=length(xbar_vec);

%% rate constants to be tested
max_rate_const=0.1;
min_rate_const=0.01;
nrate_const=20;
rate_const_interval_all=linspace(min_rate_const,max_rate_const,nrate_const+1);
rate_const_interval_vec=rate_const_interval_all([3,8,20]);
nrate_const=3;

%% Continue from here;

for j=1:nrate_const
    rng(1)
    runtime=tic;       
    %% System parameters and architecture
    rate_constants = GenConstants_EI(rate_const_interval_vec(j),W);

    %% Simulation and mode detection
    H_sparse_all=cell(N_xbar);
    W_sparse_all=cell(N_xbar);
    H_sparse_1D_all=cell(N_xbar);
    for k=1:N_xbar
        xbar_ind=xbar_vec(k);
        %% Simulation - change in length as xbar grows (it is multiplied by x_bar_ind)
        N_real=N_realisations+min(max(3,k),15)*3;
        [X,T] = Gillespie_EI(xbar_ind*ones(Nspecies,1),rate_constants,N_steps,N_real);
        %% Sparse Distribution
        [H_sparse_all{k},WW_sparse,H_sparse_1D_all{k},max_XX]= Sparse_Distribution_EI(X,T);
        W_sparse_all{k} = WW_sparse./sum(WW_sparse);
        clear('X','T','WW_sparse')
        disp([j, xbar_ind])
        toc(runtime)
    end
    temp=sprintf('%g',rate_const_interval_all(j));
    FileName=strcat('Data_rate_const_',num2str(temp));
    FileName=strcat(FileName,'.mat');
    %% uncomment line below to save data
%     save(FileName,'H_sparse_all','W_sparse_all','W','H_sparse_1D_all','rate_const_interval','xbar_vec','N_steps','N_real')
end
