function [x_fig,y_fig]= ax2fig(handles,x,y)
% function [x_fig,y_fig]= ax2fig(handles,x,y)
% converts axes position to figure position
% Its useful for annotating graphs

pos = get(handles,'position');
xl = get(handles,'xlim');
yl = get(handles,'ylim');

if isequal(get(handles,'xscale'),'log')
    x_fig=(log(x)-log(xl(1)))/(log(xl(2))-log(xl(1)))*pos(3)+pos(1);
else
    x_fig=(x-xl(1))/(xl(2)-xl(1))*pos(3)+pos(1);
end
if isequal(get(handles,'yscale'),'log')
    y_fig=(log(y)-log(yl(1)))/(log(yl(2))-log(yl(1)))*pos(4)+pos(2);
else
    y_fig=(y-yl(1))/(yl(2)-yl(1))*pos(4)+pos(2);
end