%% Data generation for 3D symmetric inhibitory systems
clear all
clc

warning ('off','all')
Nspecies=3;
N_steps=500000; % number of steps per realization (step=chemical raction)
N_realisations=50; % minimum number of realizations - note that it slightly changes with the equilibrium
NA=7; % Number of architectures to be tested (only inhibitory at the moment)

%% equilibrium point to be tested
xbar_min=2;
xbar_max=40;%could be 100 and the rates could be maybe smaller to have more multimodal cases
xbar_vec=xbar_min:3:xbar_max;
N_xbar=length(xbar_vec);

%% rate constants to be tested
max_rate_const=0.1;
min_rate_const=0.01;
nrate_const=10;
rate_const_all=linspace(min_rate_const,max_rate_const,nrate_const+1);

for i=1:NA
    Wall=W_list(Nspecies,i);
    W=Wall{1};
    for j=1:nrate_const
        rng(1)
        runtime=tic;       
        %% System parameters and architecture
        k=rate_const_all(j);
        if i==NA %in order to see robust multimodality, we needed smaller k for the repressilator (architecture 7)
            k=k/5;
        end
        [rate_constants] = GenConstants_EI(k,W);

        %% Simulation
        H_sparse=cell(N_xbar,1);
        H_sparse_1D=cell(N_xbar,1);
        W_sparse=cell(N_xbar,1);
        for l=1:N_xbar
            xbar_ind=xbar_vec(l);
            %% Simulation - change in length as xbar grows (it is multiplied by x_bar_ind)
            N_real=N_realisations+min(max(3,l),15)*3;
            [X,T] = Gillespie_EI(xbar_ind*ones(Nspecies,1),rate_constants,N_steps,N_real);
            %% Sparse Distribution
            [H_sparse{l},WW_sparse,H_sparse_1D{l},max_XX]= Sparse_Distribution_EI(X,T);
            W_sparse{l} = WW_sparse./sum(WW_sparse);
            clear('X','T','WW_sparse')
        end
        disp([i, j])
        toc(runtime)
        temp=sprintf('%g',rate_const_all(j));
        FileName=strcat('Data_A',num2str(i),'_k_',num2str(temp));
        FileName=strrep(FileName,'.','');
        FileName=strcat(FileName,'.mat');
        save(FileName,'H_sparse','W_sparse','W','H_sparse_1D','k','xbar_vec','N_steps','N_real')
     end
end