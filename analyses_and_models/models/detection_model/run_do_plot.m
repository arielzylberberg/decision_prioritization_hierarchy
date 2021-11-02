load forplot.mat

d = concat_struct_fields(forplot);
struct2vars(d);

nsuj = length(unique(group));


%%

unsigned_flag = 1;

G = {1,2,3,4};

p = publish_plot(2,length(G));
set(gcf,'Position',[151  300  981  417])
p.displace_ax(1:p.data.n_col,-0.07,2);
p.displace_ax(p.h_ax,0.07,1);

colores = movshon_colors(3);
for g=1:length(G)
    p.current_ax(g);
    
    if unsigned_flag
        [tt,xx,ss] = curva_media_hierarch(correct,abs(coh),level,optedout==0 & ismember(group,G{g}),0);
    else
        [tt,xx,ss] = curva_media_hierarch(choice,coh,level,optedout==0 & ismember(group,G{g}),0);
    end
    
    for i=1:3
        terrorbar(tt,xx(:,i),ss(:,i),'LineStyle','none','marker','.','markersize',20,'color',colores(i,:));
        hold all
        if unsigned_flag
            [ttf,xxf] = curva_media(correct_fine,abs(coh_fine),level_fine==i & ismember(group_fine,G{g}),0);
        else
            [ttf,xxf] = curva_media(pright_fine,coh_fine,level_fine==i & ismember(group_fine,G{g}),0);
        end
        if g==1
            hline(i) = plot(ttf,xxf,'color',colores(i,:));
        else
            plot(ttf,xxf,'color',colores(i,:));
        end
    end
    
    ht(g) = title(['S',num2str(G{g})]);
    
    p.current_ax(g+length(G));
    if unsigned_flag
        [tt,xx,ss] = curva_media_hierarch(optedout==1,abs(coh),level,ismember(group,G{g}),0);
    else
        [tt,xx,ss] = curva_media_hierarch(optedout==1,coh,level,ismember(group,G{g}),0);
    end
    for i=1:3
        terrorbar(tt,xx(:,i),ss(:,i),'LineStyle','none','marker','.','markersize',20,'color',colores(i,:));
        hold all
        if unsigned_flag
            [ttf,xxf] = curva_media(p_out_fine,abs(coh_fine),level_fine==i & ismember(group_fine,G{g}),0);
        else
            [ttf,xxf] = curva_media(p_out_fine,coh_fine,level_fine==i & ismember(group_fine,G{g}),0);
        end
        plot(ttf,xxf,'color',colores(i,:));
    end
    xlabel('Motion strength [%coh]');
end
p.current_ax(1);

ylabel('Proportion correct')

p.current_ax(length(G)+1);
ylabel('Proportion of re-queries')


if unsigned_flag
    set(p.h_ax,'xlim',[0.02,0.8],'xscale','log');
    set(p.h_ax,'xtick',[0.032,0.128,0.512],...
        'xticklabel',100*[0.032,0.128,0.512],'xminortick','off','tickdir','out')
else
    set(p.h_ax,'xlim',[-0.6,0.6]);
    set(p.h_ax,'xtick',[-0.5,-0.25,0,0.25,0.5],...
        'xticklabel',100*[-0.5,-0.25,0,0.25,0.5],'xminortick','off','tickdir','out')
end

set(ht,'FontWeight','normal');

set(p.h_ax(1:length(G)),'xticklabel','');

if unsigned_flag
    set(p.h_ax(1:length(G)),'ylim',[0.5,1],'ytick',0.5:0.1:1);
else
    set(p.h_ax(1:length(G)),'ylim',[0,1]);
end
set(p.h_ax(length(G)+1:2*length(G)),'ylim',[0,0.7]);

p.current_ax(1);

l = legend(hline,['\color[rgb]{',vec2str(colores(1,:)),'} Level 1'],...
    ['\color[rgb]{',vec2str(colores(2,:)),'} Level 2'],...
    ['\color[rgb]{',vec2str(colores(3,:)),'} Level 3']);

p.unlabel_center_plots()
p.format('FontSize',14);

set(l,'FontSize',12,'FontAngle','italic','location','best','box','off');

export_fig('-pdf','fig_for_paper')