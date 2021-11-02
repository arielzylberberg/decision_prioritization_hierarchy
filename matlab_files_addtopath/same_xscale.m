function same_xscale(ax_handle,axes_xseparation)
% function same_xscale(ax_handle,axes_xseparation)
% makes the xscale equal across multiple 
% axes). Convenient for stimulus-and-response locked plots.
%pasarle un listado de "ax handles" 

%%
if nargin<2 || isempty(axes_xseparation)
    axes_xseparation = .05;
end

%%

pos = [];
xli = [];
for i=1:length(ax_handle)
    pos = [pos; get(ax_handle(i),'Position')];
    xli = [xli; get(ax_handle(i),'xlim')];
end

width = pos(:,3);
s = abs(xli(:,2)-xli(:,1));

[val,ind] = max(s./width);

scale_factor = s./width/val;

posnew = pos;
posnew(:,3) = posnew(:,3).*scale_factor;
for i=1:length(ax_handle)
    set(ax_handle(i),'Position',posnew(i,:));
end

%% done scaling. now adjust the distance between plots

if all(pos(:,2)==pos(1,2)) % only if the plots are aligned as columns
    for i=2:length(ax_handle)
        posnew(i,1) = posnew(i-1,1)+posnew(i-1,3)+axes_xseparation;
    end
    for i=1:length(ax_handle)
        set(ax_handle(i),'Position',posnew(i,:));
    end
end

