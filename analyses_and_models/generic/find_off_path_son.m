function offpath_son = find_off_path_son(node_blamed, sons, path_to_error)

offpath_son = nan(size(node_blamed));

for i=1:length(node_blamed)
    aux = sons(node_blamed(i),[2,3]);
    if ismember(aux(1),path_to_error) % which son of the node to blame is not in the current path
        offpath_son(i) = aux(2);
    else
        offpath_son(i) = aux(1);
    end
end