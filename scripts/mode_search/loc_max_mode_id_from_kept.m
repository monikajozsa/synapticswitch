function loc_max_mode_id = loc_max_mode_id_from_kept(loc_max_mode_id,local_max_sub,kept_lmax_ind,clp_pointer)

%% Iteratively copy the mode id from the already assigned local max (kept)
copy_from_ind=kept_lmax_ind;

while ~isempty(copy_from_ind)
    all_copy_to_ind=[];  
    for i=1:length(copy_from_ind)
        filled_loc_max_id=find(loc_max_mode_id~=0);
        copy_to_ind=find(clp_pointer==copy_from_ind(i));
        copy_to_ind=setdiff(copy_to_ind,filled_loc_max_id);
        %%this is a new line! I need to test if it generates any bug
        %copy_to_ind=setdiff(copy_to_ind,copy_from_ind);
        if ~isempty(copy_to_ind) && loc_max_mode_id(copy_from_ind(i))>0
            loc_max_mode_id(copy_to_ind)=ones(1,length(copy_to_ind))*loc_max_mode_id(copy_from_ind(i));
            all_copy_to_ind=[all_copy_to_ind copy_to_ind];
        end
    end
    empty_loc_max_id=find(loc_max_mode_id==0);
    copy_from_ind=all_copy_to_ind;
end

%% Fill up the rest of loc_max_mode_id by simply copying the mode id from the nearest loc max
empty_loc_max_id=find(loc_max_mode_id==0);
if ~isempty(empty_loc_max_id)
   filled_loc_max_id=find(loc_max_mode_id~=0);
   for i=1:length(empty_loc_max_id)
       [~,copy_ind]=min(vecnorm(local_max_sub(empty_loc_max_id(i),:) - local_max_sub(filled_loc_max_id,:),2,2));
       try
        loc_max_mode_id(empty_loc_max_id(i),:)=loc_max_mode_id(filled_loc_max_id(copy_ind),:);       
       catch
           disp('Something went wrong in function loc_max_mode_id_from_kept')
       end
   end
end
    
end