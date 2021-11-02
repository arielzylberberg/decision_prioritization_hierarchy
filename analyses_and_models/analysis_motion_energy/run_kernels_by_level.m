load ../../data/alldata.mat
load ../prepro_motion_energy/motion_energy.mat

%%

LEVEL = 3; % select level

p = publish_plot(2,3);
set(gcf,'Position',[328  339  708  370]);
color = [0.9569    0.4275    0.2627; 0.4549    0.6784    0.8196];
maxquery = 2;

% scale the me
me = motionenergy.normalize_to_coh(me,flat.scoh/1000,18,18); % sample 18th is the peak of 
% curva_media(me,flat.scoh,~isnan(flat.scoh),1)

t = [1:size(me,2)]/75-1/75;
t = t*1000; %ms

ugroup = nanunique(flat.group);

for LEVEL = 1:3
    

    for j=1:2
        
        I = flat.maxquery==maxquery & flat.nquery==j  & ismember(flat.group,ugroup) & ...
            flat.level==LEVEL;
        m(I,:) = motionenergy.calc_residuals(me(I,:),flat.scoh(I),3);
    
        p.current_ax(LEVEL + 3*(j-1));
        
        [~,x,s] = curva_media(m,flat.rextended,I,0);
        for k=1:2
            [~,dataLine] = niceBars2(t,x(k,:),s(k,:),color(k,:),0.5);
            set(dataLine,'LineWidth',0.5);
            hold all
        end

        pxlim
    end

end
p.current_ax(1);
ylabel('Excess Motion Energy [a.u.]')

p.current_ax(4);
ylabel('Excess Motion Energy [a.u.]')

set(p.h_ax,'xlim',[0,400])

for i=4:6
    p.current_ax(i);
    xlabel('Time [ms]')
end

set(p.h_ax,'ylim',[-0.02,0.02]);
symmetric_y(p.h_ax);
p.format('FontSize',12);

set(p.h_ax(3),'yticklabel','');

for i=1:6
    p.current_ax(i);
    hold all
    yli = ylim;
    ha(i) = area([0,227],[yli(1)+diff(yli)*0.05,yli(1)+diff(yli)*0.05],yli(1));
end
set(ha,'FaceColor',0.8*[1,1,1],'EdgeColor','none');
p.current_ax(1);
ht = text(100,yli(1)+diff(yli)*0.05,'Stim. on','horizontalalignment','center','verticalalignment','bottom');
set(ht,'Color',0.5*[1,1,1],'Fontsize',12);

% u = [1,4];
for i=[1,4]
    p.current_ax(i);
    ht(1) = text(350,0.007,'Right choice','horizontalalignment','center','verticalalignment','bottom','color',color(2,:));
    ht(2) = text(350,-0.01,'Left choice','horizontalalignment','center','verticalalignment','bottom','color',color(1,:));
    set(ht,'FontSize',12);
end

for i=1:3
    p.current_ax(i);
    ht(i) = title(['Level ',num2str(i)]);
end
set(ht,'FontWeight','Normal');

p.unlabel_center_plots();

p.offset_axes();
    

