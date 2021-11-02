function symmetric_x(varargin)
if ~isempty(varargin)
    ax = varargin{1};
else
    ax = gca;
end

for i=1:length(ax)
    xl = get(ax(i),'xlim');
    lim = max(abs(xl));
    set(ax(i),'xlim',[-lim lim]);
end
