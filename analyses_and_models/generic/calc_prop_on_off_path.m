function [prop_on, prop_on_per_level] = calc_prop_on_off_path(actions)



ntr = size(actions,1);
level = node_to_level(actions);

on_path = [];
level_node_blamed = [];
for i=1:ntr
    nactions = sum(~isnan(actions(i,:)));
    if nactions>=5
        bool = all(level(i,1:4)==[1:4]);
        if bool
            terminal_node_with_error = actions(i,4);
            node_queried_after_error = actions(i,5);
            [node_blamed, on_path_aux, level_node_blamed_aux] = find_node_blamed_after_error(terminal_node_with_error, node_queried_after_error);
            
            on_path = [on_path; on_path_aux];
            level_node_blamed = [level_node_blamed; level_node_blamed_aux];
            
        end
    end
end

% prop_on = sum(on_path==1)./(sum(on_path==0)+sum(on_path==1));
prop_on = mean(on_path==1);


prop_on_per_level = nan(3,1);
for i=1:3
    I = ismember(level_node_blamed,i);
    prop_on_per_level(i) = sum(on_path(I)==1)./(sum(on_path(I)==0)+sum(on_path(I)==1));
end
