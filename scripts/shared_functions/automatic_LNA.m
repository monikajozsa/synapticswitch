function [nn_eq,Cov_LNA,P_out] = automatic_LNA(k,x_bar,W,epsilon,lambda)

%% Automatic LNA computation of a network
%
% Inputs: k - rate costant(s) (Note: if k scalar - symmetric case; if k 
%             antidiagonal NxN matrix - asymmetric case; N - number of species)
%         x_bar - macroscopic size (scalar), i.e. provides the mean vector
%                 of the LNA
%         W - connectivity matrix of the network
%         epsilon - small constant (1e-4) to avoid the birth
%                   rate of the excitatory reaction to become 0
%         lambda - positive costant which scales the excitatory rates
%                  used in the 3D network with excitatory and inhibitory
%                  connections (if it is not specified, lambda=1)
% Output: nn_eq - nonnegative equilibria: steady-state values of the 
%                 reaction rate equations in the nonnegative orthant of the
%                 state space (used for checks)
%         Cov_LNA - covariance matrix from the LNA
%         P_out - probability outside: the probability mass outside the
%                 positive orthant of the Gaussian distribution with mean 
%                 x_bar (vectorised) and covariance Cov_LNA
%         


if ~exist('epsilon','var')
    epsilon=1e-4;
end

if ~exist('lambda','var')
    lambda=1;
end

N_species=size(W,1);

if size(k,1)==1 
    k=ones(N_species)*k;
end

%types of rates
inh_B=@(a,k) k*x_bar/(k+a/x_bar);
inh_D=@(a,k) k/(k+1)*a;
exc_B=@(a,k) lambda*x_bar*(a/x_bar+epsilon)/(k+a/x_bar);
exc_D=@(a,k) lambda*(1+epsilon)/(k+1)*a;

%generates the symbolic rates vector
r=kron(eye(N_species,N_species),[1 -1]);
x = sym('x',[N_species 1]);
rates=sym([]);

% Birth and death rates generation given reaction constans and connectivity
for j=1:N_species
    BR_j=0;
    DR_j=0;
    for i=1:N_species
        if (W(i,j)==-1)
            BR_j=BR_j+inh_B(x(i),k(i,j));
            DR_j=DR_j+inh_D(x(j),k(i,j));
        elseif (W(i,j)==1)
            BR_j=BR_j+exc_B(x(i),k(i,j));
            DR_j=DR_j+exc_D(x(j),k(i,j));
        end
    end
    rates=[rates BR_j DR_j];
end

f_x=r*rates.'; % vector field of the associated reaction rate equations

nn_eq=[];
% checks the nonnegative equilibria (but x_bar is used later)
% comment this part to not get the message, from here:
% S=solve(f_x==zeros(size(r,1),1),x);
% for s=1:size(r,1)
%     equilibria(:,s)=double(S.(string(x(s))));
% end
% 
% if isempty(equilibria)
%     disp('No equilibria')
% else
%     for s=1:size(equilibria,1)
%         if all(equilibria(s,:)>=0)
%             nn_eq=[nn_eq; double(equilibria(s,:))];
%         end
%     end
%     if isempty(nn_eq)
%         disp('No equilibria in the first orthant')
%     %else
%         %nn_eq
%     end
% end
% to here.

J=jacobian(f_x); % Jacobian matrix of the reaction rate equations
A=subs(J,x, x_bar*ones(N_species,1));
B=r*(subs(rates,x, x_bar*ones(N_species,1)).*r).';

% Covariance matrix obtained from the Lyapunov equation
Cov_LNA=lyap(double(A),double(B));

% Probability outside the positive orthant
if (N_species==2)
    P_inside = mvncdf([0 0],[20 20]*x_bar,x_bar*ones(1,N_species),Cov_LNA);
    P_out=1-P_inside;
elseif (N_species==3)
    P_inside = mvncdf([0 0 0],[20 20 20]*x_bar,x_bar*ones(1,N_species),Cov_LNA);
    P_out=1-P_inside;
    if isnan(P_out)
        P_out=1-mvncdf([0 0 0],[10 10 10]*x_bar,x_bar*ones(1,N_species),Cov_LNA);
    end
else
    P_out=NaN;
end


end

