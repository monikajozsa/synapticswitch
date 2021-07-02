function rates = Rates_EI(x,xbar,rate_constants,eps_local)

%% Reaction rates computation
% Inputs: x - Nx1 current state (current molecular number in the network)
%         xbar - Nx1 macroscopic size value
%         rate_constants - structure containing the rate constants
%         eps_local - small constant (1e-4) to avoid the birth
%         rate of the excitatory reaction to become 0 (i.e. complete
%         death) 
% Output: rates - Nx1 rate values at the state x (N number of species)

if ~exist('eps_local','var')
    eps_local=1e-4;
end

Nspecies=length(xbar);
Kdenum_E=rate_constants.Kdenum_E;
Knum_I=rate_constants.Knum_I;
Kdenum_I=rate_constants.Kdenum_I;
Knum_E=Kdenum_E>eps_local;

%% inhibitory and excitatory birth rates 
Exc_rates_mtx_num=((x./xbar+eps_local)).*Knum_E*diag(xbar);
Exc_rates_mtx_denum=Kdenum_E+x./xbar.*(Kdenum_E>0)+1*(Kdenum_E==0);
Exc_rates=sum(Exc_rates_mtx_num./Exc_rates_mtx_denum);
Inh_rates=sum(Knum_I*diag(xbar)./(Kdenum_I+x./xbar.*(Kdenum_I>0)+1*(Kdenum_I==0)));

%% Death rates: (epsilon added to the death rates so xbar remains the equilibrium)
beta=zeros(size(x))';
for i=1:Nspecies
    temp_vec=Kdenum_E(:,i)>eps_local;
    beta(i)=sum([(1+eps_local)*temp_vec;Knum_I(:,i)]./[Kdenum_E(:,i)+1;Kdenum_I(:,i)+1]);
end
Death_rates=beta.*x';

%% All birth-death rates
rates=zeros(2*Nspecies,1);
for i=1:Nspecies
    rates((i-1)*2+1:i*2)=[Exc_rates(i)+Inh_rates(i);Death_rates(i)];
end
end