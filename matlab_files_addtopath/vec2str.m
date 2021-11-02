function s=vec2str(v,sep)
if nargin<2, sep=','; end
s = sprintf(sprintf('%s%%f',sep),v);
s = s((length(sep)+1):end);

try
    % clipboard('copy',['''',s,'''']);
    clipboard('copy',s);
catch
    disp('vec2str: no clipboard access')
end
return
