function p = draw_transitions_in_tree(where_to)

addpath(genpath('../../data'));

draw_text = 0;
fixed_line_width = 0;

% p_thres = 0.1;
p_thres = 0.075;

% draw connections
max_lw = 8; % max line width
% from = 7;
% p = publish_plot(4,8);
% p.delete_ax([2:8,9,12:16,21:24]);
% p.displace_ax(1,(0.2299-0.1300)+0.0759/2,1);

% p = publish_plot(3,8);
% p.delete_ax([2,5:8,13:16]);

p = publish_plot(2,8);
p.delete_ax([2]);
set(gcf,'Position',[23   486  1418   291])

% set(gcf,'Position',[169   266  1272   511]);
for from = 1:14
    if ismember(from,[1:14])
        new_tree=1;
    else
        new_tree=0;
    end
    if new_tree
        tree = TreeClassAnalysis(([1:8]-4.5), 1, -1, 4);
        [hm,hl,hmw] = tree.draw_matlab();
        color_marker = 0.7*[1,1,1];
        set(hm,'markersize',6,'markerfacecolor',color_marker,'markeredgecolor','w');
        set(hmw,'markersize',12,'markerfacecolor','w','markeredgecolor','w');
        % set(hl,'linestyle','--','color','k');
        set(hl,'linestyle','-','color',0.7*[1,1,1]);
        hold all
        tree_fig = gcf;
        p.copy_from_ax(get_axes(tree_fig),p.h_ax(from));
        close(tree_fig);
    end
    W = where_to;
    
    W(W<p_thres) = 0;
    
    if fixed_line_width
        lw = ones(size(W(:,from)));
    else
        lw = W(:,from)*max_lw;
    end
    
    for i=1:size(where_to,1)
        X = [tree.nodes(from).x, tree.nodes(i).x];
        Y = [tree.nodes(from).y, tree.nodes(i).y];

        if W(i,from)>0
            if i==from
                pp = [0,0;1,.5;-1,.5;0,0]+[X(2),Y(2)];
                % pp = [0,0;1,0;0,1;0,0]+[X(2),Y(2)];
                B = bezier(pp);
                hold all
                plot(B(:,1),B(:,2),'r','LineWidth',lw(i));
                
                if draw_text
                    text(mean(B(:,1)),mean(B(:,2)),num2str(round(100*W(i,from))),...
                        'color','r','BackgroundColor','w','FontSize',8);
                end
                
            else
                hold all
                plot(X,Y,'r','LineWidth',lw(i));
                
                if draw_text
                    text(mean(X),mean(Y),num2str(round(100*W(i,from))),...
                        'color','r','BackgroundColor','w','FontSize',8);
                end
                
            end
        end
    end
    
%     close(hfig);
end

set(p.h_ax,'xlim',[-4.2,4.2],'ylim',[0.8,4.5])
set(p.h_ax,'visible','off')

end