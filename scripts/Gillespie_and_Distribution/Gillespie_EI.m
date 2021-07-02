function [X,T] = Gillespie_EI(xbar,rate_constants,N_steps,N_realisations)

%% Gillespie's algorithm (SSA) implementation
% Inputs: xbar - Nx1 macroscopic size value (N number of species)
%         rate_constants - structure containing the rate constants
%         N_steps - number of steps (iterations) for each trajectory 
%         N_realisations - number of trajectory generated for the process
% Output: X - NxN_stepsxN_realisations molecular numbers
%         T - 1xN_stepsxN_realisations jump times

Nspecies=length(xbar); % number of species
if size(xbar,1)~=Nspecies
    xbar=xbar';
end

%% initial conditions for time and state
t_0=0;
x_0=xbar;

%% variable allocation
T=zeros(1,N_steps,N_realisations);
X=zeros(Nspecies,N_steps,N_realisations);

%% Birth-Death reactions
r=zeros(Nspecies,2*Nspecies); 
for i=1:Nspecies
    r(i,(i-1)*2+1)=1;
    r(i,i*2)=-1;
end

parfor j=1:N_realisations % parfor used for parallel computing of each realisation
    rng(j+1)
    [X(:,:,j), T(:,:,j)] = Gillespie_alg_EI(r,xbar,rate_constants,t_0,x_0,N_steps);
end
end

function [X_realisation,T_realisation] = Gillespie_alg_EI(r,xbar,rate_constants,t_0,x_0,N_steps)

    % generates a single trajectory of length N_steps
    
    T_realisation=NaN(1,N_steps);
    X_realisation=NaN(size(r,1),N_steps);
        
    t=t_0;
    x=x_0;
    T_realisation(:,1)=t;
    X_realisation(:,1)=x;

    for i=2:N_steps
        rates = Rates_EI(x,xbar,rate_constants); % rate values for x
        tau=-1/sum(rates)*log(rand);
        t=t+tau;
        reac=sum(cumsum(rates/sum(rates))<rand)+1;
        x=x+r(:,reac);
        if any(x<0)
           disp('Error: x is negative in Gillespie algorithm') 
        end
        T_realisation(:,i)=t;
        X_realisation(:,i)=x;
        if any(x>10000) && i<N_steps
            disp('x exceeded allowed threshold')
            break
        end
    end
end