function levels = node_to_level(actions)

lev = [1,2,2,3,3,3,3,4,4,4,4,4,4,4,4];
levels = nan(size(actions));
for i=1:length(lev)
    I = actions==i;
    levels(I) = lev(i);
end


end