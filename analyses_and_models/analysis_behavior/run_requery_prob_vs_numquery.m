function run_requery_prob_vs_numquery()

load ../exportdata_for_DTB_with_errors/dataformodel_0560_all.mat

% p = publish_plot(1,1);
nsamples = 20;
p_requery = nan(nsamples,4,3);
for i=1:4
    for j=1:3
        [tt,aux,ss] = curva_media_hierarch(optedout==1, nquery_intrial,group==i,level==j,0);
        if length(aux)>nsamples
            aux = aux(1:nsamples);
            tt = tt(1:nsamples);
        end
        p_requery(tt,i,j) = aux;
        % count trials:
        for k=1:nsamples
            count(k,i,j) = sum(group==i & level==j & nquery_intrial==k);
        end
        
%         hold all
    end
end

to_plot = squeeze(sum(count>5,2))==4; % at least 5 trials

p = publish_plot(1,1);
colores = movshon_colors(3);
for i=1:3
    t = 1:nsamples;
    I = to_plot(:,i)==1;
    m = squeeze(nanmean(p_requery(I,:,i),2));
    s = squeeze(stderror(p_requery(I,:,i),2));
    terrorbar(t(I), m, s,'color',colores(i,:),'LineStyle','none','marker','o',...
        'MarkerSize',12,'LineWidth',1,'MarkerFaceColor',colores(i,:),'MarkerEdgeColor','w');
    hold all
    
end
p.format('FontSize',18);
xlabel('Query number from trial onset')
ylabel('Proportion of re-query');
p.offset_axes();

hl = legend_n(1:3,'title','Level');

end

