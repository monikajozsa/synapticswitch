function H  = Marginal_Sparse_to_grid(H_sparse,W_sparse,ind_1_2)
% this function gives back a non-sparse distribution from a sparse
% distribution; if the sparse distribution was 3 dimensional, then it gives
% back a marginal on the dimensions in ind_1_2
if ~exist('ind_1_2','var')
    ind_1_2=[1 2];
    disp('Sparse distribution is converted to grid-based distribution along dimension 1 and 2.')
end
H_sparse_marg=H_sparse(:,ind_1_2);
max_i=max(H_sparse_marg(:,1));
max_j=max(H_sparse_marg(:,2));
H=zeros(max_i,max_j);
for i=1:max_i
    ind_i=find(H_sparse_marg(:,1)==i);
    for j=1:max_j
        ind_ij=H_sparse_marg(ind_i,2)==j;
        try
            H(i,j)=sum(W_sparse(ind_i(ind_ij)));
        catch
            %disp('hello')
        end
    end
end
    
end
