function [next_node, node_blamed] = find_who_to_blame_after_terminal_error(current_node, paths, ...
    sons, visited, ev_last, confidence_rightward_motion, theta)




low_conf = theta(5);

found_who_to_blame = 0;

I = paths(:,end)==current_node;
J = paths(I,1:3);


% ev_last_scaled = nan(size(ev_last));
% ev_last_aux = abs(ev_last(J));
% ev_last_scaled(J) = abs(ev_last(J));

conf = nan(size(confidence_rightward_motion));
conf(J) = confidence_rightward_motion(J);
coh_multip  = coh_multiplier(current_node);
conf(J(coh_multip<0)) = 1-conf(J(coh_multip<0));

while found_who_to_blame==0
    
    if all(isnan(conf(J)))
        % choose unvisited terminal at random
        node_blamed = nan;
        next_node = randsample(8:15,1,1,visited(8:15)==0);
        break;
    end
    
    [~,K] = nanmin(conf(J));
    
    node_blamed = J(K); % node blamed for the error
    
    next_node = find_off_path_son(node_blamed, sons, paths(I,:));
    
    if next_node<=7 || visited(next_node)==0 % to avoid repeating terminal nodes
        found_who_to_blame = 1;
        %     end
    else
        conf(node_blamed) = nan; % to avoid going back and forth
    end
    
end

if ~isnan(node_blamed)
    Q = find(conf(J)<low_conf);
    if length(Q)>1 % more than one with low confidence
        K = Q(1); % highest level of those below threshold
        node_blamed = J(K);
        next_node = node_blamed;
    end
end

end



