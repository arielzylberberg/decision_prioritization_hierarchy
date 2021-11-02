function displace_ax(h_ax,delta_pos,dim)


% % hack to deal with matlab's annoyance
% H = setdiff(obj.h_ax,h_ax);
% for i=1:length(H)
%     pos = get(H(i),'Position');
%     newpos = pos;
%     set(H(i),'Position',newpos);% same
% end

% go
for i=1:length(h_ax)
    pos = get(h_ax(i),'Position');
    newpos = pos;
    newpos(dim) = pos(dim) + delta_pos;
    set(h_ax(i),'Position',newpos);
end

end