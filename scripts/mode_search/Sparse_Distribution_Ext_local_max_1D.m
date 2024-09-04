function [local_max_sub, local_max_val,local_max_1D, local_max_ind, neighbours_1D, neighbours_val, neighbours_ind, max_neighbour_local_ind] = Sparse_Distribution_Ext_local_max_1D(H_sparse,W_sparse,H_sparse_1D)


%% Computation of local maxima and neighbour matrices
% Inputs: H_sparse -  state-space coordinates with probability
%                     greater than 0, with coordinates in original form (dimensions: number of points x number of species)
%         W_sparse - probability of state-space points with probability
%                    greater than 0 (dimensions: number of points)
%         Hsparse_1D - state-space coordinates with probability
%                      greater than 0, with coordinates encoded in 1D (dimensions: number of points)
% Output: local_max_sub - coordinates of local maxima
%         local_max_val - coordinates of local maxima
%         local_max_1D - coordinates of local maxima with coordinates encoded in 1D
%         local_max_ind - indices of local maxima
%         neighbours_1D - 1D encoded coordinates of the neighbours of each
%         point (note: diagional neighbours are included, dimenstion: number of points x number of all possible neighbours)
%         neighbours_val - values of the neighbours of each point
%         (dimenstion: same as neighbours_1D)
%         neighbours_ind - indices (based on the order of points in H_sparse, W_sparse and Hsparse_1D) of the neighbours of each point
%         (dimenstion: same as neighbours_1D)
%         max_neighbour_local_ind - indices (based on the order of neighbours, see Sparse_Distribution_Ext_neighbours_1D and LogMat function) of the neighbours of each point
%         (dimenstion: same as neighbours_1D)

grid_max=max(H_sparse); %maximum coordinate visited in each dimension

%% neighbouring grid points and the index of the current grid point among them - diagional neighbours are included!
[neighbours_1D, neighbours_val, neighbours_ind] = Sparse_Distribution_Ext_neighbours_1D(H_sparse_1D,W_sparse,grid_max);

%% the local maxima are the points (represented by row indeces) where W_sparse(i)>=neighbours_val(i,:)
[~,max_neighbour_local_ind]=max([W_sparse, neighbours_val],[],2);
local_max_ind=find(max_neighbour_local_ind==1)';

local_max_sub=H_sparse(local_max_ind,:);
local_max_val=W_sparse(local_max_ind);
local_max_1D=H_sparse_1D(local_max_ind);

end
