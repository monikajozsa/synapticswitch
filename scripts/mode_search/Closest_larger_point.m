function [D_vec, clp_ind] = Closest_larger_point(local_max_sub,local_max_val,selected_ind)

%% This function calculates the closest larger local max among the selected local max 
%
% Inputs: local_max_sub - coordinates of local max
%         local_max_val - values of local max
%         selected_ind - indeces of the local max that can be considered as a
%                        closest larger local max
% Outputs: D_vec - distance from the closest larger local max; 
%                 vector with length of local_max_val, so the number local max
%         clp_ind - closest larger loc max index - indexing is on the level 
%                   of the local max, it takes values from selected_ind

D_mat = dist(local_max_sub');
Relation_loc_max = local_max_val>local_max_val';
if ~isempty(Relation_loc_max)
    D_mat(~Relation_loc_max)=NaN;% we do not want to consider these distances except for the global max which is handled next
end

if exist('selected_ind','var') %if there are given selected indices for the larger local max
    D_mat=D_mat(selected_ind,:);
    [D_vec,clp_ind]=min(D_mat,[],1,'omitnan'); %distance vector and closest larger point
    clp_ind=selected_ind(clp_ind);
else
    [D_vec,clp_ind]=min(D_mat,[],1,'omitnan'); %distance vector and closest larger point
end

[~,max_ind]=max(local_max_val);
D_vec(max_ind)=max(D_vec)+1;
clp_ind(max_ind)=max_ind;

end