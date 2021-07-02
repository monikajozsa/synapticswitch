function points_id = Sparse_Distribution_pointer_point_ID(H_sparse_1D,W_sparse,local_max_ind, neighbours_val,neighbours_ind,max_neighbour_ind_nb)

Npoints=size(H_sparse_1D,1);
points_id=zeros(Npoints,1);
points_id(local_max_ind)=(1:length(local_max_ind))';

neighbours_ind_full=[(1:Npoints)' neighbours_ind];
max_neighbour_full_mtx_ind=sub2ind(size(neighbours_ind_full),(1:Npoints)',max_neighbour_ind_nb);
max_neighbour_ind_gl=neighbours_ind_full(max_neighbour_full_mtx_ind); % this is the maximum neighbour for all the points!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pointer algorithm: if a max neighbour of a point was labeled in the last round then label the point with the neighbour's ID
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
old_id_ind=local_max_ind;
max_it=100000;
current_it=1;
past_fill=sum(points_id==0)+1;
current_fill=sum(points_id==0);
while current_fill>0 && current_fill<past_fill && current_it<max_it
    past_fill=sum(points_id==0);
    [a_ismem,b_ismem]=ismember(max_neighbour_ind_gl,old_id_ind);
    new_id_ind=setdiff(find(a_ismem),old_id_ind);
    points_id(new_id_ind)=points_id(old_id_ind(b_ismem(new_id_ind)));
    old_id_ind=new_id_ind;
    current_fill=sum(points_id==0);
    current_it=current_it+1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Old algorithm: just in case we missed isolated points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sum(points_id==0)>0
    In_progress=1;
    max_it=size(H_sparse_1D,1);
    it=1;
    neighbours_val=[W_sparse neighbours_val];
    path_ind=[];
    while In_progress && it<max_it
        Active_point=find(points_id==0,1);
        path_ind=Active_point;
        if Active_point
            Climbing=1;
            while Climbing
                loc_neighbours_ind=find(neighbours_ind_full(Active_point,:)>0); %find neighbouing grid points that were visited during simulation
                [~,temp]=max(neighbours_val(Active_point,loc_neighbours_ind));
                max_neighbour_loc_ind=loc_neighbours_ind(temp); 
                max_neighbour_ind=neighbours_ind_full(Active_point,max_neighbour_loc_ind);
                if points_id(max_neighbour_ind)==0
                   path_ind=[path_ind;max_neighbour_ind];
                   Active_point=max_neighbour_ind;
                   it=it+1;
                else
                   points_id(path_ind)=points_id(max_neighbour_ind);
                   Climbing=0;
                   path_ind=[];
                end
            end
        else
            In_progress=0;
        end
    end
end