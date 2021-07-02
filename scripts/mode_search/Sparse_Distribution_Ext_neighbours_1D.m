function [neighbours_1D, neighbours_val, neighbours_ind] = Sparse_Distribution_Ext_neighbours_1D(H_sparse_1D,W_sparse,grid_max)
    %% This function gives back the 1D-coded coordinates of the neighbours of grid_point
    
    Npoints=size(H_sparse_1D,1);
    Ndigits=ceil(log10(max(10,abs(grid_max+1))));%% we need max_XX+1 because we will deal with the neaighbouring points
    Npowers=flip(cumsum(flip(Ndigits)));
    Npowers=[Npowers(2:end) 0];
    Powers=10.^Npowers;
    
    %% add +-1 in each dimension
    Directions_temp = LogMat(length(grid_max),[-1 0 1]');
    Directions = Directions_temp(sum(abs(Directions_temp),2)~=0,:);
    Neighbour_directions_1D=Directions*(Powers');
    neighbours_1D=H_sparse_1D+ones(Npoints,1).*(Neighbour_directions_1D)';
    ind_temp=neighbours_1D<=0;
    neighbours_1D(ind_temp)=0;
        
    %% find value of neighbours
    neighbours_val=zeros(size(neighbours_1D));
    neighbours_ind=zeros(size(neighbours_1D));
    for i=1:size(neighbours_1D,2)
        [a,b]=ismember(neighbours_1D(:,i),H_sparse_1D);
%         neighbours_ind(:,i)=b;
        b2=b(b>0);
        neighbours_val(a,i)=W_sparse(b2);
        neighbours_ind(a,i)=b2;
    end
end
