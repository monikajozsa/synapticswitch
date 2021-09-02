%% generating figure for dwell time and switching of symmetric toggle switch

clear all
clc
load('Data_dwell_time_distr.mat') % distribution
load('Data_dwell_time_X.mat') % X state process
load('Data_dwell_time_T.mat') % T time process corresponding to X

%% basic parameters
[Nk,Neq]=size(H_sparse_all);% number of k and xbar parameters considered in the analysis
Nreal=size(X_all{1,1},3); %number of realisations
Nsteps=size(X_all{1,1},2); %number of reactions in one realisation

%% variable allocation
switch_real_m1=zeros(Neq,Nk,Nreal);
switch_real_m2=zeros(Neq,Nk,Nreal);
dwell_ind_real_m1=cell(Neq,Nk,Nreal);
dwell_ind_real_m2=cell(Neq,Nk,Nreal);
dwell_time_real_m1=cell(Neq,Nk,Nreal);
dwell_time_real_m2=cell(Neq,Nk,Nreal);
switch_m1=zeros(Neq,Nk);
switch_m2=zeros(Neq,Nk);
dwell_ind1=zeros(Neq,Nk);
dwell_ind2=zeros(Neq,Nk);
dwell_time1=zeros(Neq,Nk);
dwell_time2=zeros(Neq,Nk);
dwell_time_var1=zeros(Neq,Nk);
dwell_time_var2=zeros(Neq,Nk);

%% calculation of dwell time and number of switching
for i=1:Neq
    for j=1:Nk
        tic
        %% get variables for (i,j) index pair
        X=X_all{j,i};
        T=reshape(T_all{j,i},size(X,2),Nreal);
        H=H_sparse_all{j,i};
        H_1D=H_to_H1D(H);
        W=W_sparse_all{j,i};
        xbar=xbar_vec(i);
        %% get the peaks of the modes - we are interested in side modes
        Peak_location = Peak_location_funct(H,W,H_1D,xbar); % function is in the end of this file
        if size(Peak_location,1)>1
            % MODE 1: the one on x axis
            % MODE 2: the one on y axis
            mode1_ind=find(Peak_location(:,2)==1,1);
            mode2_ind=find(Peak_location(:,1)==1,1);
            if ~isempty(mode1_ind)
                for real_i=1:Nreal
                    T_real_i=T(:,real_i);
                    %% Dwell time in mode 1 (ON)
                    % indices where the process was at the peak
                    mode1_peak_ind=find(reshape(X(1,:,real_i)==Peak_location(mode1_ind,1) & X(2,:,real_i)==Peak_location(mode1_ind,2),Nsteps,[]));
                    mode2_peak_ind=find(reshape(X(1,:,real_i)==Peak_location(mode2_ind,1) & X(2,:,real_i)==Peak_location(mode2_ind,2),Nsteps,[]));
                    % indices where the process was in modes
                    mode1_dwell_ind=reshape(X(1,:,real_i)>2*X(2,:,real_i),Nsteps,[]);
                    mode2_dwell_ind=reshape(X(2,:,real_i)>2*X(1,:,real_i),Nsteps,[]);
                    %% MODE 1: entry and exit indices
                    [dwell_time_real_m1{i,j,real_i}, dwell_ind_real_m1{i,j,real_i}, switch_real_m1(i,j,real_i)]=DwellTime_func(mode1_peak_ind,1-mode1_dwell_ind,Nsteps,T_real_i);
                    [dwell_time_real_m2{i,j,real_i}, dwell_ind_real_m2{i,j,real_i}, switch_real_m2(i,j,real_i)]=DwellTime_func(mode2_peak_ind,1-mode2_dwell_ind,Nsteps,T_real_i);
                end
            end
        end
        %% calculate average dwell time over different realisations
        try
            dwell_ind1(i,j)=mean(cell2mat(dwell_ind_real_m1(i,j,:)),'omitnan');
            dwell_time1(i,j)=mean(cell2mat(dwell_time_real_m1(i,j,:)),'omitnan');
            dwell_time_var1(i,j)=var(cell2mat(dwell_time_real_m1(i,j,:)),'omitnan');
        catch
            disp('Problem with calculating dwell time of mode 1')
        end
        try
            dwell_ind2(i,j)=mean(cell2mat(dwell_ind_real_m2(i,j,:)),'omitnan');
            dwell_time2(i,j)=mean(cell2mat(dwell_time_real_m2(i,j,:)),'omitnan');
            dwell_time_var2(i,j)=var(cell2mat(dwell_time_real_m2(i,j,:)),'omitnan');
        catch
            disp('Problem with calculating dwell time of mode 2')
        end
        %% calculate average number of switching over different realisations
        switch_m1(i,j)=mean(switch_real_m1(i,j,:),3,'omitnan');
        switch_m2(i,j)=mean(switch_real_m2(i,j,:),3,'omitnan');
    end
    toc
end

figure
%% Plot average dwell time
subplot(1,2,1)
dwell_time1(isnan(dwell_time1))=0;
dwell_time2(isnan(dwell_time2))=0;
imagesc(log((dwell_time1+dwell_time2)'/2))
xlabel('$n$','Interpreter','latex','FontSize',18)
ylabel('$k$','Interpreter','latex','FontSize',18)
set(get(gca,'YLabel'),'Rotation',0)
title('log(dwell time)','FontSize',16)
disp_ind=[1,Neq];
rate_const_round=round(rate_const_vec*100)/100;
yticks(disp_ind)
yticklabels(rate_const_round(disp_ind))
xticks(disp_ind)
xticklabels(xbar_vec(disp_ind))
set(gca,'FontSize',20)
colormap_temp=viridis(100);
colormap(colormap_temp)
colorbar

%% Plot average switching
subplot(1,2,2)
switch_m1(isnan(switch_m1))=0;
switch_m2(isnan(switch_m2))=0;
imagesc((switch_m1+switch_m2)'/2)
xlabel('$n$','Interpreter','latex','FontSize',18)
ylabel('')
title('# switching','FontSize',16)
yticks([])
yticklabels([])
xticks(disp_ind)
xticklabels(xbar_vec(disp_ind))
set(gca,'FontSize',20)
colormap_temp=viridis(100);
colormap(colormap_temp)
colorbar

set(gcf,'Color','w');
% export_fig('Fig_dwell_time','-pdf','-q101');

%% The cde below plots two additional figures that are not in the paper
% figure
% dwell_ind1(isnan(dwell_ind1))=0;
% dwell_ind2(isnan(dwell_ind2))=0;
% imagesc(log((dwell_ind1+dwell_ind2)/2))
% title('log(# reactions) in modes','FontSize',16)
% xlabel('$n$','Interpreter','latex','FontSize',18)
% ylabel('$k$','Interpreter','latex','FontSize',18)
% set(get(gca,'YLabel'),'Rotation',0)
% yticks(disp_ind)
% yticklabels(rate_const_round(disp_ind))
% xticks(disp_ind)
% xticklabels(xbar_vec(disp_ind))
% colormap(viridis(100))
% colorbar
% 
% figure
% imagesc(log((dwell_time_var2+dwell_time_var1)/2))
% title('log(var(dwell time))','FontSize',16)
% xlabel('$n$','Interpreter','latex','FontSize',18)
% ylabel('$k$','Interpreter','latex','FontSize',18)
% set(get(gca,'YLabel'),'Rotation',0)
% yticks(disp_ind)
% yticklabels(rate_const_round(disp_ind))
% xticks(disp_ind)
% xticklabels(xbar_vec(disp_ind))
% colormap(viridis(100))
% colorbar

function Peak_location = Peak_location_funct(H,W,H_1D,xbar)
%% this function calculates the coordinates of mode peaks from the stationary distribution
Prop_th=0;
Scale_const_for_dist=0;
[~,~,points_mode_id] = LargestMode_complete_alg(H,W,H_1D,Prop_th,xbar,Scale_const_for_dist);
Nmodes=max(points_mode_id);
Peak_location=zeros(Nmodes,2);
for i=1:Nmodes
    mode_ind=find(points_mode_id==i);
    [~,b]=max(W(mode_ind));
    Peak_location(i,:)=H(mode_ind(b),:);
end
end

function [dwell_time,dwell_ind1,switch_var1]=DwellTime_func(mode_main_peak_ind,mode_other_dwell_ind,Nsim,T_real_i)
%% this function calculates dwell times and number of switching of mode_main from indices of reactions when the process reached the peak of mode main (mode_main_peak_ind) and when it escaped from mode main (mode_other_dwell_ind)
if ~isempty(mode_main_peak_ind)
    mode_main_entry_ind_temp=0;
    mode_main_exit_ind_temp=0;
    temp_ind=1;
    previous_dwell_in_mode_main=0;
    for k=1:length(mode_main_peak_ind)
        if k<length(mode_main_peak_ind)
            temp=find(mode_other_dwell_ind(mode_main_peak_ind(k):mode_main_peak_ind(k+1)),1);
        else
            temp=find(mode_other_dwell_ind(mode_main_peak_ind(k):Nsim),1);
        end
        if ~isempty(temp)
            mode_main_entry_ind_temp(temp_ind)=mode_main_peak_ind(k)-previous_dwell_in_mode_main;
            mode_main_exit_ind_temp(temp_ind)=mode_main_peak_ind(k)+temp;
            temp_ind=temp_ind+1;
            previous_dwell_in_mode_main=0;
        else
            % if it did not exit then add that length to
            % the dwell time
            if k<length(mode_main_peak_ind)
                previous_dwell_in_mode_main=previous_dwell_in_mode_main+mode_main_peak_ind(k+1)-mode_main_peak_ind(k);
            else
                previous_dwell_in_mode_main=previous_dwell_in_mode_main+Nsim-mode_main_peak_ind(k);
            end
        end
    end
    % if there is a peak-entry after the last exit then add the last bit as a Mode 1 dwell time
    if mode_main_exit_ind_temp(end)<mode_main_peak_ind(end) 
        if mode_main_entry_ind_temp(end)>0
            mode_entry_ind_last=find(mode_main_exit_ind_temp(end)<mode_main_peak_ind,1);
            mode_main_entry_ind_temp(temp_ind)=mode_main_peak_ind(mode_entry_ind_last);
        else
            mode_main_entry_ind_temp(temp_ind)=mode_main_peak_ind(1);
        end
        mode_main_exit_ind_temp(temp_ind)=mode_main_entry_ind_temp(temp_ind)+previous_dwell_in_mode_main;
    end 
    dwell_time=mean(T_real_i(mode_main_exit_ind_temp)-T_real_i(mode_main_entry_ind_temp));
    dwell_ind1=mean(mode_main_exit_ind_temp-mode_main_entry_ind_temp);
    switch_var1=length(mode_main_exit_ind_temp)-1;
else
    dwell_time=NaN;
    dwell_ind1=NaN;
    switch_var1=NaN;
end
end