function [all_states, target_for_each_state, mat_patches_to_targets] = make_all_states(npatches)

u = [-1,1];
switch npatches
    case 1
        all_states = u';
        childs = [1,2,3];
    case 3
        all_states = cartesian_product(u,u,u);
        childs = [[1,2,3];[2,4,5];[3,6,7]];
    case 7
        all_states = cartesian_product(u,u,u,u,u,u,u);
        childs = [[1, 2, 3];[2, 4, 5];[3, 6, 7];[4, 8, 9];[5, 10, 11];[6, 12, 13];[7,14,15]];
end
nstates = size(all_states,1);

target_for_each_state = nan(nstates,1);
for i=1:nstates
    terminal_bool = false;
    curr_state = 1;
    while ~terminal_bool
        if all_states(i,curr_state)==-1
            curr_state = childs(curr_state,2);
        else
            curr_state = childs(curr_state,3);
        end
        if curr_state>size(all_states,2)
            terminal_bool = true;
            target_for_each_state(i) = curr_state-npatches;
        end
    end
end

[u,mat_patches_to_targets] = curva_media(all_states,target_for_each_state,[],0);

end


