function [M_all, labels] = fn_action_distrib_after_query_internal_node(fnode, group, do_plot)


[levels, paths, sons] = get_levels_paths_sons();

level = nan(size(fnode));
for i=1:length(levels)
	level(fnode==i) = levels(i);
end
I = ismember(fnode,8:15);
level(I)=4;

%%

% level = d.flat.level;


% fraction of transitions to a son node
uni_group = nanunique(group);
for ii = 1:length(uni_group)
    i = uni_group(ii);
    J = find(level(1:end-1)<=3 & group(1:end-1)==i & group(2:end)==i);
    
    % all possibilities:
    
    correct_son = fnode(J+1)==sons(fnode(J),3);
    wrong_son = fnode(J+1)==sons(fnode(J),2);
    
    to_self = fnode(J)==fnode(J+1);
    
    to_other_same_level =  level(J)==level(J+1) & ~to_self;
    to_other_lower_level = level(J)<level(J+1) & ~correct_son & ~wrong_son;
    to_up = level(J)>level(J+1);
    aux = [correct_son, wrong_son, to_self, to_other_same_level, to_other_lower_level, to_up];
    M_all(i,:) = mean(aux);
end

labels = {'Correct child','Incorrect child','Same node','Other, same level','Other, lower level','Higher level'};

% do_plot = 1;
if do_plot
    p = publish_plot(1,1);
    set(gcf,'Position',[399  359  540  168]);
    p.next();
    h = barh(100 * M_all,'stacked');
    % colores = cbrewer('qual','Set1', 6 );
    colores = piratepal(6,4);
    for i=1:length(h)
        set(h(i),'FaceColor',colores(i,:));
    end
    
    legend(h, labels,'location','eastoutside');
    % hl = columnlegend(3, h, labels, 'location', 'northeastinside');
    
    set(gca,'ylim',[0.5,4.5],'xlim',[0,100],'ytick',1:4,'yticklabel',{'S1','S2','S3','S4'});
    ylabel('Participant');
    xlabel('% of actions');
    set(h,'BarWidth',0.9,'EdgeColor','w');
    p.format('FontSize',12);
    p.offset_axes();
    
    
    % for i=1:length(h)
    for i=1:3
        X = h(i).XEndPoints;
        % Y = h(i).YEndPoints;
        for j=1:length(X)
            str = num2str(round(100*M_all(j,i))/1);
            if i==1
                y = M_all(j,1)/2;
            else
                y = sum(M_all(j,1:i-1)) + [sum(M_all(j,1:i)) -  sum(M_all(j,1:i-1))]/2;
            end
            y = y*100;
            text(y,X(j),str,'Color','w','horizontalalignment','center')
        end
    end
    
end
