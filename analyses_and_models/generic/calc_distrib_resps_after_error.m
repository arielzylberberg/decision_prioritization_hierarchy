function p = calc_distrib_resps_after_error(dataset)


for i=1:4
    ae = run_on_path_off_path_other(i,dataset);
    [v_all(:,i), v_off_path(:,:,i), v_on_path(:,:,i), uni_coh] = calc_distrib_blamed_after_error(ae, 0);
    
    %     [aem,p1,p2] = run_on_path_off_path_other(i,8);
    %     [all_m(:,:,i), off_path_m(:,:,i), on_path_m(:,:,i), uni_coh] = calc_distrib_blamed_after_error(aem, 0);
end


%% plot average

all = nanmean(v_all,2);
off_path = nanmean(v_off_path,3);
on_path = nanmean(v_on_path,3);

nsubj = size(v_all,2);
s_all = std(v_all,[],2)/sqrt(nsubj);
s_off_path = std(v_off_path,[],3)/sqrt(nsubj);
s_on_path = std(v_on_path,[],3)/sqrt(nsubj);


colores = movshon_colors(3);

p = publish_plot(1,3);
p.next();
plot(100*uni_coh, all, 'marker','o','markersize',7,'color','k',...
    'markerfacecolor','k','markeredgecolor','w');
% terrorbar(100*uni_coh, all,s_all, 'marker','o','markersize',7,'color','k',...
%     'markerfacecolor','k','markeredgecolor','w');

p.next();
for j=1:3
    plot(100*uni_coh, on_path(:,j),'marker','o','markersize',7,'color',colores(j,:),...
        'markerfacecolor',colores(j,:),'markeredgecolor','w');
    %     errorbar(100*uni_coh, on_path(:,j),s_on_path(:,j), 'marker','o','markersize',7,'color',colores(j,:),...
    %             'markerfacecolor',colores(j,:),'markeredgecolor','w');
    hold all
end

p.next();
for j=1:3
    plot(100*uni_coh, off_path(:,j), 'marker','o','markersize',7,'color',colores(j,:),...
        'markerfacecolor',colores(j,:),'markeredgecolor','w');
    %     errorbar(100*uni_coh, off_path(:,j), s_off_path(:,j), 'marker','o','markersize',7,'color',colores(j,:),...
    %             'markerfacecolor',colores(j,:),'markeredgecolor','w');
    hold all
end

p.current_ax(1);
xlabel('Motion strength [%]');
ylabel('Proportion of responses');

p.current_ax(2);
title('on path');
xlabel('Motion strength [%]');
legend_n(1:3);
p.current_ax(3);
title('off path');
xlabel('Motion strength [%]');


p.format('FontSize',14,'LineWidthPlot',1);
same_ylim(p.h_ax(2:3));
same_xlim(p.h_ax);


p.format('FontSize',14);

end