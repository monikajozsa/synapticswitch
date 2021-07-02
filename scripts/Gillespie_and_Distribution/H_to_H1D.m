function H_1D = H_to_H1D(H,max_grid)

%% Transformation from H_sparse to H_sparse_1D
% Inputs: H - (H_sparse) state-space coordinates with probability
%             greater than 0, with coordinates in original form (2D or 3D)   
%         max_grid - maximum value of the state-space (can be unspecified)
% Output: H_1D - (H_sparse_1D) state-space coordinates with probability
%                greater than 0, with coordinates encoded in 1D   

if ~exist('max_grid','var')
    max_grid=max(H);
end
Ndigits=ceil(log10(max(10,abs(max_grid+1))));
Npowers=flip(cumsum(flip(Ndigits)));
Npowers=[Npowers(2:end) 0];
H_sparse_powers=H.*10.^Npowers;
H_1D=sum(H_sparse_powers,2);

end
