function run_learning_effects()

load('../../data/alldata.mat','alldata');

%%

coh = alldata.coh_fun/1000;
block_num = alldata.session;


%% against prob. re-query

v_resid_rew = nan(size(alldata.group));
nsuj = 4;
for i=1:nsuj

    I = alldata.group==i;
    
    tr_num = 1:sum(I);
    
    dep = sum(alldata.actions_fun(I,:)<=7,2);
    indep = {'coh',coh(I,:),'ones',ones(sum(I),1)};
    testSignificance.vars = [1,2];
    [beta,idx,stats,x,LRT] = f_regression(dep,[],indep,testSignificance);
    
    yhat = glmval(beta,x,'identity','constant','off');
    
    resid_rew = dep - yhat;
    v_resid_rew(I) = resid_rew;
    
    
end


%% lock on-off


[~,xx] = curva_media_hierarch(v_resid_rew, alldata.session, alldata.group, [],0);


nses = sum(~isnan(xx));
t = 1:max(nses);
[datamp,timeslocked] = eventlockedmatc(xx, t, nses, [10,10]);
s.t_on = t;
s.t_off = timeslocked;
s.g_on = xx';
s.g_off = datamp';

p = publish_plot(1,2);
set(gcf,'Position',[302  281  699  334]);
p.shrink(1:2,1,0.8);
p.displace_ax(1:2,0.15,2);

p.next();
terrorbar(s.t_on, nanmean(s.g_on), stderror(s.g_on),'color','k',...
    'LineStyle','none','marker','o','markerfacecolor','k','markeredgecolor','w');
pxlim
xlim([0,14]);

p.next();
terrorbar(s.t_off, nanmean(s.g_off), stderror(s.g_off),'color','k',...
    'LineStyle','none','marker','o','markerfacecolor','k','markeredgecolor','w');
xlim([-7,0]);
pxlim
same_xscale(p.h_ax);
same_ylim(p.h_ax);
set(p.h_ax(2),'ycolor','none');

p.current_ax(1);
xlabel({'Block number, ','from first'});
ylabel('Reward residuals');

p.current_ax(2);
xlabel({'Block number,','from last'});

set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);
p.unlabel_center_plots();
same_xscale(p.h_ax);
p.displace_ax(2,0.01,1);
p.format('FontSize',16,'MarkerSize',8,'LineWidthPlot',1);
% p.offset_axes();


%% same, for optedout

load ../exportdata_for_DTB_with_errors/dataformodel_0560_all.mat

colores = movshon_colors(3);

p = publish_plot(1,2);
set(gcf,'Position',[302  281  699  334]);
p.shrink(1:2,1,0.8);
p.displace_ax(1:2,0.15,2);

for i = 1:3
    
    [~,xx] = curva_media_hierarch(optedout, block_num, group, level==i,0);
    
    
    nses = sum(~isnan(xx));
    t = 1:max(nses);
    [datamp,timeslocked] = eventlockedmatc(xx, t, nses, [10,10]);
    s.t_on = t;
    s.t_off = timeslocked;
    s.g_on = xx';
    s.g_off = datamp';
    
    
    
    p.next();
    terrorbar(s.t_on, nanmean(s.g_on), stderror(s.g_on),'color',colores(i,:),...
        'LineStyle','none','marker','o','markerfacecolor',colores(i,:),'markeredgecolor','w');
    hold all
    xlim([0,14]);
    
    p.next();
    terrorbar(s.t_off, nanmean(s.g_off), stderror(s.g_off),'color',colores(i,:),...
        'LineStyle','none','marker','o','markerfacecolor',colores(i,:),'markeredgecolor','w');
    hold all
    xlim([-7,0]);
    
end

same_xscale(p.h_ax);
same_ylim(p.h_ax);
set(p.h_ax(2),'ycolor','none');

p.current_ax(1);
xlabel({'Block number ','from first'});
ylabel('Proportion of re-queries');

p.current_ax(2);
xlabel({'Block number','from last'});

set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);
p.unlabel_center_plots();
same_xscale(p.h_ax);
p.displace_ax(2,0.01,1);
p.format('FontSize',16,'MarkerSize',8,'LineWidthPlot',1);


end


