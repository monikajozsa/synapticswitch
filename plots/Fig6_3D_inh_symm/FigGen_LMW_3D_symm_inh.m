
Source_Filename_vec=["GillespieSimulation/A1/Data_A1_mode.mat","GillespieSimulation/A2/Data_A2_mode.mat",...
    "GillespieSimulation/A3/Data_A3_mode.mat","GillespieSimulation/A4/Data_A4_mode.mat","GillespieSimulation/A5/Data_A5_mode.mat",...
    "GillespieSimulation/A6/Data_A6_mode.mat","GillespieSimulation/A7/Data_A7_mode.mat"];

%%%%%%%%%%%%%%%%%%%%% save largest mode weight for the 7 architectures %%%%%%%%%%%%%%%%%%%%%
slimits=[0.25 1];
for i=1:7
    figure
    load(Source_Filename_vec(i))
    imagesc(LargestModeWeight');
    axis off;
    set(gcf,'Color','w');
    colormap(viridis(200));
    caxis(slimits)
    %set(f(i), 'Colormap', viridis(200), 'CLim', slimits)
    FileName=strcat('LMW_3D_symm_inh_A',num2str(i));
%     export_fig(FileName,'-pdf','-q101');
end
%%%%%%%%%%%%%%%%%%%%% save common colorbar - I manually deleted the subfigures to save the colorbar %%%%%%%%%%%%%%%%%%%%%
figure
for i=1:7
    load(Source_Filename_vec(i))
    f(i)=subplot(2,4,i);
    imagesc(LargestModeWeight');
    axis off;
    set(gcf,'Color','w');
    colormap(viridis(200));
    set(f(i), 'Colormap', viridis(200), 'CLim', slimits)
end
a(1)=f(4).Position(1);
a(2)=f(4).Position(2);
w_cb=(f(4).Position(3))*3;
h_cb=(f(4).Position(4))/10;
dx=w_cb/10;
dy=-a(2)*0.7;
cb=colorbar(f(4));
set(cb,'Location','southoutside')
set(cb,'Position',[a(1)+dx a(2)+dy w_cb h_cb])

cb.FontSize=20;
cb.LineWidth=2;
tick_loc=linspace(0.25,1,5);
cb.Ticks=tick_loc;
cb.TickLabels=round(100*tick_loc)/100;
% export_fig('LMW_3D_symm_inh_colorbar_all','-pdf','-q101');