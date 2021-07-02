function [rate_constants] = GenConstants_EI(rate_const_val, W)

%% Generate rate constants in matrix form for E (excitatory) and I (inhibitory) connections
%
% Inputs: rate_const_val - rate constant value k
%         W - NxN connectivity matrix (with N number of species)
% Output: rate_constants - structure containing the rate constants with
%                          size equal to W
%

connections=find(abs(W)>0);
Kdenum_E=zeros(size(W));
Knum_I=zeros(size(W));
Kdenum_I=zeros(size(W));
for j=1:size(connections,1)
    i=connections(j);
    if W(i)==1      %excitatory connections
        Kdenum_E(i) = rate_const_val;
    else            %inhibitory connections
        Knum_I(i) = rate_const_val;
        Kdenum_I(i) = rate_const_val;
    end
end

rate_constants.Kdenum_E=Kdenum_E;
rate_constants.Knum_I=Knum_I;
rate_constants.Kdenum_I=Kdenum_I;
