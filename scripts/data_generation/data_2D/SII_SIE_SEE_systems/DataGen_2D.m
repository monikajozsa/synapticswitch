%% first dimension of saved H_sparse_all, etc is rate constant! second is equilibrium
clear all
clc

Nspecies=2;
N_steps=100000;
N_realisations=100;

%% equilibrium point 
xbar_min=2;
xbar_max=20;
xbar_vec=xbar_min:2:xbar_max;
N_xbar=length(xbar_vec);

%% rate constants
rate_const_interval_vec=[0.1 0.09 0.08 0.07 0.06 0.05 0.04 0.03 0.02 0.01];
asymm_baseline_k=0.055;
nrate_const=length(rate_const_interval_vec);

%% architectures : I-I, I-E, E-E
W_all=W_list(Nspecies);

%% symmetric cases
FileName_vec=["Data_II_sym.mat","Data_IE_sym.mat","Data_EE_sym.mat"];

for connectivity_i=1:3 %architectures : I-I, I-E, E-E
    W=W_all{connectivity_i};
    H_sparse_all=cell(nrate_const,N_xbar);
    W_sparse_all=cell(nrate_const,N_xbar);
    H_sparse_1D_all=cell(nrate_const,N_xbar);
    xbar_all=cell(nrate_const,N_xbar);
    for j=1:nrate_const
        rng(1)
        runtime=tic;
        [rate_constants] = GenConstants_EI(rate_const_interval_vec(j),W);
        %% simulation and mode detection
        for k=1:N_xbar
            xbar_const=xbar_vec(k);
            xbar=xbar_const*ones(Nspecies,1);
            N_real=N_realisations+k*3;
            [X,T] = Gillespie_EI(xbar,rate_constants,N_steps,N_real);
            [H_sparse_all{j,k},WW_sparse,H_sparse_1D_all{j,k}]= Sparse_Distribution_EI(X,T);
            xbar_all{j,k}=xbar;
            clear('X','T','WW_sparse')
        end
        disp([connectivity_i, j])
        toc(runtime)
    end
    FileName=FileName_vec(connectivity_i);
    save(FileName,'H_sparse_all','W_sparse_all','W','rate_const_interval_vec','xbar_vec','N_steps','N_realisations')
end

%% asymmetric case
FileName_vec=["Data_II_asym.mat","Data_IE_asym.mat","Data_EE_asym.mat"];

for connectivity_i=1:3 
    W=W_all{connectivity_i};
    H_sparse_all=cell(nrate_const,N_xbar);
    W_sparse_all=cell(nrate_const,N_xbar);
    H_sparse_1D_all=cell(nrate_const,N_xbar);
    xbar_all=cell(nrate_const,N_xbar);
    for j=1:nrate_const
        rng(1)
        runtime=tic;
        [rate_constants] = GenConstants_EI(rate_const_interval_vec(j),W);
        if rate_constants.Kdenum_E(1,2)>0
            rate_constants.Kdenum_E(1,2)=asymm_baseline_k;
        end
        if rate_constants.Knum_I(1,2)>0
            rate_constants.Knum_I(1,2)=asymm_baseline_k;
            rate_constants.Kdenum_I(1,2)=asymm_baseline_k;
        end
        %% simulation and mode detection
        for k=1:N_xbar
            xbar_const=xbar_vec(k);
            xbar=xbar_const*ones(Nspecies,1);
            N_real=N_realisations+k*3;
            [X,T] = Gillespie_EI(xbar,rate_constants,N_steps,N_real);
            [H_sparse_all{j,k},WW_sparse,H_sparse_1D_all{j,k}]= Sparse_Distribution_EI(X,T);
            W_sparse_all{j,k} = WW_sparse./sum(WW_sparse);
            xbar_all{j,k}=xbar;
            clear('X','T','WW_sparse')
        end
        disp([connectivity_i, j])
        toc(runtime)
    end
    FileName=FileName_vec(connectivity_i);
    save(FileName,'H_sparse_all','W_sparse_all','W','rate_const_interval_vec','xbar_vec','N_steps','N_realisations')
end
