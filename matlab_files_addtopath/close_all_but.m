function close_all_but(keep)
% Close figures
figs = findall(0,'type','figure');
other_figures = setdiff(figs, keep);
delete(other_figures);