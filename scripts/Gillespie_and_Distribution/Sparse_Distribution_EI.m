function [H_sparse,W_sparse,H_sparse_1D,max_XX] = Sparse_Distribution_EI(X,T)

%% Distribution estimation from data
% Inputs: X - NxN_stepsxN_realisations molecular numbers 
%         T - structure containing the jump times
% Output: H_sparse - values of the state-space with probability greater
%                    than 0
%         W_sparse - probability of each state in H_sparse
%         H_sparse_1D - coordinates of H_sparse merget to 1D to improve
%                       computation
%         max_XX - maximum values that the process reaches in the state-
%                  space
%
% Note: this method computes the sparse distribution, i.e it stores 
%       points with non-zero weight from time series in order to improve
%       the computation time

%% Discard realizations that had numerical issues
%%the next three lines were added because a few negative time-advance
%%happened due to numerical issues with small numbers - especially when
%%using parfor; this happened for a few (1 to 5 out of 1e5) values in one realization
%%(e.g. out of 200)
tempvar=diff(T);
valid_ind=find(sum(tempvar<0)==0);
X=X(:,:,valid_ind);
T=T(:,:,valid_ind);

%% Discard the beginning of the time series (the transients)
Xsize=size(X);
Nspecies=Xsize(1);
N_steps=Xsize(2);
if length(Xsize)>2
    N_realisations=Xsize(3);
else
    N_realisations=1;
end
N_discarded=min(floor(N_steps/2),max(1000,floor(0.01*N_steps)));
time_int=diff(T);

W_sparse_all=cell(N_realisations,1);
H_sparse_1D_all=cell(N_realisations,1);
H_sparse_all=cell(N_realisations,1);
max_XX_all=zeros(N_realisations,Nspecies);

%% distributions are calculated for each realisation and are later combined
for real_i=1:N_realisations
    try %% we use "try" because if there is only one realization then we do not need to reshape X and time_int
        XX=X(:,N_discarded:(N_steps-1),real_i)';
        WW=time_int(1,N_discarded:end,real_i);
    catch
        XX=X(:,N_discarded:(N_steps-1))';
        WW=time_int(1,N_discarded:end)';
    end

    %% Discard points with NaN values - it occurs when time series dies off or reaches upper limit
    nan_ind=isnan(XX);
    XX=reshape(XX(~nan_ind),[],Nspecies);
    WW=WW(~nan_ind(:,1));

    XX=XX+1; %% it caused more confusion to start from 0 so we start from 1

    %% One-to-one convertion of XX to XX_1D, a one dimensional vector - speeds up "unique" function
    % example: if XX(i,:)=[2,3,4] and the maximum coordinates are two digits in each dimensions of X then XX_1D(i)=20304
    max_XX=max(XX);
    Ndigits=ceil(log10(max(10,abs(max_XX+1))));%% we need max_XX+1 because we will deal with the neighbouring points later
    Npowers=flip(cumsum(flip(Ndigits)));
    invNpowers=[-Npowers(2:end) 0];
    Npowers=[Npowers(2:end) 0];
    XX_powers=XX.*10.^Npowers;
    XX_1D=sum(XX_powers,2);

    %% 1-dimensional sparsely stored support of the distribution
    [H_sparse_1D_i,~,IC]=unique(XX_1D); % store only the visited grid points (in 1D)
    %% Nspecies-dimensional sparsely stored support of the distribution
    H_sparse=zeros(length(H_sparse_1D_i),Nspecies);% convert 1D sparse distribution back to Nspecies-dimension
    H_sparse_1D_temp=H_sparse_1D_i;
    for i=1:Nspecies
        try
            coord_i=floor(H_sparse_1D_temp*10^invNpowers(i));
            H_sparse(:,i)=coord_i;
            H_sparse_1D_temp=H_sparse_1D_temp-10^Npowers(i)*coord_i;
            if any(H_sparse(:,i)>100000)
                disp("H_sparse has too large value in Sparse_Distribution_EI - check the simulated process")
            end
        catch
            disp("Error in Sparse_Distribution_EI -  check for NaN values in the simulated process")
            break
        end
    end
    H_sparse_all{real_i}=H_sparse;
    %% Probability weight = time spent in a state
    W_sparse_i = accumarray(IC,WW);
    W_sparse_all{real_i} = W_sparse_i;
    %% maximum values along the axes
    max_XX_all(real_i,:)=max_XX;
end
max_XX=max(max_XX_all);

%% combining distributions from the different realisations
for real_i=1:N_realisations
    H_sparse_1D_i = H_to_H1D(H_sparse_all{real_i},max_XX);
    H_sparse_1D_all{real_i}=H_sparse_1D_i;
    if real_i==1
        H_sparse_1D=H_sparse_1D_i;
    else
        H_sparse_1D=union(H_sparse_1D_i,H_sparse_1D);
    end
end

H_sparse = H1D_to_H(H_sparse_1D,Nspecies,max_XX);
W_sparse=zeros(length(H_sparse_1D),1);

for real_i=1:N_realisations
    H_sparse_1D_i=H_sparse_1D_all{real_i};
    [val_to,ind_to] = intersect(floor(H_sparse_1D),floor(H_sparse_1D_i),'stable');
    [~,ind_from] = intersect(floor(H_sparse_1D_i),floor(val_to),'stable');
    W_sparse_i=W_sparse_all{real_i};
    W_sparse(ind_to)=W_sparse(ind_to)+W_sparse_i(ind_from); 
end
W_sparse=W_sparse./sum(W_sparse);

end
