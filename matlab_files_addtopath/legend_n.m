function [hl,ht] = legend_n(x,varargin)
hline = [];
name = '';
for i=1:length(varargin)
    if isequal(varargin{i},'hline')
        hline = varargin{i+1};
    elseif isequal(varargin{i},'title')
        name = varargin{i+1};
    end
end
        
for i=1:length(x)
    str{i} = num2str(x(i));
end
if ~isempty(hline)
    hl = legend(hline(1:length(str)),str);
else
    hl = legend(str);
end

ht = get(hl,'Title');
set(ht,'String',name);

set(hl,'location','best')


% try to get the title to work
% pos = get(h,'Position');
% if ~isempty(name)
%     annotation('textbox', [pos(1),pos(2)+pos(4),pos(3),min(1,pos(2)+pos(4)+0.1)],...
%            'String', name,'FontSize',8);
% end

