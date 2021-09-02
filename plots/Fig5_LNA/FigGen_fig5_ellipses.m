%%%%%%%%%%%%%%%%% Figure %%%%%%%%%%%%%%%%%

load('Data_Fig5.mat')
figure
ellipse_II=error_ellipse(Cov_II_LNA,Mean_II_LNA,'conf',0.9);
set(ellipse_II,'Color','b')
set(ellipse_II,'LineStyle','--')
set(ellipse_II,'LineWidth',2)
hold on;
ellipse_II=error_ellipse(Cov_II,Mean_II_LNA,'conf',0.9);
set(ellipse_II,'LineWidth',2)
set(ellipse_II,'LineStyle','-')
set(ellipse_II,'Color','b')

hold on
ellipse_IE=error_ellipse(Cov_IE_LNA,Mean_IE_LNA,'conf',0.9);
set(ellipse_IE,'Color','g')
set(ellipse_IE,'LineStyle','--')
set(ellipse_IE,'LineWidth',2)
hold on;
ellipse_IE=error_ellipse(Cov_IE,Mean_IE_LNA,'conf',0.9);
set(ellipse_IE,'LineWidth',2)
set(ellipse_IE,'LineStyle','-')
set(ellipse_IE,'Color','g')

hold on;ellipse_EE=error_ellipse(Cov_EE_LNA,Mean_EE_LNA,'conf',0.9);
set(ellipse_EE,'Color','r')
set(ellipse_EE,'LineStyle','--')
set(ellipse_EE,'LineWidth',2)
hold on;
ellipse_EE=error_ellipse(Cov_EE,Mean_EE_LNA,'conf',0.9);
set(ellipse_EE,'LineWidth',2)
set(ellipse_EE,'LineStyle','-')
set(ellipse_EE,'Color','r')

legend({'Cov of $S_{II}$ from LNA','Cov of $S_{II}$ from simulation','Cov of $S_{IE}$ from LNA','Cov of $S_{IE}$ from simulation','Cov of $S_{EE}$ from LNA','Cov of $S_{EE}$ from simulation'},'Interpreter','latex','FontSize',16)
set(gcf,'Color','w');

% % export_fig('Fig_ellipses','-pdf','-q101');
% % Mean_II_LNA_shortrun=Mean_II_LNA;Cov_II_LNA_shortrun=Cov_II_LNA;
% % Mean_IE_LNA_shortrun=Mean_IE_LNA;Cov_IE_LNA_shortrun=Cov_IE_LNA;
% % Mean_EE_LNA_shortrun=Mean_EE_LNA;Cov_EE_LNA_shortrun=Cov_EE_LNA;
% % Mean_II_shortrun=Mean_II;Cov_II_shortrun=Cov_II;
% % Mean_IE_shortrun=Mean_IE;Cov_IE_shortrun=Cov_IE;
% % Mean_EE_shortrun=Mean_EE;Cov_EE_shortrun=Cov_EE;