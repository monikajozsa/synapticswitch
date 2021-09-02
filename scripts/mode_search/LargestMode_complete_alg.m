function [MaxMode,NofModes,points_mode_id,Mode_peaks,Mode_centers] = LargestMode_complete_alg(H,W,H_1D,Prop_th,xbar,CoordScale_for_dist)
    %% This is the main function for the mode-search algorithm
    %% The algorithm first focuses on finding peaks of the modes, then it allocates mode ID for all local max based on pointers to the peaks - (this is the hardest part to follow, the pointers!), the remaining grid points get mode ID based on the mode ID of local max and an up-hill algorithm
    % Steps: 
    % 1) if Prop_th>0, threshold the distribution - we discard the flat part of the
    % distribution (self-contained)
    % 
    % 2) calculate local maxima and neighbour matrices where each row represents some features ( index/coordinate/value) of the neighbours of a visited point
    % (uses Sparse_Distribution_Ext_local_max_1D)
    % 
    % 3) thresholding for distance between a local max: each loc max gets a distance measure from the closest local
    % max and if it is below a threshold then that local maximum is
    % discarded - can not be selected as mode peak 
    % (uses DropingCloseLocMax and possibly Local_Averaging - I think that
    % it always runs not and Local_Averaging is used anymore but it needs
    % to be chekced)
    %
    % 4) selecting mode peaks from the kept local max (uses Peak_Selection_v2)
    %
    % 5) giving mode IDs to all local maxima (uses Closest_larger_point and
    % loc_max_mode_id_from_kept)
    %
    % 6) giving mode ID to all grid points using uphill walk algorithm (uses Sparse_Distribution_pointer_point_ID)
    %
    % 7) getting key features of the modes such as center, weight and peak
    
    %% Illustration of coordinate scaling constant
    % Npoints=10000;
    % 
    % C=[2 1.7;1.7 2];
    % [eigvec,eigval]=eig(C);
    % 
    % R = mvnrnd([0 0],eye(2),Npoints);
    % RC = mvnrnd([0 0],C,Npoints);
    % Rrec=(RC*eigvec)*inv((sqrt(eigval)));
    % Rmix=(RC*eigvec)/((CoordScale_for_dist*sqrt(eigval)+(1-CoordScale_for_dist)*eye(2))/2);
    % 
    % figure
    % subplot(2,2,1)
    % scatter(R(:,1),R(:,2))
    % title('Points from standard normal distribution')
    % 
    % subplot(2,2,2)
    % scatter(RC(:,1),RC(:,2))
    % title('Points form non-standard normal distribution')
    % 
    % subplot(2,2,3)
    % scatter(Rrec(:,1),Rrec(:,2))
    % title('Non-standard points scaled to standard points')
    % 
    % subplot(2,2,4)
    % scatter(Rmix(:,1),Rmix(:,2))
    % title('Non-standard points partially scaled to standard points')
    
    if ~exist('CoordScale_for_dist','var')
        CoordScale_for_dist=0; %this is applied most of the time: there is no scaling of point coordinates (which would be based on the covariance of the distribution) before calculating the distance between points
    end
    %% Step 1
    Nspecies=size(H,2);
    if Prop_th>0
        cut_prctile=20;
        data_cut=max(max(W)*Prop_th,prctile(W,cut_prctile));
        cut_ind_gl=W>data_cut;
        W_save=W;
        H_save=H;
        H_1D_save=H_1D;
        W=W(cut_ind_gl);
        W=W/sum(W);
        H=H(cut_ind_gl,:);
        H_1D_to_compare = H_1D(cut_ind_gl);
        H_1D=H_to_H1D(H);
    else
        W_save=W;
        H_save=H;
        H_1D_save=H_1D;
        H_1D_to_compare=H_1D;
    end
    
    %% Step 2
    [local_max_sub, local_max_val,~, local_max_ind_gl, ~, neighbours_val, neighbours_ind_gl, max_neighbour_ind_nb] = Sparse_Distribution_Ext_local_max_1D(H,W,H_1D);
    Nlocmax=length(local_max_val);
    %% to avoid memory crash, increase the threshold on W (cut_prctile) when there were too many local maxima, otherwise dist function may cause memory crash
    cut_prctile=20;
    add_to_prctile=5;    
    while Nlocmax>5000 && cut_prctile<80
        cut_prctile=cut_prctile+add_to_prctile;
        data_cut=prctile(W,cut_prctile);
        cut_ind_gl=W>data_cut;
        W=W(cut_ind_gl);
        W=W/sum(W);
        H=H(cut_ind_gl,:);
        H_1D_to_compare = H_1D_to_compare(cut_ind_gl);
        H_1D=H_to_H1D(H);
        [local_max_sub, local_max_val,~, local_max_ind_gl, ~, neighbours_val, neighbours_ind_gl, max_neighbour_ind_nb] = Sparse_Distribution_Ext_local_max_1D(H,W,H_1D);
        Nlocmax=length(local_max_val);
    end
    W_filt=W;

    %% Step 3: distance threshold for local max
    if Nlocmax > 1
        %% added on May 17
        [Weighted_Cov, Weighted_Mean] = Sparse_Distribution_weighted_cov(H,W);
        [eigvec,eigval]=eig(Weighted_Cov);
        local_max_sub_norm=(local_max_sub-Weighted_Mean)*eigvec/((CoordScale_for_dist*sqrt(eigval)+(1-CoordScale_for_dist)*eye(size(H,2))));
        [D_vec, ~] = Closest_larger_point(local_max_sub_norm,local_max_val);
%         [dist_th,~] = elbow_triangle(D_vec);
%         valid_ind=(D_vec>dist_th);
%         if length(D_vec(valid_ind)) < Nspecies+1
            dist_th=max([1,min(xbar)/10,prctile(D_vec,20)]);
            valid_ind=(D_vec>dist_th);
%         end
        if length(D_vec(valid_ind)) < Nspecies+1
        	Temp=flip(sort(D_vec));
            dist_th=Temp(min(length(Temp),Nspecies+1))-0.1;
        end
    else
        dist_th=0.1;
    end
    %% Exclude local maxima from mode peak selection that are close to a larger local maximum
%     [kept_lmax_sub, kept_lmax_val, kept_lmax_ind_lm, ~, lm2clp_pointer_lm] = DropingCloseLocMax_v2(local_max_sub,local_max_val,[],dist_th,H,W,CoordScale_for_dist);    
    [kept_lmax_sub, kept_lmax_val, kept_lmax_ind_lm, ~, lm2clp_pointer_lm] = DropingCloseLocMax(local_max_sub,local_max_val,[],dist_th,H,W,CoordScale_for_dist);
    kept_lmax_ind_gl=local_max_ind_gl(kept_lmax_ind_lm); %global indices of the remaining local maxima
    
    %% Step 4: Peak selection
    [~, ~, peaks_ind_klm, ~] = Peak_Selection_v4(kept_lmax_sub, kept_lmax_val, kept_lmax_ind_gl, H, W_filt, neighbours_ind_gl, Nspecies+1, CoordScale_for_dist);
%     [~, ~, peaks_ind_klm, ~] = Peak_Selection_v2(kept_lmax_sub, kept_lmax_val, kept_lmax_ind_gl, H, W_filt, neighbours_ind_gl);
    peaks_ind_lm=kept_lmax_ind_lm(peaks_ind_klm); %kept local max pointer to the peaks - on the level of all local max from the level of kept local max
    Npeaks=length(peaks_ind_klm);
    loc_max_mode_id=zeros(length(local_max_val),1);
    loc_max_mode_id(peaks_ind_lm)=(1:Npeaks)';
    
    %% Step 5: giving mode ID to local max
    [~, kept2peak_pointer_klm] = Closest_larger_point(kept_lmax_sub,kept_lmax_val,peaks_ind_klm);
    [copy_to_ind_lm,ind_local_lm]=setdiff(kept_lmax_ind_lm,peaks_ind_lm);
%     kept2peak_pointer_klm=setdiff(kept2peak_pointer_klm,peaks_ind_klm);
    kept2peak_pointer_lm=kept_lmax_ind_lm(kept2peak_pointer_klm);
    loc_max_mode_id(copy_to_ind_lm)=loc_max_mode_id(kept2peak_pointer_lm(ind_local_lm));
    loc_max_mode_id = loc_max_mode_id_from_kept(loc_max_mode_id,local_max_sub,kept_lmax_ind_lm,lm2clp_pointer_lm);
    
    %% Step 6: Uphill Walk - Pointer to Local Max from grid points
    points2lm_pointer_lm = Sparse_Distribution_pointer_point_ID(H_1D,W_filt,local_max_ind_gl, neighbours_val,neighbours_ind_gl,max_neighbour_ind_nb);

    points_mode_id=ones(length(points2lm_pointer_lm),1);
    for i=1:length(loc_max_mode_id)
        points_mode_id(points2lm_pointer_lm==i)=loc_max_mode_id(i);
    end

    %% Step 7: Getting Mode Features 
    if Prop_th==0 % this is to handle if the output points_mode_id should be the same size as the original dataset so including the flat part of the distribution
        points_mode_id_complete=zeros(size(H_1D_save));
        [intersect_H,tobe_filled_ind]=intersect(H_1D_save,H_1D_to_compare);
        [~,filled_from_ind]=intersect(H_1D_to_compare,intersect_H);%in case H_1D got some extra grid points
        try
            points_mode_id_complete(tobe_filled_ind)=points_mode_id(filled_from_ind);
        catch
            disp([length(tobe_filled_ind), length(filled_from_ind)])
        end
        %% If I have time, I could add some smart mode id for these ignored points missing_ind
        [Mode_weights,Mode_peaks,Mode_centers] = Sparse_Density_Mode_Features(H_save, W_save, points_mode_id_complete);
        points_mode_id=points_mode_id_complete;
    else
        [Mode_weights,Mode_peaks,Mode_centers] = Sparse_Density_Mode_Features(H, W, points_mode_id);
    end
   
    % The features we use
    MaxMode=max(Mode_weights);
    NofModes=max(points_mode_id);
end