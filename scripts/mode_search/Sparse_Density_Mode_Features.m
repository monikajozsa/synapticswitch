function [Mode_weights,Mode_peaks,Mode_centers] = Sparse_Density_Mode_Features(H_sparse, W_sparse, points_mode_id)
%% This function is from Cluster_features_IE to suit sparse density representation
x_dim=size(H_sparse,2);
mode_id_vec=unique(points_mode_id);
Nmodes=length(mode_id_vec);

%% Centers, Weights, and Peaks
Mode_centers=zeros(Nmodes,x_dim);
Mode_weights=zeros(Nmodes,1);
Mode_peaks=zeros(Nmodes,1);

for k=1:Nmodes
    Mode_k_ind=(points_mode_id==mode_id_vec(k));
    H_sparse_mode_k=H_sparse(Mode_k_ind,:);
    W_sparse_mode_k=W_sparse(Mode_k_ind);
    Mode_weights(k)=sum(W_sparse_mode_k);
    Mode_peaks(k)=max(W_sparse_mode_k); 
    W_sparse_mode_k=W_sparse_mode_k/sum(W_sparse_mode_k);%normalizing the weight
    Mode_centers(k,:)=Sparse_Distribution_weighted_mean(H_sparse_mode_k,W_sparse_mode_k);
end

end