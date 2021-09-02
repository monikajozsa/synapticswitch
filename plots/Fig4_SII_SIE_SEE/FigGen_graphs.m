% 
% close all
% open('Fig_1_4_graphs.fig')

ycenter_vec=[0.88,0.4];
circ_delta=0.145;
circ_start=0.152;
xcenter_vec=circ_start+[0.01, 2*circ_delta, 4*circ_delta-0.01; circ_delta+0.01, 3*circ_delta , 5*circ_delta-0.01];
x_delt=0.02;
y_delt=0.02;
xi_shift=0.042;
color_mtx=['b','b','r';'b','r','r'];
head_type_mtx=["ellipse","ellipse","cback2";"ellipse","cback2","cback2"];
resol=200;
segment_angle=60;
for i=1:3
    xcenter=xcenter_vec(:,i);
    for j=1:2
        ycenter=ycenter_vec(j);
        % circle on the left above the subplot (j,i)
        text_x1=annotation('textbox','interpreter','latex','String','$x_1$','FitBoxToText','on');
        text_x1.EdgeColor='w';
        text_x1.FontSize=17;
        text_x1.Position(1:2)=[xcenter(1)-xi_shift/2.01, ycenter-xi_shift*1.65];
        rectang_points = [xcenter(1)-xi_shift/2, ycenter-xi_shift/2, xi_shift, xi_shift];
        x1 = annotation('ellipse',rectang_points,'Color','black');
        x1.LineWidth = 1.5;
        % circle on the right above the subplot (j,i)
        text_x2=annotation('textbox','interpreter','latex','String','$x_2$','FitBoxToText','on');
        text_x2.EdgeColor='w';
        text_x2.FontSize=16;
        text_x2.Position(1:2)=[xcenter(2)-xi_shift/2.01, ycenter-xi_shift*1.65];
        rectang_points = [xcenter(2)-xi_shift/2, ycenter-xi_shift/2, xi_shift, xi_shift];
        x2 = annotation('ellipse',rectang_points,'Color','black');
        x2.LineWidth = 1.5;
        if j==1
            arc_arrow([xcenter(1)+x_delt,ycenter+y_delt],[xcenter(2)-x_delt,ycenter+y_delt], segment_angle, resol, 2, color_mtx(1,i),1,head_type_mtx(1,i))
            arc_arrow([xcenter(2)-x_delt,ycenter-y_delt],[xcenter(1)+x_delt,ycenter-y_delt], segment_angle, resol, 2, color_mtx(2,i),-1,head_type_mtx(2,i))
        end
        if j==2
            arc_arrow([xcenter(1)+x_delt,ycenter+y_delt],[xcenter(2)-x_delt,ycenter+y_delt], segment_angle, resol, 3.2, color_mtx(1,i),1,head_type_mtx(1,i))
            arc_arrow([xcenter(2)-x_delt,ycenter-y_delt],[xcenter(1)+x_delt,ycenter-y_delt], segment_angle, resol, 0.8, color_mtx(2,i),-1,head_type_mtx(2,i))
        end
        % arc_arrow(start_point,end_point, segment_angle, resol, line_width, line_color, arrow_dir, arrow_head_type)
    end
end
