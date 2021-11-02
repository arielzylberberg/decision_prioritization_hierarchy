function p = run_fig_after_error_data_model(datasets)


addpath '/Users/arielzy/Dropbox/Data/1 - LAB/01 - Proyectos/65 - HierarchTree/0560/model/compare_models'

%%

if nargin==0
    datasets = [1,22];
end

n = length(datasets);
for i=1:n
    pa{i} = calc_distrib_resps_after_error(datasets(i));
end


%%

p = publish_plot(n,3);
set(gcf,'Position',[323  349  697  363]);

for i=1:n
    for j=1:3
        ind = 3*(i-1)+j;
        p.copy_from_ax(pa{i}.h_ax(j),ind);
    
    end
end

colores = movshon_colors(3);
p.current_ax(2);
l = legend(['\color[rgb]{',vec2str(colores(1,:)),'} Level 1'],...
    ['\color[rgb]{',vec2str(colores(2,:)),'} Level 2'],...
    ['\color[rgb]{',vec2str(colores(3,:)),'} Level 3']);

p.format('FontSize',11);

set(l,'FontAngle','italic','box','off','FontSize',12);


close_all_but(p.h_fig);
set(p.h_ax,'tickdir','out');
set(p.h_ax(4),'ylim',[0,0.45]);
set(p.h_ax(5:6),'ylim',[0,0.5],'ytick',0:0.1:0.5);

drawnow
hl = p.letter_the_plots();
set(hl,'FontSize',12);


same_ylim();

set(p.h_ax,'tickdir','out');
set(p.h_ax,'ticklength',[0.02,0.02]);


end

