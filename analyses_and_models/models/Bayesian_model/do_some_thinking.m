function best_action = do_some_thinking(pe_noblocks, blocked, uni_e, sigma_e, ....
                            all_states,target_for_each_state)

% could be done until some conf interval
ntrials_sim = 2000;
npatches = size(all_states,2); 

R = nan(2*npatches+1,ntrials_sim);
for i=1:(2*npatches+1)
    for j=1:ntrials_sim
        start_with_patch = i;
    
        R(i,j) = do_random_explore(start_with_patch,sigma_e, pe_noblocks, ...
            blocked,uni_e,all_states,target_for_each_state);
        
    end
end

[~,best_action] = max(nanmean(R,2));