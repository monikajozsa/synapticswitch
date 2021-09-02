function [local_max_sub, local_max_val, p_ind, p_pointer, clp_pointer, max_Nmodes] = DropingCloseLocMax(local_max_sub,local_max_val,max_Nmodes,dist_th,H,W,CoordScale_for_dist)
%% Variable names
% _sub : coordinates
% _val : value
% _ind : index
% clp : closest larger point
% dist : distance
% p_ : point

if ~exist('CoordScale_for_dist','var')
    CoordScale_for_dist=0; %this is applied most of the time: there is no scaling of point coordinates (which would be based on the covariance of the distribution) before calculating the distance between points
end

Np=length(local_max_val); %number of points
if ~exist('max_Nmodes','var')
    max_Nmodes=Np;
end

%%added on May 17
[Weighted_Cov, Weighted_Mean] = Sparse_Distribution_weighted_cov(H,W);
[eigvec,eigval]=eig(Weighted_Cov);
local_max_sub_norm=(local_max_sub-Weighted_Mean)*eigvec/((CoordScale_for_dist*sqrt(eigval)+(1-CoordScale_for_dist)*eye(size(H,2))));       
[D_vec, clp_pointer] = Closest_larger_point(local_max_sub_norm,local_max_val);

p_ind=(1:Np);
p_pointer=p_ind;

%% Drop close smaller loc max at once
dist_th=min(max(D_vec)-0.1,dist_th); %this is a technical line that handles the case when the input distance threshold is too big

rest_ind=find(D_vec>dist_th); %this handles the case when there is a lot of 1-distance loc. max and dist_th=1
drop_ind=setdiff(1:Np,rest_ind);
if length(rest_ind)<2 %this handles the case when there are only two loc max and dist_th=the only distance
    drop_ind=find(D_vec<dist_th);
    rest_ind=setdiff(1:Np,drop_ind);
end
p_pointer(drop_ind)=clp_pointer(drop_ind);
p_ind=p_ind(rest_ind);
local_max_val=local_max_val(rest_ind);
local_max_sub=local_max_sub(rest_ind,:);    

max_Nmodes=min(max_Nmodes,length(p_ind));

%% Out of use: min-by-min drop -  it was too slow when there were too many local maxima
% for iter=1:Np
%     min_dist=min(D_vec);
%     min_ind=find(D_vec==min_dist);
%     rest_ind=setdiff(1:length(p_ind),min_ind);
%     if min_dist<=dist_th 
%         p_pointer(p_ind(min_ind))=clp_ind(min_ind);
%         p_ind=p_ind(rest_ind);
%         p_val=p_val(rest_ind);
%         p_sub=p_sub(rest_ind,:);
%         [D_vec, clp_ind] = Closest_larger_point(p_sub,p_val);
%     else
%         break
%     end
% end
end
