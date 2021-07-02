%% This code generates data for plotting dwell times of toggle switch for different k and xbar parameters
clear all
clc

%% Simulation length
% Nsteps=200000;
% Nrealisations=100;
Nsteps=5000;
Nrealisations=10;


%% System parameters
Nspecies=2; %number of species
W=[0 -1; -1 0]; % connectivity between species

%% equilibria and rate constants considered in the analysis
xbar_vec=2:4:18;
Nxbar=length(xbar_vec);
rate_const_vec=[0.01, 0.04, 0.07, 0.1, 0.13];
Nrate_const=length(rate_const_vec);

%% output variable allocation
H_sparse_all=cell(Nrate_const,Nxbar);
W_sparse_all=cell(Nrate_const,Nxbar);
X_all=cell(Nrate_const,Nxbar);
T_all=cell(Nrate_const,Nxbar);

for j=1:Nrate_const
    rng(1)
    tic       
    %% System parameters
    rate_constants = GenConstants_EI(rate_const_vec(j), W);
    for xbar_ind=1:Nxbar
        xbar_val=xbar_vec(xbar_ind);
        xbar=xbar_val*ones(Nspecies,1);
        %% Simulation
        [X,T] = Gillespie_EI(xbar,rate_constants,Nsteps,Nrealisations);
        %% Sparse Distribution
        [H_sparse_all{j,xbar_ind},WW_sparse,~,~]= Sparse_Distribution_EI(X,T);
        W_sparse_all{j,xbar_ind} = WW_sparse./sum(WW_sparse);
        X_all{j,xbar_ind}=X;
        T_all{j,xbar_ind}=T;
        disp([j xbar_ind])
        toc
    end
end

SaveFileName=strcat('Data_dwell_time_distr.mat');
save(SaveFileName,'H_sparse_all','W_sparse_all','rate_const_vec','xbar_vec','Nsteps','Nrealisations')

%% if the next lines come back with a warning then try to save X_all and T_all manually, overwriting the size limit for saving variables
SaveFileName2=strcat('Data_dwell_time_X.mat');
save(SaveFileName2,'X_all');
SaveFileName2=strcat('Data_dwell_time_T.mat');
save(SaveFileName2,'T_all');
