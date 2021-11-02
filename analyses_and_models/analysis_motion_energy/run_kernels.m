function run_kernels()

load ../../data/alldata.mat
load ../prepro_motion_energy/motion_energy.mat

%%

% scale the me
me = motionenergy.normalize_to_coh(me,flat.scoh/1000,18,18); % sample 18th is the peak of 
% curva_media(me,flat.scoh,~isnan(flat.scoh),1)

t = [1:size(me,2)]/75-1/75;
t = t*1000; %ms
maxquery = 2;
% color = [1,0,0; 0,0,1];
% color = cbrewer('qual','Dark2',3);
color = [0.9569    0.4275    0.2627; 0.4549    0.6784    0.8196];

% color = cbrewer('qual','Set2',3);
p = publish_plot(1,maxquery*maxquery-1);
p.shrink(1:3,1,0.8);
p.displace_ax(1:3,0.1,2);
p.displace_ax([2],0.03,1);
p.displace_ax([2:3],0.03,1);

set(gcf,'Position',[260  245  756  215])
% set(gcf,'Position',[260  256  814  204])
% set(gcf,'Position',[402  309  598  489]);
ugroup = nanunique(flat.group);
% ugroup = 3;
% m = motionenergy.calc_residuals(me,flat.scoh,3);
for i=1:maxquery
    for j=1:i
%         I = flat.maxquery==i & flat.nquery==j & abs(flat.scoh)<=128 & ismember(flat.group,ugroup);
        I = flat.maxquery==i & flat.nquery==j  & ismember(flat.group,ugroup);
        %m = nan(size(me));
        m(I,:) = motionenergy.calc_residuals(me(I,:),flat.scoh(I),3);
        % m(I,:) = me(I,:);
        p.next();
        %p.current_ax(i,j+maxquery-i);
        [~,x,s] = curva_media(m,flat.rextended,I,0);
        %  plot(t,x,'.-')
        for k=1:2
            [~,dataLine] = niceBars2(t,x(k,:),s(k,:),color(k,:),0.5);
            set(dataLine,'LineWidth',0.5);
            hold all
        end
%         axis tight
        pxlim
    end
end

p.current_ax(1);
ylabel('Excess Motion Energy [a.u.]')

p.current_ax(2);
ylabel('Excess Motion Energy [a.u.]')

set(p.h_ax,'xlim',[0,400])

for i=1:3
    p.current_ax(i);
    xlabel('Time [ms]')
end



% todelete = find(~triu(ones(maxquery)));
% p.delete_ax(todelete);
set(p.h_ax,'ylim',[-0.015,0.015]);
% same_ylim(p.h_ax);
symmetric_y(p.h_ax);
p.format('FontSize',12);

set(p.h_ax(3),'yticklabel','');

if 1
    p.bracket_on_top(1,'Dec. after 1 query');
    p.bracket_on_top(2:3,'Decision after 2 queries');
else
    
     p.bracket_on_top(1,'Query 1 of 1');
     p.bracket_on_top(2,'Query 1 of 2');
     p.bracket_on_top(3,'Query 2 of 2');
% str = {'Query 1/1','Query 1/2','Query 2/2'};
% for i=1:3
%     p.current_ax(i);
%     htexto(i) = text(120,0.013,str{i},'horizontalalignment','left','verticalalignment','bottom');
% end
% set(htexto,'FontWeight','normal','FontAngle','italic','FontSize',10);
end



for i=1:3
    p.current_ax(i);
    hold all
    yli = ylim;
    ha(i) = area([0,227],[yli(1)+diff(yli)*0.05,yli(1)+diff(yli)*0.05],yli(1));
end
set(ha,'FaceColor',0.8*[1,1,1],'EdgeColor','none');
p.current_ax(1);
ht = text(100,yli(1)+diff(yli)*0.05,'Stim. on','horizontalalignment','center','verticalalignment','bottom');
set(ht,'Color',0.5*[1,1,1],'Fontsize',12);

for i=1:2
    p.current_ax(i);
    ht(1) = text(350,0.007,'Right choice','horizontalalignment','center','verticalalignment','bottom','color',color(2,:));
    ht(2) = text(350,-0.01,'Left choice','horizontalalignment','center','verticalalignment','bottom','color',color(1,:));
    set(ht,'FontSize',12);
end


% p.current_ax(3);


% export_fig('fig_me_query','-pdf')

h=p.letter_the_plots('show',1:2);
set(h,'FontSize',15);
for i=1:length(h)
    pos = get(h(i),'position');
    pos(1) = pos(1)-0.04;
    pos(2) = pos(2)+0.1;
    set(h(i),'position',pos);
end

set(p.h_ax(3),'ycolor','none');
p.offset_axes();
    
end

