
%% Example code for network of two species (3D case)
clc
clear all
close all

Nspecies=3; % number of species in the network
N_steps=100000; % number of steps for each trajectory generated with Gillespie's algorithm
N_realisations=100; % number of different realisations generated for the process

xbar=2; % macroscopic size of the system (or equivalently equilibrium point of the RRE)

rate_const=0.1; % value of the rate constant k in the birth rates of the network

%% architectures: for more details see W_list.m in shared_functions folder
nA=1; 
W_nA = W_list(Nspecies,nA); % list of possible architectures for the 3D case
nA_i=1;
W=W_nA{nA_i} % corresponding connectivity matrix (see W_list for more info)
 
rate_constants = GenConstants_EI(rate_const,W); % generates the rates of the newtork

% Gillespie's implementation: N_realisations different trajectories of lenght N_steps (uses parallel computing)
[X,T] = Gillespie_EI(xbar*ones(Nspecies,1),rate_constants,N_steps,N_realisations); 

% Compute the empirical distribution given the generated trajectories
[H_sparse,W_sparse,H_sparse_1D]= Sparse_Distribution_EI(X,T);

%% Plot the empirical stationary distribution of the 2D network
figure
Plot_stationary_distrib(H_sparse,W_sparse,3)

%% Computation of the number of modes in the empirical stationary distribution

Prop_th=0.001; % threshold for cutting the points with probability less than Prop_th (speeds up the computation)

% estimates the number of modes of the empirical distribution and their position
[LargestModeWeight,NofModes,points_mode_id_sparse] = LargestMode_complete_alg(H_sparse,W_sparse,H_sparse_1D,Prop_th,xbar);

cut_ind_gl=W_sparse>max(W_sparse)*Prop_th; % ignore points with probability smaller than Prop_th
W=W_sparse(cut_ind_gl);
W=W/sum(W);
H=H_sparse(cut_ind_gl,:);


%% Plot the empirical stationary distribution with different colours for each mode
figure
point_size=130;
SizeWeight=ceil(W/max(W)*point_size);
scatter3(H(:,1),H(:,2),H(:,3),SizeWeight,points_mode_id_sparse,'filled','o','MarkerFaceAlpha',0.7);
set(gca,'FontSize',20)
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
'XMinorTick', 'off', 'YMinorTick', 'off', ...
'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
'LineWidth', 1)
ax = gca;
ax.YRuler.Exponent = 0;
set(get(gca,'ZLabel'),'Rotation',0)
xlabel('$x_1$','Interpreter','Latex','FontSize',25);
ylabel('$x_2$','Interpreter','Latex','FontSize',25);
zlabel('$x_3$','Interpreter','Latex','FontSize',25);
