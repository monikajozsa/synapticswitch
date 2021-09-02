%% LNA and Gillespie for 3D systems with changing weight (omega) of excitatory connections
%this code relies on the following data files: 
%Data_A1_mode, Data_A1_LNA,
%Data_A2_mode, Data_A2_LNA,
%Data_A3_mode, Data_A3_LNA,
%Data_A4_mode, Data_A4_LNA,
%Data_A5_mode, Data_A5_LNA,
%Data_A6_mode, Data_A6_LNA,
%Data_A7_mode, Data_A7_LNA,
clear all

NA=7; % number of architectures
% allocation of the main variables to be plotted
LargestModeWeight_all=cell(NA,1);
p_in_all=cell(NA,1); 
% allocation of variables for color scaling
minLMW=zeros(NA,1); 
maxLMW=zeros(NA,1);
minPin=zeros(NA,1);
maxPin=zeros(NA,1);
% filling up variables from data
for Ai=1:NA
   FileNameGill=strcat("Symm_inh_exc/GillespieSimulation/LargestModeWeight/Data_A",num2str(Ai),"_mode");
   FileNameLNA=strcat("Symm_inh_exc/LinearNoiseApproximation/Data_A",num2str(Ai),"_LNA");
   load(FileNameGill)
   load(FileNameLNA)
   LargestModeWeight_all{Ai}=LargestModeWeight;
   p_in_all{Ai}=1-P_out;
   minLMW(Ai) = min(LargestModeWeight_all{Ai}(:));
   maxLMW(Ai) = max(LargestModeWeight_all{Ai}(:));
   minPin(Ai) = min(p_in_all{Ai}(:));
   maxPin(Ai) = max(p_in_all{Ai}(:));
end

%% Figures
for Ai=1:NA
   figure(1)
   subplot(1,7,Ai)
   imagesc(LargestModeWeight_all{Ai});
   set(gca,'XTick',[],'YTick',[])
   ax = gca;
   ax.CLim=[min(minLMW) max(maxLMW)];
   if Ai==7
       cb=colorbar;
       colormap(viridis(100))
       cb.FontSize=15;
       tempvar=cb.Ticks;
       cb.Ticks=round([min(minLMW) max(maxLMW)]*100)/100;
   end
   figure(2)
   subplot(1,7,Ai)
   imagesc(p_in_all{Ai});
   set(gca,'XTick',[],'YTick',[])
   colormap(plasma(100))
   ax = gca;
   ax.CLim=[min(minPin) max(maxPin)];
   if Ai==7
       cb=colorbar;
       colormap(plasma(100))
       cb.FontSize=15;
       tempvar=cb.Ticks;
       cb.Ticks=round([min(minPin) max(maxPin)]*100)/100;
   end
end

set(gcf,'Color','w');
% export_fig('LMW_omega','-pdf','-q101');