function [p,hlines] = run_plot_rewards_and_num_queries(v_datasource)

if nargin==0
%     v_datasource = [1,3,4,6];
%     v_datasource = [1,3,4,8,9];
    % v_datasource = [1,4,8];
    % v_datasource = [1,4,7];
    v_datasource = [1,4,22];
end

addpath('../../generic/')


% calc: rew rate, av number of queries per level, av number of errors per
% trial, av number of queries per trial,
% transitions to self, lower and upper levels
% av number of queries in a row

colores = cbrewer('qual','Dark2',5);
% colores = piratepal(8,2);
% colores = movshon_colors(15);


p = publish_plot(1,2);
set(gcf,'Position',[402  322  542  222])
% set(gcf,'Position',[441  306  547  492]);
% set(gcf,'Position',[324  344  620  200])
% v_datasource = [1,3,4];

lsty = '-';
msize = 8;

% v_datasource = 1;
% v_datasource = 1:4;
v_suj = 1:4;
p.next();
tot_rew = nan(length(v_datasource), length(v_suj));
for i=1:length(v_datasource)
    datasource = v_datasource(i);
    
%     datasource = 1;
    nsuj = length(v_suj);
    
    for k=1:nsuj
        suj = v_suj(k);
        [actions{k},coh{k},~,labels(i)] = get_actions_and_coh(suj, datasource);
        [tot_rew(i,k),rew_per_trial] = rew_from_actions_fun(actions{k});
        stdev_rew(i,k) = stderror(rew_per_trial);
    end
    
    for k=1:nsuj
        [L(k,:),E(k)] = get_prop_queries_and_errors(actions{k});
    end
    
    % errors
    terrorbar(1:4,[mean(L),mean(E)],[stderror(L),stderror(E)],'marker','o','color',colores(i,:),...
        'markerfacecolor',colores(i,:),'MarkerEdgeColor',colores(i,:),'markersize',msize,'Linestyle',lsty);
    hold all
    %lines & markers
    
    
%     terrorbar(1:3,mean(L),stderror(L),'marker','o','color',colores(i,:),...
%         'markerfacecolor',colores(i,:),'MarkerEdgeColor','w','markersize',msize,'Linestyle',lsty);
%     hold all
%     terrorbar(4,mean(E),stderror(E),'marker','o','color',colores(i,:),...
%         'markerfacecolor',colores(i,:),'MarkerEdgeColor','w','markersize',msize,'Linestyle',lsty);
    set(gca,'xtick',1:4,'xticklabel',{'Level1','Level2','Level3','Error'});
    xtickangle(30);
    ylabel('# queries per trial');
end
p.next();
do_bar_flag = 0;
if do_bar_flag
    hb = bar(tot_rew');
    for i=1:length(hb)
        set(hb(i),'FaceColor',colores(i,:));
    end
else
    for i=1:length(v_datasource)
        % datasource = v_datasource(i);
        terrorbar(1:4, tot_rew(i,:), stdev_rew(i,:),'marker','none','color',...
            colores(i,:),'Linestyle','none');
    end
    for i=1:length(v_datasource)
        hold all
        hb(i) = plot(1:4, tot_rew(i,:),'marker','o','color',...
            colores(i,:),'markerfacecolor',colores(i,:),'MarkerEdgeColor',colores(i,:),...
            'markersize',msize,'Linestyle',lsty);
    end
end

xlabel('Participant')
ylabel('Reward per trial')
hl = legend(hb, labels);
pos_legend = get(hl,'position');
pos_legend(1) = 0.83;
pos_legend(2) = 0.4;
set(hl,'position',pos_legend); 

% p.resize_horizontal([1,2],[1,1.5]);
p.shrink([1,2],0.7,0.9);
p.displace_ax([1,2],0.1,2);
p.displace_ax([2],-0.05,1);

legend_text_color(hl,colores);




p.format('FontSize',14,'LineWidthPlot',0.5);
% nontouching_spines(p.h_ax,'onlyY');

set(hl,'FontSize',12);



% nontouching_spines(p.h_ax,'onlyY');

end
