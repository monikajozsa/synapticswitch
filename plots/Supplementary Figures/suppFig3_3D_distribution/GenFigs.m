%% Figures without mode coloring
% load('Data_A1_k_0019.mat')
% figure;i=1;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 100]);ylim([0 100]);zlim([0 100])
% saveas(gcf,'k019n2','fig');
% figure;i=3;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 250]);ylim([0 250]);zlim([0 250])
% saveas(gcf,'k019n8','fig');
% figure;i=9;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 60]);ylim([0 60]);zlim([0 60])
% saveas(gcf,'k019n26','fig');
% 
% load('Data_A1_k_0046.mat')
% figure;i=1;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 50]);ylim([0 50]);zlim([0 50])
% saveas(gcf,'k046n2','fig');
% figure;i=3;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 110]);ylim([0 110]);zlim([0 110])
% saveas(gcf,'k046n8','fig');
% figure;i=9;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 60]);ylim([0 60]);zlim([0 60])
% saveas(gcf,'k046n26','fig');
% 
% load('Data_A1_k_0073.mat')
% figure;i=1;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 30]);ylim([0 30]);zlim([0 30])
% saveas(gcf,'k073n2','fig');
% figure;i=3;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 65]);ylim([0 65]);zlim([0 65])
% saveas(gcf,'k073n8','fig');
% figure;i=9;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,[])
% xlim([0 45]);ylim([0 45]);zlim([0 45])
% saveas(gcf,'k073n26','fig');

%% Figures with mode coloring
clear all
close all
% load('Data_A1_k_0019.mat')
% i=1;
% [~,~,points_mode_id1] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[2;2;2]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id1)
% xlim([0 100]);ylim([0 100]);zlim([0 100])
% saveas(gcf,'k019n2_mode','fig');
% 
% i=3;
% [~,~,points_mode_id3] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id3)
% xlim([0 250]);ylim([0 250]);zlim([0 250])
% saveas(gcf,'k019n8_mode','fig');
% 
% i=9;
% [~,~,points_mode_id] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id)
% xlim([0 60]);ylim([0 60]);zlim([0 60])
% saveas(gcf,'k019n26_mode','fig');
% %
% 
% load('Data_A1_k_0046.mat')
% i=1;
% [~,~,points_mode_id1] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[2;2;2]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id1)
% xlim([0 50]);ylim([0 50]);zlim([0 50])
% saveas(gcf,'k046n2_mode','fig');
% 
% i=3;
% [~,~,points_mode_id3] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id3)
% xlim([0 110]);ylim([0 110]);zlim([0 110])
% saveas(gcf,'k046n8_mode','fig');
% % points_mode_id=points_mode_id3;
% % points_mode_id3(points_mode_id==1)=4;
% % points_mode_id3(points_mode_id==4)=2;
% % points_mode_id3(points_mode_id==2)=1;
% % figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id3)
% % xlim([0 110]);ylim([0 110]);zlim([0 110])
% % saveas(gcf,'k046n8_mode','fig');
% 
% i=9;
% [~,~,points_mode_id] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
% figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id)
% xlim([0 60]);ylim([0 60]);zlim([0 60])
% saveas(gcf,'k046n26_mode','fig');
% 
% %%%%%%%%%%

load('Data_A1_k_0073.mat')
i=1;
[~,~,points_mode_id1] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[2;2;2]);
figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id1)
xlim([0 30]);ylim([0 30]);zlim([0 30])
saveas(gcf,'k073n2_mode','fig');

i=3;
[~,~,points_mode_id3] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id3)
xlim([0 65]);ylim([0 65]);zlim([0 65])
saveas(gcf,'k073n8_mode','fig');

i=9;
[~,~,points_mode_id] = LargestMode_complete_alg(H_sparse{i},W_sparse{i},H_sparse_1D{i},0.001,[8;8;8]);
figure;Plot_stationary_distrib_v2(H_sparse{i},W_sparse{i},3,points_mode_id)
xlim([0 60]);ylim([0 60]);zlim([0 60])
saveas(gcf,'k073n26_mode','fig');

