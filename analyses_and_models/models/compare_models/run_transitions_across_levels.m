function run_transitions_across_levels(v_datasource)

if nargin==0 || isempty(v_datasource)
    % v_datasource = [1,3,4];
    % v_datasource = [1,12,4];
    % v_datasource = [1, 8, 4];
    v_datasource = [1, 22, 4, 13];
end

n = length(v_datasource);
titles = {'Data','Heuristic model','Bayesian model','Bayesian cheaper sampling'};

if 0
    p = call_transitions_between_levels(v_datasource);

    set(gcf,'Position',[162  410  988  203]);

    for i=2:n
        p.displace_ax(i:n,-0.05,1);
    end


    for i=1:n
        ht(i) = p.add_text(i,titles{i},'center','top');
    end

    set(p.h_ax,'visible','off');
    p.format('FontSize',18);
end

%% before and after 1st error


[p1, params1] = call_transitions_between_levels(v_datasource,'min_num_errors',0,'max_num_errors',0);
[p2, params2] = call_transitions_between_levels(v_datasource,'min_num_errors',1,'max_num_errors',inf);


p = publish_plot(2,n);
set(gcf,'Position',[202  271  906  448])
% set(gcf,'Position',[276  179  832  540]);
for i=1:n
    p.copy_from_ax(p1.h_ax(i),i);
    p.copy_from_ax(p2.h_ax(i),i+n);
end


for i=1:2*n
    p.current_ax(i);
    hold all
    dx = 1.35;
    plot([-dx,-dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);
    plot([dx,dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);
end



for i=1:length(v_datasource)
    if i<=length(titles)
        ht(i) = p.add_text(i,titles{i},'center','top');
    end
end

set(p.h_ax,'visible','off');
p.format('FontSize',14);

% for i=1:n
%     p.displace_ax([(1+i):n,(n+1+i):2*n],-0.05,1);
% end
p.displace_ax([(n+1):(2*n)],0.075,2);


%% draw a traingle to indicate the size
draw_triangles = 0;
% draw_triangles = 1;
if draw_triangles
    ids = p.new_axes_in_rect([0.9,0.7,0.1,0.06],1);
    set(gca,'Units','pixels');
    % Get and update the axes width to match the plot aspect ratio.
    % pos = get(gca,'Position');
    xli = [0,1];
    [xp(1)] = ax2fig(gca,xli(1),0);
    [xp(2)] = ax2fig(gca,xli(2),0);

    w_max = params1.pars.scaling_line_width; %pixels
    % w_min = w_max/20;

    xbottom = [xli(1), xli(1) + w_max/diff(xp)*xli(2)];
    plot(xbottom,[0,0],'k-');
    hold all 

    w_min = w_max * params1.pars.min_v;
    xtop = [xli(1), xli(1) + w_min/diff(xp)*xli(2)];
    delta = [diff(xbottom)-diff(xtop)]/2;
    xtop = xtop + delta;
    plot(xtop,[1,1],'k-');

    plot([xbottom(1), xtop(1)],[0,1],'k');
    plot([xbottom(2), xtop(2)],[0,1],'k');

    xlim([0,1]);
    ylim([0,1]);

    axis off

    ids = p.new_axes_in_rect([0.9,0.3,0.1,0.06],1);
    p.copy_from_ax(p.h_ax(end-1),p.h_ax(end));

    p.current_ax(ids-1);
    text(0.5,0,num2str(redondear(params1.max_val,2)),'horizontalalignment','center');
    text(0.5,1,num2str(redondear(params1.max_val * params1.pars.min_v,2)),'horizontalalignment','center');

    p.current_ax(ids);
    text(0.5,0,num2str(redondear(params2.max_val,2)),'horizontalalignment','center');
    text(0.5,1,num2str(redondear(params2.max_val * params2.pars.min_v,2)),'horizontalalignment','center');

end

close_all_but(p.h_fig);

end

