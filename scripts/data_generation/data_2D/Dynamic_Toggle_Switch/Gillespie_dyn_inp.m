function [X,T,Xbar_change,Xbar_avg,inp_activation] = Gillespie_dyn_inp(xbar,rate_constants,N_steps,N_realisations,modes_func,mode_effect_xbar,mode_time_th,inp_freq,inp_duration,inp_rate_addition,x_0)
%input parameters: rch_freq,rch_duration,rch_addition
%mode activation parameters: mode_time_th,modes_func,mode_effect_xbar
%% This is a modification of the Gillespie function used for the simulations in Sections 2 and 3
% pulse_freq: constant that defines how often pulse_val is added to the state
% pulse_val: vector of size of the state, it is the value that is added at
% every pulse_freq step
% modes_func: array of two functions defining the conditions to be in one
% state or another
% mode_time_th: constant defining how long the process has to be in a state
% to put the effect of being in a mode into action (to have ON and OFF switching)
% rate_change: it is another way of input besides (pulse_freq,pulse_val),
% it modifies the rate constants by adding some value to it (if mode_time_th is reached)

Nspecies=size(xbar,1);

%% Reactions
r=zeros(Nspecies,2*Nspecies);
for i=1:Nspecies
    r(i,(i-1)*2+1)=1;
    r(i,i*2)=-1;
end

%% Generalized I-E Toggle Switch with Gillespie's algorithm
t_0=0;
if ~exist('x_0','var')
    x_0=xbar;
end
T=zeros(1,N_steps,N_realisations);
X=zeros(size(r,1),N_steps,N_realisations);
Xbar_change=cell(N_realisations,1);
Xbar_avg=zeros(N_realisations,1);
inp_activation=cell(N_realisations,1);
parfor j=1:N_realisations
    rng(j+1)
    [X(:,:,j), T(:,:,j), Xbar_change_temp,inp_activation{j}] = Gillespie_alg_dynamic(r,xbar,rate_constants,t_0,x_0,N_steps,modes_func,mode_effect_xbar,mode_time_th,inp_freq,inp_duration,inp_rate_addition);
    time_weight=Xbar_change_temp(2:end,1)/sum(Xbar_change_temp(2:end,1));
    Xbar_avg(j)=sum(Xbar_change_temp(2:end,2).*time_weight);
    Xbar_change{j}=Xbar_change_temp(2:end,:);
end
end

function [X_realisation,T_realisation,Xbar_change,inp_activation] = Gillespie_alg_dynamic(r,xbar,rate_constants,t_0,x_0,N_steps,modes_func,mode_effect_xbar,mode_time_th,inp_freq,inp_duration,inp_rate_addition)
    t=t_0; %present time
    x=x_0; %present state
    tau=0; % initial value for time period between previous and current reactions
    %% time and process variable allocation and initialization
    T_realisation=NaN(1,N_steps);
    X_realisation=NaN(size(r,1),N_steps);
    T_realisation(:,1)=t;
    X_realisation(:,1)=x;
    X_mode_past=0;% mode of previous state: 0 - rest, 1 - growth, 2 - shrinkage
    Dwell_time=0; % current dwell time
    Xbar_change=zeros(1,3);% this variable registers the changes in xbar (the effect of side modes): 1st dim is times when change happened, 2nd dim is value at the corresponding time, 3rd dim is the index of the reaction after which change happened
    change_ind=1; % separate indexing for mode effect events
    
    inp_activation=zeros(1,2);
    inp_ind=1;
    is_inp_past=0;
    for i=2:N_steps
%         if any(x<0)
%             disp('x is negative in Gillespie_dyn_inp_v3')
%         end
        %% Check if INPUT applies
        is_inp = t<=(floor(t/inp_freq)*inp_freq)+inp_duration;
        %% Tracking input activation
        if is_inp_past==0 && is_inp==1
            inp_activation(inp_ind,1)=i;
        elseif is_inp_past==1 && is_inp==0
            inp_activation(inp_ind,2)=i;
            inp_ind=inp_ind+1;
        end
        if is_inp==1
            is_inp_past=1;
        else
            is_inp_past=0;
        end
        
        %% ON - OFF mode effect
        Xbar_change_happened=0;
        for mode_ind=1:2
            if modes_func{mode_ind}(x) % if x is in mode mode_ind 
                if X_mode_past==mode_ind % if it was in mode mode_ind previously then add tau to the current dwell time
                    Dwell_time=Dwell_time+tau;
                    if Dwell_time>mode_time_th % If the process is in mode mode_ind since long enough time then simulate next reaction and its time
                       [x,t,tau,xbar,Xbar_change_temp,change_ind,Xbar_change_happened] = Reaction_funct(xbar,t,x,r,rate_constants,tau,mode_effect_xbar,change_ind,mode_ind,is_inp*inp_rate_addition);
                        Xbar_change(change_ind,1:2)=Xbar_change_temp; % save the changes in xbar
                        Xbar_change(change_ind,3)=i; % save the index of reaction
                    end
                else
                    Dwell_time=tau;
                    X_mode_past=mode_ind;
                end
            end
        end
        if ~Xbar_change_happened % If x was not in mode 1 or 2 since long enough time
             % simulate next reaction and its time without applying change
             % in xbar
            [x,t,tau,xbar,~,change_ind,~] = Reaction_funct(xbar,t,x,r,rate_constants,tau,mode_effect_xbar,change_ind,0,is_inp*inp_rate_addition);
        end
        if ~modes_func{2}(x) && ~modes_func{1}(x) % if x was not in side mode then register that it was in the middle rest mode (assigned as 0 - mode)
            X_mode_past=0;
        end
        %% Save current time and state
        T_realisation(:,i)=t;
        X_realisation(:,i)=x;
        if any(x>10000) && i<N_steps % We do not allow the process take high values - to avoid memory crash
            disp('x exceeded allowed threshold')
            inp_activation(end,2)=i;
            break
        end
        if any(xbar<1e-2) % if xbar is small enough then the process will only be able to die - 0 as an upper limit for xbar is taken care of in Reaction_funct
            xbar=0*xbar;
            Xbar_change(change_ind,1:2)=[t,0]; % save the changes in xbar
            Xbar_change(change_ind,3)=i;
            break
        end
        if all(x==0)
            inp_activation(end,2)=i;
            break
        end
    end
    if inp_activation(end,2)==0
        inp_activation(end,2)=i;
    end
end