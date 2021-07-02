function min_ridge_val = RidgeMin(point_from_ind, point_to_ind, H_sparse, W_sparse, neighbours_ind)
%This function is about calculating the smallest point on a "ridge" path between two
%points by going from one point to the other on a strictly monotonic
%(always getting closer) locally maximal (thus going on a ridge) path

point_from_sub = H_sparse(point_from_ind,:);
point_to_sub = H_sparse(point_to_ind,:);
%it was: distance=norm(point_from_sub-point_to_sub,2);
distance_vec=abs(point_from_sub-point_to_sub);
min_ridge_val=min(W_sparse([point_from_ind, point_to_ind]));

if norm(distance_vec,2)==0
    min_ridge_val=0;
else
    while norm(distance_vec,2) > 1 %it was: distance>1
        %% possible neighbours
        neighbours_ind_curr=neighbours_ind(point_from_ind,:);
        neighbours_ind_curr=neighbours_ind_curr(neighbours_ind_curr>0);
        neighbours_sub_curr=H_sparse(neighbours_ind_curr,:);
        %requirement to get closer, it was: valid_neighbours_local_ind =
        %distance >norm(point_to_sub-neighbours_sub_curr,2);
        valid_neighbours_local_ind = all(distance_vec+0.1 > abs(point_to_sub-neighbours_sub_curr),2) & norm(distance_vec,2)>vecnorm((point_to_sub-neighbours_sub_curr)')';
        if sum(valid_neighbours_local_ind)==0 %weaker condition if the condition above is too strict (next step is closer in all dimensions)
            valid_neighbours_local_ind = norm(distance_vec,2)>vecnorm((point_to_sub-neighbours_sub_curr)')';
        end
        neighbours_ind_curr=neighbours_ind_curr(valid_neighbours_local_ind);
        if isempty(neighbours_ind_curr)
            min_ridge_val=0;
            break
        else        
            neighbours_sub_curr=H_sparse(neighbours_ind_curr,:);

            %% choosing next ridge point and chacking for minimal value
            [max_neighbour_val,max_neighbour_ind]=max(vecnorm(W_sparse(neighbours_ind_curr),2,2));
            point_from_ind=neighbours_ind_curr(max_neighbour_ind);
            point_from_sub=neighbours_sub_curr(max_neighbour_ind,:);
            min_ridge_val=min(min_ridge_val,max_neighbour_val);
    % it was:     distance=norm(point_from_sub-point_to_sub,2);
            distance_vec=abs(point_from_sub-point_to_sub);
        end
    end
end