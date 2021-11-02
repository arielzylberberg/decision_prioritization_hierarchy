function run_timing()

datadir = '../../data';
load(fullfile(datadir,'alldata.mat'),'flat','alldata');

p = publish_plot(1,1);
set(gcf,'Position',[388  380  254  239]);
p.shrink(1,0.8,0.9);
p.displace_ax(1,0.1,1);
p.displace_ax(1,0.1,2);

shifted = [0;flat.fnode(1:end-1)];

max_delta = 15; % seconds
I = shifted~=0 & shifted~=15 & flat.trnum>1 & flat.time_delta<=max_delta;
[tt,xx,ss] = curva_media_hierarch(flat.time_delta,shifted,flat.group,I,0);


% bar(tt,nanmean(xx,2));
hold all
m = nanmean(xx,2);
stde = stderror(xx,2);
use_colors = 0;
if use_colors
    colores = movshon_colors(3);
    errorbar(tt(1),m(1),stde(1),'color',colores(1,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(1,:),'markeredgecolor','w','LineStyle','none');
    hold all
    errorbar(tt(2:3),m(2:3),stde(2:3),'color',colores(2,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(2,:),'markeredgecolor','w','LineStyle','none');
    errorbar(tt(4:7),m(4:7),stde(4:7),'color',colores(3,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(3,:),'markeredgecolor','w','LineStyle','none');
    errorbar(tt(8:14),m(8:14),stde(8:14),'color','r','marker','o','markersize',8,...
        'markerfacecolor','r','markeredgecolor','w','LineStyle','none');
else
    terrorbar(tt,m,stderror(xx,2),'color','k','marker','o','markersize',8,...
        'markerfacecolor','k','markeredgecolor','w','LineStyle','none');
end

hold all

h(1) = plot([1,7],[mean(m(1:7)),mean(m(1:7))],':','color',0.0*[1,1,1]);
h(2) = plot([8,14],[mean(m(8:14)),mean(m(8:14))],':','color',0.0*[1,1,1]);


bracket1 = drawbrace([15, mean(m(8:14))], [15, mean(m(1:7))], 5, 'Color', 'k');
set(bracket1,'clipping', 'off');

p.format('FontSize',12,'LineWidthPlot',1);
set(h,'LineWidth',1);
xlabel('Node queried first');
ylabel('Time to next query [s]');

ylim([0,2.5])
xlim([0.5,14]);
set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);
% p.offset_axes();

dife = mean(m(8:14))-mean(m(1:7));
ht = text(12,0.5,num2str(round(dife*100)/100));
set(ht,'FontSize',12);


set(p.h_ax,'xtick',[1:2:14]);
p.offset_axes();

%% against coherence

p = publish_plot(1,1);
set(gcf,'Position',[388  380  254  239]);
p.shrink(1,0.8,0.9);
p.displace_ax(1,0.1,1);
p.displace_ax(1,0.1,2);

shifted = [0;flat.fnode(1:end-1)];
shifted_c = [nan; flat.c(1:end-1)];
coh = abs(flat.scoh)/1000;
shifted_coh = 100*[nan; coh(1:end-1)];
shifted_level = [nan; flat.level(1:end-1)];
max_delta = 15; % seconds
% I = ~isnan(shifted_coh) & shifted~=15 & flat.trnum>1 & flat.time_delta<=max_delta;
uni_c = {1,0};
colores = [0,0,1;1,0,0];
for i=1:length(uni_c)
    I = ~isnan(shifted_coh) & flat.time_delta<=max_delta & shifted_c==uni_c{i};
    % [tt,xx,ss] = curva_media_hierarch(flat.time_delta,shifted_coh,shifted_level,I,0);
    [tt,xx,ss] = curva_media(flat.time_delta,shifted_coh,I,0);
    hold all
    m = xx;
    stde = ss;
    terrorbar(tt,m,stde,'color',colores(i,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(i,:),'markeredgecolor','w','LineStyle','-');
    
end

% bar(tt,nanmean(xx,2));


p.format('FontSize',12,'LineWidthPlot',1);

xlabel('Coherence node queried first [%]');
ylabel('Time to next query [s]');


set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);



% set(p.h_ax,'xtick',[1:2:14]);
p.offset_axes();


%%
p = publish_plot(1,1);
set(gcf,'Position',[388  380  254  239]);
p.shrink(1,0.8,0.9);
p.displace_ax(1,0.1,1);
p.displace_ax(1,0.1,2);

shifted = [0;flat.fnode(1:end-1)];
shifted_c = [nan; flat.c(1:end-1)];
coh = abs(flat.scoh)/1000;
shifted_coh = 100*[nan; coh(1:end-1)];
shifted_level = [nan; flat.level(1:end-1)];
max_delta = 15; % seconds
% I = ~isnan(shifted_coh) & shifted~=15 & flat.trnum>1 & flat.time_delta<=max_delta;
same_node_queried = shifted==[shifted(2:end);nan];
f = [shifted_c==1,shifted_c==0,same_node_queried];
colores = [0,0,1;1,0,0; 0,0,0];
for i=1:size(f,2)
    I = ~isnan(shifted_coh) & flat.time_delta<=max_delta & f(:,i)==1;
    % [tt,xx,ss] = curva_media_hierarch(flat.time_delta,shifted_coh,shifted_level,I,0);
    [tt,xx,ss] = curva_media(flat.time_delta,shifted_coh,I,0);
    hold all
    m = xx;
    stde = ss;
    terrorbar(tt,m,stde,'color',colores(i,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(i,:),'markeredgecolor','w','LineStyle','-');
    
end



% bar(tt,nanmean(xx,2));


p.format('FontSize',12,'LineWidthPlot',1);

xlabel('Coherence node queried first [%]');
ylabel('Time to next query [s]');


set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);



% set(p.h_ax,'xtick',[1:2:14]);
p.offset_axes();


%% dec time terminal node vs coherence at different levels

p = publish_plot(1,1);
set(gcf,'Position',[388  380  254  239]);
p.shrink(1,0.8,0.9);
p.displace_ax(1,0.1,1);
p.displace_ax(1,0.1,2);

% for each error, get (1) the coh of the tree parents, and (2) the time to
% the next action

I = sub2ind(size(alldata.actions_fun),flat.trnum, flat.nquery_intrial);
times = nan(size(alldata.actions_fun));
times(I) = flat.time;

[ntr,nact] = size(alldata.actions_fun);
cont = 0;
for i=1:ntr
    for j=1:nact
        I = alldata.actions_fun(i,j)>7 && alldata.actions_fun(i,j)<=14;
        if I==1
            parents = get_parents(alldata.actions_fun(i,j));
            cont = cont + 1;
            coh_parents(cont,:) = alldata.vCoh{i}(parents)/10;
            time_to_next_action(cont) = times(i,j+1) - times(i,j);
        end
    end
end

colores = movshon_colors(3);
for i=1:3
    hold all
    [tt,xx,ss] = curva_media(time_to_next_action,coh_parents(:,i),[],0);
    terrorbar(tt,xx,ss,'color',colores(i,:),'marker','o','markersize',8,...
        'markerfacecolor',colores(i,:),'markeredgecolor','w','LineStyle','-');
end




% bar(tt,nanmean(xx,2));


p.format('FontSize',12,'LineWidthPlot',1);

xlabel('Coherence node queried first [%]');
ylabel('Time to next query [s]');


set(p.h_ax,'tickdir','out','ticklength',[0.02,0.02]);



% set(p.h_ax,'xtick',[1:2:14]);
p.offset_axes();

end