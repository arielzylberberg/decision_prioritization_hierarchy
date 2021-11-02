function run_many_trials(isuj)

addpath('../generic/');


if ~isLocalComputer
    parpool(20);
end

%%


[kappas,~, noise_scalings] = get_kappas_sdt_model();

kappa = kappas(isuj);
noise_scaling = noise_scalings(isuj);

ntrials = 1000;

max_actions = 100;
actions = nan(ntrials,max_actions);

npatches = 7;
t_stim = 0.2;

seed = 5175098;


[v_true_e, sigma_e, uni_e, v_true_s] = sample_unique_trials(ntrials, kappa, noise_scaling, npatches, t_stim, seed);
coh = v_true_e/(t_stim*kappa);


parfor itr = 1:ntrials
    disp(['Trial: ',num2str(itr)]);
    
    
    true_e = v_true_e(itr,:);
    true_s = v_true_s(itr,:);
    
    [all_states, target_for_each_state] = make_all_states(npatches);
    
    ne = length(uni_e);
    
    blocked = [];
    
    % eval best action
    pe_noblocks = 1./ne * ones(npatches,ne); % start with uniform
    
    for cont = 1:max_actions
        
        
        best_action = do_some_thinking(pe_noblocks, blocked, uni_e, sigma_e, ...
            all_states,target_for_each_state);
        actions(itr,cont) = best_action;
        
        
        % sample some evidence from the world
        if best_action<=npatches
            ipatch = best_action;
            ev_sample = true_e(ipatch) + randn * true_s(ipatch);
            
            % update
            pe_noblocks(ipatch,:) = update_patch_after_sample(uni_e,pe_noblocks(ipatch,:),ev_sample, sigma_e);
            
        elseif best_action==(npatches+npatches+1)
            break; % done, go to next trial
        else
            blocked = [blocked, best_action-npatches];
        end
                
    end
    
end

save(['output',num2str(isuj)],'actions','kappa','coh');

end


