function points_mode_id = ModeSelection(H_sparse,W_sparse,H_sparse_1D,xbar)
plot_on=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Find Local Max and Merge %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[local_max_sub, local_max_val,local_max_1D, local_max_ind_gl, neighbours_1D, neighbours_val, neighbours_ind_gl, max_neighbour_ind_nb] = Sparse_Distribution_Ext_local_max_1D(H_sparse,W_sparse,H_sparse_1D);
W_sparse_filt=W_sparse; %if we do not want filtering

Dist_loc_max = dist(local_max_sub');
Nlocmax=length(local_max_val);
if Nlocmax > 1
    X=Dist_loc_max(Dist_loc_max>0);
%                 dist_th=median(X);
    dist_th=max(xbar/2,prctile(X,20));
else
    dist_th=0.1;
end
try
    [kept_lmax_sub, kept_lmax_val, kept_lmax_ind_lm, ~, lm2clp_pointer_lm, ~] = DropingCloseLocMax(local_max_sub,local_max_val,[],dist_th,plot_on);
catch
    disp(length(local_max_val))
    [W_sparse_filt,local_max_sub, local_max_val,local_max_ind_gl, neighbours_1D, neighbours_val, neighbours_ind_gl, max_neighbour_ind_nb] = Local_Averaging(W_sparse,H_sparse,H_sparse_1D,neighbours_val);
    try
        [kept_lmax_sub, kept_lmax_val, kept_lmax_ind_lm, ~, lm2clp_pointer_lm, ~] = DropingCloseLocMax(local_max_sub,local_max_val,[],dist_th,plot_on);
    catch
        disp(length(local_max_val))
        data_cut=max(W_sparse_filt)*2*Prop_th;
        cut_ind_gl=W_sparse_filt>data_cut;
        W_sparse_filt=W_sparse_filt(cut_ind_gl);
        W_sparse_filt=W_sparse_filt/sum(W_sparse_filt);
        H_sparse=H_sparse(cut_ind_gl,:);
        H_sparse_1D = H_to_H1D(H_sparse);
        [kept_lmax_sub, kept_lmax_val, kept_lmax_ind_lm, ~, lm2clp_pointer_lm, ~] = DropingCloseLocMax(local_max_sub,local_max_val,[],dist_th,plot_on);
        disp('number of local max after the second try')
        disp(length(local_max_val))
    end
end
kept_lmax_ind_gl=local_max_ind_gl(kept_lmax_ind_lm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Peaks based on Dist * Val %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SORT PEAKS BY VAL IN Peak_Selection!!!!
[peaks_sub, peaks_val, peaks_ind_klm, peaks_ind_gl] = Peak_Selection_v2(kept_lmax_sub, kept_lmax_val, kept_lmax_ind_gl, H_sparse, W_sparse_filt, neighbours_ind_gl);
peaks_ind_lm=kept_lmax_ind_lm(peaks_ind_klm);
loc_max_mode_id=zeros(length(local_max_val),1);
Npeaks=length(peaks_ind_klm);
loc_max_mode_id(peaks_ind_lm)=(1:Npeaks)';
[~, kept2peak_pointer_klm] = Closest_larger_point(kept_lmax_sub,kept_lmax_val,peaks_ind_klm);
copy_from_ind_klm=peaks_ind_klm;
[copy_to_ind_lm,ind_local]=setdiff(kept_lmax_ind_lm,peaks_ind_lm);
loc_max_mode_id(copy_to_ind_lm)=loc_max_mode_id(kept2peak_pointer_klm(ind_local));
loc_max_mode_id = loc_max_mode_id_from_kept(loc_max_mode_id,local_max_sub,kept_lmax_ind_lm,lm2clp_pointer_lm);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Uphill Walk - Pointer to Local Max %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
points2lm_pointer_lm = Sparse_Distribution_pointer_point_ID(H_sparse_1D,W_sparse_filt,local_max_ind_gl, neighbours_val,neighbours_ind_gl,max_neighbour_ind_nb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Clustering All Grid Points %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
points_mode_id=ones(length(points2lm_pointer_lm),1);
for i=1:length(loc_max_mode_id)
    points_mode_id(points2lm_pointer_lm==i)=loc_max_mode_id(i);
end