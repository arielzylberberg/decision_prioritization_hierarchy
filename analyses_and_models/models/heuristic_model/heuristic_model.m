function [err, actions, evidence, coh_act] = heuristic_model(criterion_on_ev,kappa,coh0,coh,...
    noise_scaling,lambda_slope_queries, theta)


% rng(22323,'twister'); % new

npatches = 7;
% rewards = [-1,-3,10];

dotdur = 0.2;
mu = dotdur * kappa * (coh+coh0);

uni_coh = unique(coh(:)+coh0);
uni_coh = sort([-uni_coh(:);uni_coh(:)]);
uni_mu = dotdur * kappa * uni_coh;
uni_sigma = sqrt(dotdur*(1 + noise_scaling * abs(uni_coh)));

[levels, paths, sons] = get_levels_paths_sons();

% levels = [1,2,2,3,3,3,3];
% 
% paths = [1,2,4,8; 
%          1,2,4,9;
%          1,2,5,10;
%          1,2,5,11;
%          1,3,6,12;
%          1,3,6,13;
%          1,3,7,14;
%          1,3,7,15];
% 
% %node left right
% sons = [1,2,3;
%         2,4,5;
%         3,6,7;
%         4,8,9;
%         5,10,11;
%         6,12,13;
%         7,14,15];
    
max_nodes = max(paths(:));    
max_actions = 200;    
ntrials = size(coh,1);
actions = nan(ntrials,max_actions);
evidence = nan(ntrials,max_actions);
for itr=1:ntrials
    stop = 0;
    current_node = 1;
    cont = 0;
    ev_last = nan(npatches,1);
    nqueries_per_node = zeros(max_actions,1);
    visited = zeros(max_nodes,1);
    visits_in_a_row = 0;
    prev_current_node = nan;
    confidence_right_motion = nan(npatches,1);
    while ~stop && cont<max_actions
        nqueries_per_node(current_node) = nqueries_per_node(current_node) + 1;
        visited(current_node) = visited(current_node) + 1;
        
        if prev_current_node==current_node
            visits_in_a_row = visits_in_a_row+1;
        else
            visits_in_a_row = 0;
        end
        
%         visited(current_node) = 1;
        cont = cont+1;
        actions(itr,cont) = current_node;

        
        % DONE
        if current_node==15
            
            stop = 1;
        
        % TERMINAL, NOT DONE
        elseif current_node>7 && current_node<15
            
            
            % check the evidence for the nodes that got you here, and
            % assume there was an error at the node w/ the weakest evidence
            
            [next_node, node_blamed] = find_who_to_blame_after_terminal_error(current_node, ...
                paths, sons, visited, ev_last,confidence_right_motion,theta);
            
            if ~isnan(node_blamed)
                %ev_last(node_blamed) = nan; % to avoid going back and forth
                confidence_right_motion(node_blamed) = nan; % to avoid going back and forth
            end
        
        % UPPER NODES
        else
            
            sigma = sqrt(dotdur*(1 + noise_scaling * coh(itr,current_node)));
            ev = mu(itr,current_node) + randn*sigma;
            
            evidence(itr,cont) = ev;
            ev_last(current_node) = ev;
            
            % ev_in_row = evidence(itr,cont-visits_in_a_row:cont);
            % confidence(current_node) = calc_confidence(ev_in_row, uni_mu, uni_sigma);
            confidence_right_motion(current_node) = calc_confidence(ev, uni_mu, uni_sigma); % use only the last sample
            
            parents = get_parents(current_node);
            if isempty(parents)
                visits_parents = 0;
            else
                visits_parents = sum(visited(parents));
            end
            
%             crit = criterion_on_ev(levels(current_node)) * (1 + crit_slope_queries * visited(current_node)) .* ...
%                     (1 + crit_slope_parents * visits_parents);
                
            crit = criterion_on_ev(levels(current_node)) * exp(-lambda_slope_queries*(visits_in_a_row));
            
            
            % opt in or out
            if ev<-crit
                next_node = sons(current_node,2);
                
            elseif ev>crit
                next_node = sons(current_node,3);
                
            else
                next_node = current_node;
            end
            
            
            
            % if terminal and visited already, go to another one
            if next_node>7 && next_node<15 && visited(next_node)>=1
                %                 next_node = 1; % go to top
                [next_node, node_blamed] = find_who_to_blame_after_terminal_error(next_node, ...
                    paths, sons, visited, ev_last,confidence_right_motion,theta);
                if ~isnan(node_blamed)
                    % ev_last(node_blamed) = nan; % to avoid going back and forth
                    confidence_right_motion(node_blamed) = nan; % to avoid going back and forth
                end
            end
            
            
        end
        prev_current_node = current_node;
        current_node = next_node;
%         disp(actions(itr,1:cont));
    end
    
    
end


%%
err = -rew_from_actions_fun(actions);
% r = (actions<=7)*rewards(1)+(actions>=8 & actions<15)*rewards(2)+(actions==15)*rewards(3);
% rew_per_trial = sum(r,2);
% 
% err = [-mean(rew_per_trial)];

%%
if nargout>1
    [I,J] = find(actions<=7);
    a = actions<=7;
    coh_act = nan(size(actions));
    coh_act(a) = coh(sub2ind(size(coh),I,actions(a))); % coherence for each action
    
end

%%
% fprintf_params({'c1','c2','c3'},-err,criterion_on_ev);



end