close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% CHANGING PARAMETERS ONE-BY-ONE %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parpool(6)
%% define parameter ragnge for the varying parameters
k_vec=linspace(0.01,0.3,10); % inhibition constant
delta_n_vec=linspace(0.001,0.1,10); % plasticity constant
n_0_vec=linspace(1,5.5,10); % initial macro-size
t_act_vec=linspace(0,9,10); % activaition time threshold
m_inp_vec=linspace(1,10,10); % input magnitude
t_per_vec=linspace(10,100,10); % input period
x_0_vec=linspace(1,10,10); % initial state
t_dur_vec=linspace(0.1,1,10); % input time duration

baseline_val.k=k_vec(5);
baseline_val.delta_n=delta_n_vec(5);
baseline_val.n_0=n_0_vec(5);
baseline_val.t_act=t_act_vec(4);
baseline_val.m_inp=m_inp_vec(5);
baseline_val.t_per=t_per_vec(5);
baseline_val.x_0=x_0_vec(5);
baseline_val.t_dur=t_dur_vec(5);

%% generate data with baseline parameters except one varying parameter
N_real=200;

GenData_Changing_param('Changing_k.mat','k',k_vec,baseline_val,N_real)
GenData_Changing_param('Changing_delta_n.mat','delta_n',delta_n_vec,baseline_val,N_real)
GenData_Changing_param('Changing_n_0.mat','n_0',n_0_vec,baseline_val,N_real)
GenData_Changing_param('Changing_t_act.mat','t_act',t_act_vec,baseline_val,N_real)
GenData_Changing_param('Changing_m_inp.mat','m_inp',m_inp_vec,baseline_val,N_real)
GenData_Changing_param('Changing_t_per.mat','t_per',t_per_vec,baseline_val,N_real)
GenData_Changing_param('Changing_t_dur.mat','t_dur',t_dur_vec,baseline_val,N_real)
GenData_Changing_param('Changing_x_0.mat','x_0',x_0_vec,baseline_val,N_real)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% WITH AND WITHOUT INPUT %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% generate data with baseline parameters except one varying parameter
N_real=20;
N_steps=1000000;
save_n_change=1;
GenData_Changing_param('With_without_input.mat','m_inp',[0 5],baseline_val,N_real,N_steps,save_n_change);