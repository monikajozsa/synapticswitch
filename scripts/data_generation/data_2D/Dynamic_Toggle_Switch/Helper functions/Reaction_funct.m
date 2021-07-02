function [x,t,tau,xbar,Xbar_change,change_ind,changed_reac_happened] = Reaction_funct(xbar,t,x,r,rate_constants,tau,mode_effect_xbar,change_ind,mode_ind,rch_addition)
% This function calculates the next reaction of the birth-death process and
% applies appropriate change in xbar when the process is in a side mode

%% If there is no rch_addition variable given then allocate zeros
if~exist('rch_addition','var')
    rch_addition=zeros(4,1);
end

if mode_ind>0
        xbar=max(0,xbar(1)+tau*mode_effect_xbar(mode_ind)).*ones(size(xbar));
        Xbar_change=[t;xbar(1)];
        change_ind=change_ind+1;
else
    Xbar_change=[];
end
    rates = Rates_EI(x,xbar,rate_constants);
    rates(isnan(rates))=0;
    rates(1,1) = rates(1,1)+rch_addition;
    tau=-1/sum(rates)*log(rand);
    t=t+tau;
    reac=sum(cumsum(rates/sum(rates))<rand)+1;
    x=x+r(:,reac);
    changed_reac_happened=1;
end