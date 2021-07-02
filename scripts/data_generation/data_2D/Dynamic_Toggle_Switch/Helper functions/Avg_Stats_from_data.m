function [Lifetime, Survived, Death_ind, Blown_up_ind] = Avg_Stats_from_data(T,X,N_real)

Lifetime=zeros(N_real,1);
Survived=zeros(N_real,1);
Death_ind=zeros(N_real,1);
Blown_up_ind=[];
for i=1:N_real
    Ti=T(:,:,i);
    Xi=X(:,:,i);
    tend=find(isnan(Ti),1);
    if isempty(tend)
        tend=length(Ti)+1;
        Survived(i)=1;
    end
    %ith realization went off the upper limit for the processes (10.000 typically)
    if any(Xi(tend-1)>0)
        Blown_up_ind=[Blown_up_ind; i];
    end
    Lifetime(i)=Ti(tend-1);
    Death_ind(i)=tend-1;
end

