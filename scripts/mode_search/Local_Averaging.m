function [W_sparse_filt,local_max_sub, local_max_val,local_max_ind, neighbours_1D, neighbours_val, neighbours_ind, max_neighbour_local_ind] = Local_Averaging(W_sparse,H_sparse,H_sparse_1D,neighbours_val)

neighbours_val(neighbours_val==0)=NaN;
neighbours_full=[W_sparse neighbours_val];
W_sparse_filt=mean(neighbours_full,2,'omitnan');
W_sparse_filt=W_sparse_filt/sum(W_sparse_filt);
[local_max_sub, local_max_val,~,local_max_ind, neighbours_1D, neighbours_val, neighbours_ind, max_neighbour_local_ind] = Sparse_Distribution_Ext_local_max_1D(H_sparse,W_sparse_filt,H_sparse_1D); 

end