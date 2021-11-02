function [node_blamed, on_path, level_node_blamed, path_to_error] = find_node_blamed_after_error(terminal_node_with_error, node_queried_after_error)



[levels, paths, sons] = get_levels_paths_sons();


node_blamed = nan;
on_path = nan;
        
I = paths(:,end)==terminal_node_with_error;
path_to_error = paths(I,:);

if ismember(node_queried_after_error,path_to_error(1:end-1))
    % if in the path, the blamed node is the one queried
    node_blamed = node_queried_after_error;
    on_path = 1;
else % find the parent of the queried node, and see if it in the path
    
    I = sons(:,2)==node_queried_after_error | sons(:,3)==node_queried_after_error;
    if sum(I)==1 && ismember(sons(I,1),path_to_error)
        node_blamed = sons(I,1);
        on_path = 0;
    end
    
end

if ~isnan(node_blamed)
    level_node_blamed = levels(node_blamed);
else
    level_node_blamed = nan;
end




