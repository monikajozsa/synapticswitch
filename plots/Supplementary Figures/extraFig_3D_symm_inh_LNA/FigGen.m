%% LNA and Gillespie for 3D systems ihibition systems, with data named in the wrong order
clc
clear all
close all


Mode_Filename_vec=["Data_A1_mode.mat","Data_A2_mode.mat","Data_A3_mode.mat","Data_A4_mode.mat","Data_A5_mode.mat","Data_A6_mode.mat","Data_A7_mode.mat"];
LNA_Filename_vec=["Data_A1_LNA_symm_inh","Data_A2_LNA_symm_inh","Data_A3_LNA_symm_inh","Data_A4_LNA_symm_inh","Data_A5_LNA_symm_inh","Data_A6_LNA_symm_inh","Data_A7_LNA_symm_inh"];

NA=7;
LargestModeWeight_all=cell(NA,1);
p_in_all=cell(NA,1);
minLMW=zeros(NA,1);
maxLMW=zeros(NA,1);
minPin=zeros(NA,1);
maxPin=zeros(NA,1);
for Ai=1:NA %wirh reordering
   load(Mode_Filename_vec(Ai))
   load(LNA_Filename_vec(Ai))
   LargestModeWeight_all{Ai}=LargestModeWeight;
   p_in_all{Ai}=(1-P_out);
   minLMW(Ai) = min(LargestModeWeight_all{Ai}(:));
   maxLMW(Ai) = max(LargestModeWeight_all{Ai}(:));
   minPin(Ai) = min(p_in_all{Ai}(:));
   maxPin(Ai) = max(p_in_all{Ai}(:));
end
for Ai=1:NA
   %% Figure for largest mode weight
   figure(2)
   subplot(1,7,Ai)
   imagesc(LargestModeWeight_all{Ai}');
   colormap(viridis(100))
   %cb=colorbar;
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
   %% Figure for probability mass of LNA multidimensional Gaussian inside the positive orthant
   figure(3)
   subplot(1,7,Ai)
   imagesc(flip(p_in_all{Ai}));
   %cb=colorbar;
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
figure(2)
set(gcf,'Color','w');
%export_fig('Fig_symm_3D_IE_lmw','-pdf','-q101');

figure(3)
colormap(plasma(100))
set(gcf,'Color','w');
%export_fig('Fig_symm_3D_IE_pin','-pdf','-q101');