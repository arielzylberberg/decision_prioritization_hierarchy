function [after_error,p1,p2] = run_on_path_off_path_other(uni_suj,datasource)

addpath(genpath('../generic'));

[actions,coh_per_patch,group] = get_actions_and_coh(uni_suj, datasource);


[action_num,trial_num] = find(actions'>7 & actions'<15);


K1 = sub2ind(size(actions),trial_num,action_num+1);
after_error.fnode = actions(K1);
after_error.group = group(trial_num);
after_error.trial_id = trial_num;


node_queried_after_error = actions(K1);
K0 = sub2ind(size(actions),trial_num,action_num);
terminal_node_with_error = actions(K0);
after_error.error_fnode = terminal_node_with_error;
after_error.action_num = action_num;

% number of error in each trial
ee = cumsum(actions>7 & actions<15,2);
ee = ee(K0);
[~,isort] = sort(trial_num);
after_error.error_number = ee(isort);

after_error.visited = zeros(size(trial_num,1),15);
for i=1:length(trial_num)
    after_error.visited(i,:) = histcounts(actions(trial_num(i),1:action_num(i)),[1:16]);
end
after_error.visited_per_level = [after_error.visited(:,1),sum(after_error.visited(:,[2,3]),2),...
    sum(after_error.visited(:,[4:7]),2),sum(after_error.visited(:,[8:15]),2)];


I = action_num~=1; % in case the first action is an error
Km1 = sub2ind(size(actions),trial_num(I),action_num(I)-1); % before the error
after_error.action_before_error = actions(Km1);
node_to_levels = [1,2,2,3,3,3,3,4,4,4,4,4,4,4,4]';
after_error.action_before_error_level = node_to_levels(after_error.action_before_error);



[u,~,ic] = unique([terminal_node_with_error, node_queried_after_error],'rows');
for i=1:size(u,1)
    [u_node_blamed(i), u_on_path(i), u_level_node_blamed(i), u_path_to_error(i,:)] = ...
        find_node_blamed_after_error(u(i,1), u(i,2));
end

after_error.node_blamed = u_node_blamed(ic)';
after_error.level_node_blamed = u_level_node_blamed(ic)';
after_error.on_path = u_on_path(ic)';
n = length(trial_num);
after_error.coh = nan(n,1);

K = after_error.node_blamed<=7;
L = sub2ind(size(coh_per_patch), trial_num(K), after_error.node_blamed(K));

after_error.coh = nan(n,1);
after_error.coh(K) = coh_per_patch(L);



after_error.level_node_blamed(ismember(after_error.node_blamed,1)) = 1;
after_error.level_node_blamed(ismember(after_error.node_blamed,[2,3])) = 2;
after_error.level_node_blamed(ismember(after_error.node_blamed,[4:7])) = 3;



[~, paths, ~] = get_levels_paths_sons();
for i=1:7 % patches
    A{i} = cumsum(actions==i,2);
end

% same, but count actions in a row
A_row = cell(7,1);
for ip=1:7 % patches
    A_aux = zeros(size(actions));
    for i=1:size(actions,1)
        for j=1:size(actions,2)
            if actions(i,j)==ip
                A_aux(i,j) = 1;
            end
            if j>1 && actions(i,j)==actions(i,j-1)
                A_aux(i,j) = A_aux(i,j) + A_aux(i,j-1);
            end
        end
    end
    A_row{ip} = A_aux;
end


after_error.num_prev_queries_on_path_to_error = zeros(n,3);
after_error.num_prev_queries_on_path_to_error_row = zeros(n,3);


for i=1:length(trial_num)
    
    tr = trial_num(i);
    act_num = action_num(i);
    
    if act_num>1
        u = terminal_node_with_error(i);
        path_to_error = paths(u-7,1:3);

        for j=1:3
            after_error.num_prev_queries_on_path_to_error(i,j) = A{path_to_error(j)}(tr,act_num-1);
            after_error.num_prev_queries_on_path_to_error_row(i,j) = max(A_row{path_to_error(j)}(tr,1:act_num-1));
        end

        after_error.coh_path_to_error(i,:) = coh_per_patch(tr, path_to_error);
    
        
    end
end




I = sub2ind(size(after_error.coh_path_to_error),1:n,ceil(rand(1,n)*3));
after_error.coh_node_blamed_at_random = after_error.coh_path_to_error(I)';


% coherence signed: negative is for errors
coh_multip  = coh_multiplier(after_error.error_fnode);
coh_path_to_error_rel = coh_multip.*after_error.coh_path_to_error;
after_error.coh_signed = nan(size(after_error.coh));
I = ~isnan(after_error.level_node_blamed);
K = sub2ind(size(coh_path_to_error_rel), find(I), after_error.level_node_blamed(I));
after_error.coh_signed(I) = coh_path_to_error_rel(K);



after_error.coh_path_to_error_signed = after_error.coh_path_to_error.*coh_multip;


%%
% for consistency with an older version of the file
p1 = [];
p2 = [];


