function p = run_distrib_of_actions_different_models(datasets)

if nargin==0
    
    datasets = [1,22,5,4,13,15,17:18];

end

colores1 = piratepal(6,4);
colores2 = cbrewer('qual','Accent', 3 );

%
N = length(datasets);
p = publish_plot(N,2);
set(gcf,'Position',[386   93  614  705]);
p.shrink(1:2*N,0.6,.85);
p.displace_ax(1:2:2*N,0.15,1);

for row=1:N
    
    dataset = datasets(row);
    
    p.next();
    
    [actions,coh,group,model_label{row}] = get_actions_and_coh(1:4, dataset);
    fnode = to_vec(actions');
    group = repmat(group,[1,size(actions,2)]);
    group = to_vec(group');
    
    [M_all, labels] = fn_action_distrib_after_query_internal_node(fnode, group, 0);
    
    
    hb = barh(100 * M_all,'stacked');
    for i=1:length(hb)
        set(hb(i),'FaceColor',colores1(i,:));
    end
    set(hb,'BarWidth',0.9,'EdgeColor','w','ShowBaseLine','off');
    
    
    
    p.next();
    
    ae = run_on_path_off_path_other(1:4,dataset);
    
    [tt,xx] = curva_media(100*[ae.on_path==0,ae.on_path==1,isnan(ae.on_path)],ae.group,[],0);
    
    hb = barh(unique(ae.group), xx,'stacked');
        
    
    set(hb,'BarWidth',0.9,'EdgeColor','w','ShowBaseLine','off');
    
    for i=1:length(hb)
        set(hb(i),'FaceColor',colores2(i,:));
    end
    
end


p.current_ax(1);
hl1 = legend(labels);
set(hl1,'position',[0.8102    0.5358    0.1546    0.1080]);


p.current_ax(2);
hl2 = legend('off path','on path','other');
set(hl2,'position',[0.8019    0.8145    0.1373    0.0566]);



hlett = p.letter_the_plots('show',1:2:2*N);

set(p.h_ax,'ylim',[0.5,4.5],'xlim',[0,100],'ytick',1:4,'yticklabel',{'S1','S2','S3','S4'});

h = p.center_plots();
set(p.h_ax(2:2:end),'ycolor','none');
set(p.h_ax(1:[2*N-2]),'xcolor','none');

p.xlabel('% of actions', [2*N-1,2*N]);
p.ylabel('Participant', 1:2:2*N);

p.format('FontSize',12);
p.offset_axes();
p.visible_limits_until_tickmarks();

set(hlett,'FontSize',14);


end


