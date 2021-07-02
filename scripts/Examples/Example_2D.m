
%% Example code for network of two species (2D case)
clc
clear all
close all

Nspecies=2; % number of species in the network
N_steps=100000; % number of steps for each trajectory generated with Gillespie's algorithm
N_realisations=100; % number of different realisations generated for the process

xbar=10; % macroscopic size of the system (or equivalently equilibrium point of the RRE)

rate_const=0.1; % value of the rate constant k in the birth rates of the network

%% architectures : I-I, I-E, E-E
W_all=W_list(Nspecies); % list of possible architectures for the 2D case

connectivity=1; % select the type of connectivity in the  2D newtowrk: 1 - II; 2 - IE; 3 - EE;
W=W_all{connectivity}; % corresponding connectivity matrix (see W_list for more info)

[rate_constants] = GenConstants_EI(rate_const,W); % generates the rates of the newtork

% Gillespie's implementation: N_realisations different trajectories of lenght N_steps (uses parallel computing)
[X,T] = Gillespie_EI(xbar*ones(Nspecies,1),rate_constants,N_steps,N_realisations); 

% Compute the empirical distribution given the generated trajectories
[H_sparse,W_sparse,H_sparse_1D]= Sparse_Distribution_EI(X,T);

%% Plot the empirical stationary distribution of the 2D network
figure
Plot_stationary_distrib(H_sparse,W_sparse,2)

%% Computation of the number of modes in the empirical stationary distribution

Prop_th=0.001; % threshold for cutting the points with probability less than Prop_th (speeds up the computation)

% estimates the number of modes of the empirical distribution and their position
[~,NofModes,points_mode_id_sparse] = LargestMode_complete_alg(H_sparse,W_sparse,H_sparse_1D,Prop_th,xbar);

NofModes % number of modes
% ignore points with probability smaller than Prop_th
cut_ind_gl=W_sparse>max(W_sparse)*Prop_th;
W_sparse=W_sparse(cut_ind_gl);
W_sparse=W_sparse/sum(W_sparse);
H_sparse=H_sparse(cut_ind_gl,:);
H  = Marginal_Sparse_to_grid(H_sparse,W_sparse,[1 2]);
[xmax,ymax]=size(H);
x_axis=(0:(xmax-1));
y_axis=(0:(ymax-1));      
points_mode_id_mat  = Marginal_Sparse_to_grid(H_sparse,points_mode_id_sparse,[1 2]);

%% Plot the empirical stationary distribution with different colours for each mode
figure
mesh(x_axis,y_axis,H',points_mode_id_mat','FaceAlpha',1,'EdgeColor','none','FaceColor','flat');
set(gca,'FontSize',20)
set(gca, 'FontName', 'Helvetica')
set(gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [.02 .02], ...
'XMinorTick', 'off', 'YMinorTick', 'off', ...
'XColor', [.3 .3 .3], 'YColor', [.3 .3 .3],  ...
'LineWidth', 1)
ax = gca;
ax.YRuler.Exponent = 0;
xlabel('$x_1$','Interpreter','Latex','FontSize',25);
ylabel('$x_2$','Interpreter','Latex','FontSize',25);
zlabel('$\hat{P}^s$','Interpreter','Latex','FontSize',25);
set(get(gca,'ZLabel'),'Rotation',0)
axis tight
