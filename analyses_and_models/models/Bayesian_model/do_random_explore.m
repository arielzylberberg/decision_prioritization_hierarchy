function [sumR, actions, R] = do_random_explore(start_with_patch,sigma_e, pe_noblocks, ...
    blocked,uni_e,all_states,target_for_each_state)


npatches = size(all_states,2);

max_n_actions = 2000;
actions = nan(max_n_actions,1);

payoffs = get_payoffs();
R = zeros(max_n_actions,1);

% sample one 'correct' state, from the posterior, and use it to sample
% momentary evidence
[estado_sampleado, target_sampleado, id_estado_sampleado] = ...
    sample_imagined_state(pe_noblocks,all_states,uni_e,target_for_each_state,blocked);


done = 0;
i = 0;
while ~done
    i = i+1;
    % decide on the next action
    if i==1
        next_action = start_with_patch;
    else
        
        go_for_terminal = rand<((npatches+1)/(2*npatches+1)); % 8/15
        if go_for_terminal
            % go for the peakiest one
            pright_noblocks = sum(pe_noblocks(:,uni_e>0),2); % assumes no zeros
            pc_targets = ...
                calc_ptarget_given_pright_unblocked_and_blocks(all_states, ...
                pright_noblocks, target_for_each_state, blocked);
            imax = find(pc_targets==max(pc_targets));

            if numel(imax)>1
                imax = randsample(imax,1);
            end
            next_action = imax + npatches;
            
        else
            next_action = randsample(npatches,1);
        end
        
    end
    
    if next_action<=npatches
        
        R(i) = payoffs(1);
        
        ipatch = next_action;
        
        id = id_estado_sampleado(ipatch);
        ev_sample = estado_sampleado(ipatch) + sigma_e(id) * randn();

        pe_noblocks(ipatch,:) = update_patch_after_sample(uni_e,pe_noblocks(ipatch,:),ev_sample,sigma_e);

    else % terminal nodes
        
        method = 2;
        switch method 
            case 1
                % prob of correct to the chosen terminal node
                pright_noblocks = sum(pe_noblocks(:,uni_e>0),2); % assumes no zeros
                [pc_targets] = ...
                    calc_ptarget_given_pright_unblocked_and_blocks(all_states, ...
                    pright_noblocks, target_for_each_state, blocked);


                if pc_targets(next_action-npatches)>rand()
                    R(i) = payoffs(3);
                    done = 1; % finish 
                else
                    R(i) = payoffs(2);
                    blocked = unique([blocked, next_action-npatches]);
                end
                
            case 2
                if next_action==(npatches+target_sampleado)
                    R(i) = payoffs(3);
                    done = 1; % finish 
                else
                    R(i) = payoffs(2);
                    blocked = unique([blocked, next_action-npatches]);
                end
        end
        
    end

    actions(i) = next_action; % store
    
end
sumR = sum(R);

end