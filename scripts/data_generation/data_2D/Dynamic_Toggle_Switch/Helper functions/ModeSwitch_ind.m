function [avgswitch_ind, avgduration_ind] = ModeSwitch_ind(Xbar_change,N_realisations)

switch_ind=zeros(N_realisations,1);
duration_ind=zeros(N_realisations,1);
ind_start_vec=0;

for i=1:N_realisations
    Data_temp=Xbar_change{i};
    if ~isempty(Data_temp)
        ind_vec=Data_temp(:,3);
        diff_ind_vec=diff(ind_vec);
        j=1;
        next_start_ind=find(diff_ind_vec==1,1);
        while next_start_ind>0
            ind_start_vec(j)=ind_vec(next_start_ind);
            next_start_ind=next_start_ind+find(diff_ind_vec(next_start_ind:end)~=1,1);
            next_start_ind=next_start_ind+find(diff_ind_vec(next_start_ind:end)==1,1)-1;
            if isempty('next_start_ind')
                next_start_ind=0;
            end
            j=j+1;
        end
        switch_ind(i)=length(ind_start_vec);
        duration_ind(i) = mean(diff([ind_start_vec-1, ind_vec(end)]));   
    end
end
avgswitch_ind=mean(switch_ind);
avgduration_ind=mean(duration_ind);