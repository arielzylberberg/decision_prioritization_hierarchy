function [node_blamed_random,path_error] = blame_random_parent(node_with_error)

[levels, paths, sons] = get_levels_paths_sons();

I = paths(:,4)==node_with_error;
node_blamed_random = randsample(paths(I,1:3),1);

path_error = paths(I,1:3);

end