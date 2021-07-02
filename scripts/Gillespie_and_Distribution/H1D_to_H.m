function H = H1D_to_H(H_1D,Nspecies,maxgrid)

%% Transformation from H_sparse_1D to H_sparse
% Inputs: H_1D - (H_sparse_1D) state-space coordinates with probability
%                greater than 0, with coordinates encoded in 1D
%         Nspecies - number of species in the network
% Output: H - (H_sparse) state-space coordinates with probability
%             greater than 0, with coordinates in original form (2D or 3D)        

H_1D=double(H_1D);
H=zeros(length(H_1D),Nspecies);
digits_all=numel(num2str(max(floor(H_1D))));
digits_vec=ones(Nspecies,1);
if exist('maxgrid','var')
    digits_vec(1)=numel(num2str(maxgrid(1)));
    digits_vec(2)=numel(num2str(maxgrid(2)));
    H(:,1)=floor(H_1D/10^(digits_all-digits_vec(1)));
    H_1D=H_1D-H(:,1)*10^(digits_all-digits_vec(1));
    H(:,2)=floor(H_1D/10^(digits_all-sum(digits_vec(1:2))));
    if Nspecies>2
        H(:,3)=H_1D-H(:,2)*10^(digits_all-sum(digits_vec(1:2)));
    end
else
    H_1D_digits=dec2base(H_1D,10) - '0'; % we are using that there are more zeros on the leading digit
    digits_dim1_min=digits_all-numel(num2str(min(floor(H_1D))))+1;
    %% bruteforce for finding the digits of the dimensions
    for digits_dim1=digits_dim1_min:(digits_all-(Nspecies-1))
        digits_vec(1)=digits_dim1;
        if Nspecies==3
            for digits_dim2=1:(digits_all-digits_dim1-1)
                digits_vec(2)=digits_dim2;
                digits_vec(3)=digits_all-digits_dim1-digits_dim2;
                is_good = TestDigits(H_1D_digits,digits_vec);
                if is_good
                    break
                end
            end
        else
            digits_vec(2)=digits_all-digits_dim1;
            is_good = TestDigits(H_1D_digits,digits_vec);
            if is_good
                break
            end
        end
        if is_good
            break
        end
    end
    %% if bruteforce did not find the digits of the dmensions, an educated guess is made; this only works if there is no dimension where the state space is in a fixed digit (such as it goes between 100 and 999 or 10 and 99
    if ~is_good
        digits_vec=diff(find(diff(sum(H_1D_digits==0))<0)); % this might not work, it relies on a few things; one of them is that if the max number that a process visited in one dimension has n digits but it visited n-1 digit numbers as well, there there are a lot of numbers starting with 0 for that dimension in H_1D
        disp('WARNING: maxgrid is not given H1D_to_H run into an exception where it might give a wrong output! It could be due to previously cutting small values of the distribution or other preprocessing steps.')
    end
    H(:,1)=floor(H_1D/10^(digits_all-digits_vec(1)));
    H_1D=H_1D-H(:,1)*10^(digits_all-digits_vec(1));
    if Nspecies>2
        H(:,2)=floor(H_1D/10^(digits_all-sum(digits_vec(1:2))));
        digits_dim3=digits_vec(3);
        H(:,3)=H_1D-H(:,2)*10^digits_dim3;
    else
        H(:,2)=floor(H_1D/10^(digits_all-sum(digits_vec(1:2))));
    end
    
end

function is_good = TestDigits(H_1D_digits,digits_vec) %here, we test if the digits for the different dimensions are guessed in the bruteforce correctly or not
    H_1D_digits_dim1=sum(H_1D_digits(:,1:digits_vec(1)).*(flip(10.^(0:(digits_vec(1)-1)))),2);
    Testing_dim1=(size(unique(H_1D_digits_dim1),1)==(max(H_1D_digits_dim1)-min(H_1D_digits_dim1)+1));
    H_1D_digits_dim2=sum(H_1D_digits(:,digits_vec(1)+1:sum(digits_vec(1:2))).*(flip(10.^(0:(digits_vec(2)-1)))),2);
    Testing_dim2=(size(unique(H_1D_digits_dim2),1)==(max(H_1D_digits_dim2)-min(H_1D_digits_dim2)+1));
    if length(digits_vec)==3
        H_1D_digits_dim3=sum(H_1D_digits(:,sum(digits_vec(1:2))+1:sum(digits_vec(1:3))).*(flip(10.^(0:(digits_vec(3)-1)))),2);
        Testing_dim3=(size(unique(H_1D_digits_dim3),1)==(max(H_1D_digits_dim3)-min(H_1D_digits_dim3)+1));
        is_good= Testing_dim1 & Testing_dim2 & Testing_dim3;
    else
        is_good=(size(unique(H_1D_digits_dim1),1)==(max(H_1D_digits_dim1)-min(H_1D_digits_dim1)+1)) & (size(unique(H_1D_digits_dim2),1)==(max(H_1D_digits_dim2)-min(H_1D_digits_dim2)+1));
    end
end

end