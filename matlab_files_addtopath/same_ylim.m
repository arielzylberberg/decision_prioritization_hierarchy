function YLIM = same_ylim(ax_handle)
%function YLIM = same_ylim(ax_handle)
%pasarle un listado de "ax handles"

if nargin==0
    ax_handle = get_axes(gcf);  
end

if length(ax_handle)>1
    a = get(ax_handle,'ylim');
    a = cat(1,a{:});
    YLIM = [min(a(:,1)) max(a(:,2))];
    set(ax_handle,'ylim',YLIM)
end