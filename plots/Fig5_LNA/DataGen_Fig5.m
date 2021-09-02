Nspecies=2;
k=0.2;
n=5;

epsilon=1e-4;
Wall = W_list(Nspecies);

N_steps=100000;
N_realisations=100;
tic
W=Wall{1};
rate_constants = GenConstants_EI(k, W);
[X,T] = Gillespie_EI([n;n],rate_constants,N_steps,N_realisations);
[H,WW] = Sparse_Distribution_EI(X,T);
[Cov_II, Mean_II] = Sparse_Distribution_weighted_cov(H,WW);
[Mean_II_LNA,Cov_II_LNA,P_out_II] = automatic_LNA(k,n,W,epsilon);
toc
tic
W=Wall{2};
rate_constants = GenConstants_EI(k, W);
[X,T] = Gillespie_EI([n;n],rate_constants,N_steps,N_realisations);
[H,WW] = Sparse_Distribution_EI(X,T);
[Cov_IE, Mean_IE] = Sparse_Distribution_weighted_cov(H,WW);
[Mean_IE_LNA,Cov_IE_LNA,P_out_IE] = automatic_LNA(k,n,W,epsilon);
toc
tic
W=Wall{3};
rate_constants = GenConstants_EI(k, W);
[X,T] = Gillespie_EI([n;n],rate_constants,N_steps,N_realisations);
[H,WW] = Sparse_Distribution_EI(X,T);
[Cov_EE, Mean_EE] = Sparse_Distribution_weighted_cov(H,WW);
[Mean_EE_LNA,Cov_EE_LNA,P_out_EE] = automatic_LNA(k,n,W,epsilon);
toc
save('Data_Fig5.mat');
