function [] = GenData_Changing_param(Save_filename,var_name,var_values,baseline_val,N_realisations,N_steps,save_n_change)
    if ~exist('save_n_change','var')
        save_n_change=0;
    end
    if ~exist('N_steps','var')
        N_steps=100000;% number of steps
    end
    if ~exist('N_realisations','var')
        N_realisations=100;% number of realizations
    end
    
    %% General specifications
    Nspecies=2; % number of species
    A=[0 -1; -1 0]; % connectivity structure
    modes_func = {@(x)x(1)/max(0.0001,(x(1)+x(2)))>0.75;@(x)x(2)/max(0.0001,(x(1)+x(2)))>0.75}; % this function determines mode boundaries
    N_param=length(var_values);

    %% system parameters
    n_0=[baseline_val.n_0; baseline_val.n_0]; % initial n
    x_0=[baseline_val.x_0; baseline_val.x_0]; % initial state, fixed for all simulations
    k=baseline_val.k; %inhibition constant

    %% mode parameters
    t_act=baseline_val.t_act;  % dwell time threshold for mode activation
    delta_n=baseline_val.delta_n; % plasticity constant - determines the amplitude of n change when a mode is active
    mode_effect_n = [delta_n;-delta_n];

    %% input parameters
    t_dur=baseline_val.t_dur; % input duration, fixed for all simulations
    t_per=baseline_val.t_per;% input period
    m_inp=baseline_val.m_inp; % input magnitude

    %% Variable allocation
    Lifetime=cell(N_param,1);
    N_survived=cell(N_param,1);
    n_avg=cell(N_param,1);
    Blown_up_ind=cell(N_param,1);

    avg_t_per_ind=zeros(N_param,1); %  average number of reactions between two inputs
    avg_t_dur_ind=zeros(N_param,1); % average number of reactions while input is active
    avg_switch_ind=zeros(N_param,1); % average number of switching
    avg_dwell_ind=zeros(N_param,1);  % average number of reactions whice in mo
    
    n_change=cell(N_param,1);
    
    disp(Save_filename)
    for param_ind=1:N_param
        tic
        [rate_constants] = GenConstants_EI(k,A);
        %% The varying parameter
        eval(strcat(var_name,'=',num2str(var_values(param_ind)),';'));
        if var_name=="delta_n"
            mode_effect_n = [delta_n;-delta_n];
        end
        if var_name=="n_0"
            n_0 = [n_0;n_0];
        end
        if var_name=="x_0"
            x_0 = [x_0;x_0];
        end
        %% Simulation of the birth-death process
        [X,T,n_change{param_ind},n_avg{param_ind},inp_activation] = Gillespie_dyn_inp_v3(n_0,rate_constants,N_steps,N_realisations,modes_func,mode_effect_n,t_act,t_per,t_dur,m_inp,x_0);
        [Lifetime{param_ind}, N_survived{param_ind}, Blown_up_ind{param_ind}] = Avg_Stats_from_data(T,X,N_realisations);
        %% Additional statistics
        [avg_switch_ind(param_ind), avg_dwell_ind(param_ind)] = ModeSwitch_ind(n_change{param_ind},N_realisations);
        [avg_t_per_ind(param_ind), avg_t_dur_ind(param_ind)] = Stats_inp_activation(inp_activation,N_realisations);
        disp(param_ind)
        if save_n_change
            save(Save_filename,'Lifetime','N_survived','Blown_up_ind','n_avg','avg_dwell_ind','avg_switch_ind',...
    'avg_t_per_ind','avg_t_dur_ind','modes_func',var_name,'N_param','n_change')
        else
            save(Save_filename,'Lifetime','N_survived','Blown_up_ind','n_avg','avg_dwell_ind','avg_switch_ind',...
    'avg_t_per_ind','avg_t_dur_ind','modes_func',var_name,'N_param')
        end
        toc
    end
end