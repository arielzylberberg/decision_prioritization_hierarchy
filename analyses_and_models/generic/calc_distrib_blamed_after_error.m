function [all, off_path, on_path, uni_coh] = calc_distrib_blamed_after_error(ae, plot_flag)

[~,~,ind] = unique(ae.coh_path_to_error);
ind_coh = reshape(ind,size(ae.coh_path_to_error));

uni_coh = nanunique(ae.coh_path_to_error(:));
% [y,x] = calc_prop_times_blame(index_coh,was_blamed);
% [y,x] = calc_prop_times_blame(ind_coh(:,2),ae.level_node_blamed==2);

filt = ~isnan(ae.node_blamed);
% filt = true(size(ae.node_blamed));

% all
[all,x] = calc_prop_times_blame(to_vec(ae.coh_path_to_error(filt,:)), ae.coh(filt));

% per level
for i=1:3
    I = ae.on_path==1 & filt & ae.level_node_blamed==i;
    [on_path(:,i),x] = calc_prop_times_blame(ind_coh(filt,i),ind_coh(I,i));
    I = ae.on_path==0 & filt & ae.level_node_blamed==i;
    [off_path(:,i),x] = calc_prop_times_blame(ind_coh(filt,i),ind_coh(I,i));
end

% plot
if plot_flag
    colores = movshon_colors(3);
    
    p = publish_plot(1,3);
    p.next();
    plot(100*uni_coh, all, 'marker','o','markersize',7,'color','k',...
        'markerfacecolor','k','markeredgecolor','w');
    
    p.next();
    for j=1:3
        plot(100*uni_coh, on_path(:,j), 'marker','o','markersize',7,'color',colores(j,:),...
            'markerfacecolor',colores(j,:),'markeredgecolor','w');
        hold all
    end
    
    p.next();
    for j=1:3
        plot(100*uni_coh, off_path(:,j), 'marker','o','markersize',7,'color',colores(j,:),...
            'markerfacecolor',colores(j,:),'markeredgecolor','w');
        hold all
    end
    
    same_ylim(p.h_ax(2:3))
    p.format('FontSize',14);
    
end

end


function [y,x] = calc_prop_times_blame(A,B)

[A_count, x] = Rtable(A, 1);
if isempty(B)
    B = zeros(size(x));
end

[aux, uni_b] = Rtable(B, 1);
B_count = zeros(size(x));
B_count(ismember(x,uni_b)) = aux;

y = B_count./A_count;

end


% index_coh = index_coh(filt,:);
% was_blamed = was_blamed(filt);
%
% x = unique(index_coh);
% y = nan(size(x));
% for i=1:length(x)
%     J = any(index_coh==x(i),2);
%     denom = sum(J);
%     num = sum(J & was_blamed);
%     y(i) = num/denom;
% end





