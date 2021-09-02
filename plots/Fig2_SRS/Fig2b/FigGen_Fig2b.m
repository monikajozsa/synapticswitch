%% Probability of input-induced switching from off (shrinkage) to on(growth) mode as system size changes
clear all
m_inp_vec=linspace(1,5,10); % input magnitude
t_per_vec=linspace(500,5000,10); % input period
t_dur_vec=linspace(5,50,10); % input time duration %%v4 is with linspace(1,32.5,10);

%% Variable allocation
% potentiation_mean=zeros(10,10,3);
% potentiation_all=cell(10,3);
% history_all=cell(10,3);
% t_per=1500;
% m_inp=3;
% for i1=1:length(t_dur_vec)
%     t_dur=t_dur_vec(i1);
%     tic
%     [potentiation_mean(:,i1,1),potentiation_all{i1,1},history_all{i1,1}] = Input_potentiation(t_per,t_dur,m_inp);
%     toc
%     save('Data_Fig2b.mat')
% end
% 
% t_dur=15;
% m_inp=3;
% for i2=1:length(t_per_vec)
%     t_per=t_per_vec(i2);
%     tic
%     [potentiation_mean(:,i2,2),potentiation_all{i2,2},history_all{i2,2}] = Input_potentiation(t_per,t_dur,m_inp);
%     toc
%     save('Data_Fig2b.mat')
% end
% 
% t_dur=15;
% t_per=1500;
% for i3=1:length(m_inp_vec)
%     tic
%     m_inp=m_inp_vec(i3);
%     [potentiation_mean(:,i3,3),potentiation_all{i3,3},history_all{i3,3}] = Input_potentiation(t_per,t_dur,m_inp);
%     toc
%     save('Data_Fig2b.mat')
% end
% figure
% for i=1:5
%     plot(potentiation_mean(:,i,3),'o-','LineWidth',2,'Color',colors_pla(2*i,:))
%     hold on
% end

load('Data_Fig2b.mat')
potentiation_mean(:,7:10,1)=0;
potentiation_mean(potentiation_mean==0)=NaN;
pot_per_inptype_mean=reshape(mean(potentiation_mean,2,'omitnan'),10,[]);
pot_per_inptype_var = reshape(var(potentiation_mean,0,2,'omitnan'),10,[]);
figure
hold on
hb = bar(pot_per_inptype_mean);
pause(0.1);
for ib = 1:numel(hb)
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,pot_per_inptype_mean(:,ib)',pot_per_inptype_var(:,ib)','k.','LineWidth',2)
end

function [potentiation_mean,potentiation,history] = Input_potentiation(t_per,t_dur,m_inp)
    N_realisations=100;
    N_steps=100000;
    A=[0 -1; -1 0];
    k=0.1389;
    var_name='n_0';
    var_values=linspace(2,20,10);
    modes_func = {@(x)x(1)/max(0.0001,(x(1)+x(2)))>0.75;@(x)x(2)/max(0.0001,(x(1)+x(2)))>0.75};
    mode_effect_n=[0;0];
    t_act=3;
    x_0=[0;5];

    Np=length(var_values);
    potentiation=cell(Np,1);
    history=cell(Np,1);
    potentiation_mean=zeros(Np,1);
    for param_ind=1:Np
        [rate_constants] = GenConstants_EI(k,A);
        %% The varying parameter
        eval(strcat(var_name,'=',num2str(var_values(param_ind)),';'));
        n0 = [n_0;n_0];
        %% Simulation of the birth-death process
        [~,~,~,~,~,~,inp_01,modeact_012] = Gillespie_dyn_inp_v4(n0,rate_constants,N_steps,N_realisations,modes_func,mode_effect_n,t_act,t_per,t_dur,m_inp,x_0);
        modeact_012(isnan(modeact_012))=0;
        modeact_012(modeact_012==2)=-1;
        inp_01(isnan(inp_01))=0;
        inp_01(end,:)=zeros(1,N_realisations);
        inp_end=find(diff(inp_01)==-1);
        inp_beg=find(diff(inp_01)==1);
        endcut=mod(inp_end,N_steps)+100<N_steps;% we ignore the inputs that don't have enought steps after the end
        startcut=mod(inp_beg,N_steps)-20>1;% we ignore the inputs that don't have enought steps before them
        
        inp_end=inp_end(endcut & startcut);
        inp_beg=inp_beg(endcut & startcut);
        
        potentiation_i=zeros(length(inp_end),1);
        history_i=zeros(length(inp_end),1);
        for j=1:length(inp_end)
            potentiation_i(j)=sum(modeact_012(inp_end(j):inp_end(j)+100))>20;%after the input, it should be at least 20% biased towards growth
            history_i(j)=sum(modeact_012((inp_beg(j)-20):(inp_beg(j)-1)))<-4;%before the input, it should be at least 20% biased towards shrinkage
        end
        potentiation{param_ind}=potentiation_i;
        history{param_ind}=history_i;
        potentiation_mean(param_ind)=sum(history_i & potentiation_i)/sum(history_i);
    end
end
