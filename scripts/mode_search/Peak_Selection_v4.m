function [peaks_sub, peaks_val, peaks_ind, peaks_from_local_max_ind] = Peak_Selection_v4(local_max_sub, local_max_val, local_max_ind, H, W, neighbours_ind, maxNmodes, CoordScale_for_dist)

if ~exist('maxNmodes','var')
    maxNmodes=size(local_max_sub,2)+1;
end
if size(local_max_val,1)==1
    peaks_sub=local_max_sub;
    peaks_val=local_max_val;
    peaks_from_local_max_ind=local_max_ind;
    [~,peaks_ind]=max(local_max_val);
else
    %% Distance from closest larger local maximum
    [Weighted_Cov, Weighted_Mean] = Sparse_Distribution_weighted_cov(H,W);
    [eigvec,eigval]=eig(Weighted_Cov);
    local_max_sub_norm=(local_max_sub-Weighted_Mean)*eigvec/((CoordScale_for_dist*sqrt(eigval)+(1-CoordScale_for_dist)*eye(size(H,2))));       
    Dist_loc_max = dist(local_max_sub_norm');
    Relation_loc_max = local_max_val>local_max_val';
    Dist_loc_max(~Relation_loc_max)=NaN;% we do not want to consider these distances except for the global maximum which is handled next
    [~,global_max_ind]=max(local_max_val); %index for the global maximum
    Dist_loc_max(global_max_ind,global_max_ind)=nanmax(Dist_loc_max(:));%distance between the global maximum and other local maxima are set to the maximum distance
    [loc_max_dist, clp_ind]=nanmin(Dist_loc_max);
    %% Min value along ridges between local maxima
    Valley_vec=zeros(length(local_max_val),1);
    for i=1:length(local_max_val)
        point_from_ind=local_max_ind(i);
        temp_ind=local_max_ind==local_max_ind(i);
        point_to_ind=local_max_ind(clp_ind(temp_ind));
        try
            Valley_vec(i)=RidgeMin(point_from_ind, point_to_ind, H, W, neighbours_ind);
        catch
            disp(i)
        end
    end
    VALLEY_measure=1-Valley_vec./local_max_val;
    VALLEY_measure(global_max_ind)=1;%global max gets the best "score" so that we keep it as a peak, this line should not be necessary
    DISTxVALxVALLEY=(local_max_val/max(local_max_val))'.*((loc_max_dist+0.00001)/max([1 loc_max_dist])).*(VALLEY_measure');    
    %% Added later: only consider modes where the valley is at least 30% of the smaller peak
    % THESE THRESHOLDS MIGHT NOT BE OPTIMAL
    VALLEY_TH=0.3;
    deep_enough_ind=find(VALLEY_measure > VALLEY_TH);
    peaks_ind=deep_enough_ind;
    if isempty(peaks_ind)
        [~,peaks_ind]=max(DISTxVALxVALLEY);
    end
    if length(peaks_ind)>maxNmodes
        [~,peaks_sort_ind]=sort(-DISTxVALxVALLEY(peaks_ind));
        peaks_ind=peaks_ind(peaks_sort_ind);
        peaks_ind=peaks_ind(1:maxNmodes);
    end
    peaks_sub=local_max_sub(peaks_ind,:);
    peaks_val=local_max_val(peaks_ind); 
    peaks_from_local_max_ind=local_max_ind(peaks_ind);
    %sort by value
    [~, val_sort_ind]=sort(-peaks_val);
    peaks_sub=peaks_sub(val_sort_ind,:);
    peaks_val=peaks_val(val_sort_ind);
    peaks_from_local_max_ind=peaks_from_local_max_ind(val_sort_ind);
end
end