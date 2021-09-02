clear all
% close all
opengl('hardwarebasic') % we need this when we do many 3d plots
rate_const=0.0775;

% Current data file name
FileName_vec=["Data_rate_const_00955","Data_rate_const_00415","Data_rate_const_0019"];
rate_const_vec=[0.0955, 0.0415,0.019];
axis_min=zeros(3,2);
axis_max=zeros(3,2);
shift_x=[7 1 3];
shift_y=[7 1 3];
Prop_th=0.001;
n_vec=[1 2 5];
figure
for rate_const_ind=1:3
    load(FileName_vec(rate_const_ind))
    for j=n_vec
        i=find(j==n_vec);
        %% getting current data
        H_sparse=H_sparse_all{j,1};
        W_sparse=W_sparse_all{j,1};
        %% Ploting distributions with different coloring for the different modes
        H_sparse_1D=H_to_H1D(H_sparse);
        [~,~,points_mode_id_sparse] = LargestMode_complete_alg(H_sparse,W_sparse,H_sparse_1D,Prop_th,xbar_vec(j));
        if rate_const_ind==1 && i==3 %%we change two neglectible values to make the mode color match the previous ones
            mode1_ind=points_mode_id_sparse==1;
            points_mode_id_sparse(mode1_ind)=2;
            points_mode_id_sparse(40)=1;
            points_mode_id_sparse(39)=3;
        end
        if rate_const_ind==3 && i==2 %%we need to permute the values of points_mode_id_sparse
            mode1_ind=points_mode_id_sparse==1;
            mode2_ind=points_mode_id_sparse==2;
            mode3_ind=points_mode_id_sparse==3;
            points_mode_id_sparse(mode1_ind)=3;
            points_mode_id_sparse(mode2_ind)=1;
            points_mode_id_sparse(mode3_ind)=2;
        end
        cut_ind_gl=W_sparse>max(W_sparse)*Prop_th;
        W_sparse=W_sparse(cut_ind_gl);
        W_sparse=W_sparse/sum(W_sparse);
        H_sparse=H_sparse(cut_ind_gl,:);
        H  = Marginal_Sparse_to_grid(H_sparse,W_sparse,[1 2]);
        [xmax,ymax]=size(H);
        x_axis=(0:(xmax-1));
        y_axis=(0:(ymax-1));
        points_mode_id_mat  = Marginal_Sparse_to_grid(H_sparse,points_mode_id_sparse,[1 2]);
        subplot(3,3,i+(rate_const_ind-1)*3)
        mesh(x_axis,y_axis,H',points_mode_id_mat','FaceAlpha',1,'EdgeColor','none','FaceColor','flat');
        tempvar=get(gca,'XAxis');
        set(gca,'XTick',tempvar.TickValues([1,end]));
        tempvar=get(gca,'YAxis');
        set(gca,'YTick',tempvar.TickValues([1,end]));
        tempvar=get(gca,'ZAxis');
        set(gca,'ZTick',tempvar.TickValues([1,end]));
        set(gca,'FontSize',12);
        if i==1
            zlabel(strcat('k=',num2str(rate_const_vec(rate_const_ind))),'FontSize',16)
        end
        if rate_const_ind ==1
            title(strcat('n=',num2str(n_vec(i))),'FontSize',16)
        end
    end
end
set(gcf,'Color','w');
% export_fig('Fig_2D_modes','-pdf','-q101');