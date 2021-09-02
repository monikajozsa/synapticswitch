function [] = arc_arrow(start_point,end_point, segment_angle, resol, line_width, line_color, arrow_dir, arrow_head_type,arrow_head_size)

if ~exist('segment_angle','var')
    segment_angle=10;
end

if ~exist('resol','var')
    resol=100;
end

if ~exist('line_width','var')
    line_width=1;
end

if ~exist('line_color','var')
    line_color='k';
end

if ~exist('arrow_dir','var')
    arrow_dir=1;
end

if ~exist('arrow_head_type','var')
    arrow_head_type='cback2';
end

if ~exist('arrow_head_size','var')
    arrow_head_size=10;
end

dist=abs(end_point(1)-start_point(1));
t=linspace(0,2*pi,resol*360/segment_angle)';
circle_center_x=min(start_point(1),end_point(1))+dist/2;
circle_center=[circle_center_x, start_point(2)-arrow_dir* dist/(2*tan(segment_angle*2*pi/360))];
circle_radius=norm(circle_center-start_point);
circle_x=circle_radius*cos(t)+circle_center(1);
circle_y=circle_radius*sin(t)+circle_center(2);
x_segment_ind=circle_x>min(start_point(1),end_point(1)) & circle_x<max(start_point(1),end_point(1));
if arrow_dir==1
    y_segment_ind=circle_y>start_point(2);
else
    y_segment_ind=circle_y<start_point(2);
end
segment_ind=find(x_segment_ind & y_segment_ind);
    
figure(1)
for i=1:(length(segment_ind)-25)
    circle_segment=annotation('line',circle_x(segment_ind(i:i+1)),circle_y(segment_ind(i:i+1)));
    circle_segment.LineWidth = line_width;
    circle_segment.Color = line_color;
end

i=length(segment_ind)-50;
arrow_head=annotation('arrow',circle_x(segment_ind([i,i+50])),circle_y(segment_ind([i,i+50])));
arrow_head.LineWidth = line_width;
arrow_head.Color = line_color;
arrow_head.HeadStyle=arrow_head_type;
if arrow_head_type(1)=='c'
    arrow_head.HeadWidth = arrow_head_size*1.3;
else
    arrow_head.HeadLength = arrow_head_size;
end