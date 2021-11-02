function [p, pa] = run_plot_tree(dataset)

addpath '../model/compare_models'

%%

if nargin==0
    dataset = 1;
end

p1 = calc_distrib_resps_after_error(dataset);

[pa,pb] = run_in_tree(dataset);


%%

p = publish_plot(3,3);
set(gcf,'Position',[220  220  638  439]);
p.resize_vertical([1,4,7],[1.5,1,2],.1);
p.resize_vertical(1+[1,4,7],[1.5,1,2],.1);
p.resize_vertical(2+[1,4,7],[1.5,1,2],.1);
p.shrink(4:6,1,1.1);
p.shrink(4:6,1,1.0);
p.combine([4,5,6]);
p.shrink(1:3,1,1.2);

p.shrink(4:6,1,0.8); % new

p.new_axes_in_rect(get(p.h_ax(7),'position'),7,0.01);
p.delete_ax(7);
for i=1:3
    p.copy_from_ax(pb.h_ax(i),i);
end

for i=1:7
    p.copy_from_ax(pa.h_ax(i+7),6+i);
end

for i=1:3
    p.copy_from_ax(p1.h_ax(i),i+3);
end

colores = movshon_colors(3);
p.current_ax(5);
l = legend(['\color[rgb]{',vec2str(colores(1,:)),'} Level 1'],...
    ['\color[rgb]{',vec2str(colores(2,:)),'} Level 2'],...
    ['\color[rgb]{',vec2str(colores(3,:)),'} Level 3']);

p.format('FontSize',11);

set(l,'FontAngle','italic','box','off','FontSize',12);


close_all_but(p.h_fig);
set(p.h_ax,'tickdir','out');
set(p.h_ax(4),'ylim',[0,0.45]);
set(p.h_ax(5:6),'ylim',[0,0.5],'ytick',0:0.1:0.5);

hl = p.letter_the_plots('show',[1,2,3,7,4,5,6]);
set(hl,'FontSize',12);

displace_ax(hl(1:3),-0.03,2);
displace_ax(hl(1:3),0.03,1);

%%
pa = publish_plot(2,4);
set(gcf,'Position',[297  299  750  256]);

for i=1:4
    pa.resize_vertical((i-1)+[1,5],[1.5,1]);
end
pa.shrink(1:4,1.1,1.0);

pa.combine([5:8]);

pa.new_axes_in_rect(get(pa.h_ax(5),'position'),7,0.01);
pa.delete_ax(5);
id = [1,2,3,7:13];
for i=1:10
    pa.copy_from_ax(p.h_ax(id(i)), i+1);
end

pa.copy_from_ax(p.h_ax(1), 1);

pa.letter_the_plots('show',1:5);



end

