function [Weighted_Cov,Weighted_Mean] = Sparse_Distribution_weighted_cov(H_sparse,W_sparse, Weighted_Mean)

%% Computes the weighted covariance matrix of the probability distribution
%
% Inputs: H_sparse - state-space coordinates 
%         W_sparse - probability distribution 
%         Weighted_Mean - weighted mean
% Output: Weighted_Cov - weighted covariance (covariance matrix) of the 
%                        empirical distribution W

[Npoints, x_dim]=size(H_sparse);
W_sparse=W_sparse./sum(W_sparse);

if ~exist('Weighted_Mean','var')
    Weighted_Mean = Sparse_Distribution_weighted_mean(H_sparse,W_sparse)';
end

Weighted_Cov=zeros(x_dim);
for i=1:Npoints
    Weighted_Cov=Weighted_Cov+W_sparse(i)*(H_sparse(i,:)-Weighted_Mean)'*((H_sparse(i,:)-Weighted_Mean));
end

end