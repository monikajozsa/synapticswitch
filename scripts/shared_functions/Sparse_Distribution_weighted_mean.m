function Center = Sparse_Distribution_weighted_mean(H_sparse,W_sparse,isShifted)

%% Computes the weighted mean (center) of the probability distribution
%
% Inputs: H_sparse - state-space coordinates 
%         W_sparse - probability distribution 
%         isShifted - if the state-space is shifted by 1 or not
% Output: Center - weighted mean (expected value) of the empirical
%                  distribution W


if ~exist('isShifted','var')
    isShifted=1;
end
W_sparse=W_sparse/sum(W_sparse);%normalizing weights
x_dim=size(H_sparse,2);

Center=zeros(x_dim,1);
for i=1:x_dim
    Center(i)=sum(H_sparse(:,i).*W_sparse);
    if isShifted
        Center(i)=Center(i)-1;
    end
end

end