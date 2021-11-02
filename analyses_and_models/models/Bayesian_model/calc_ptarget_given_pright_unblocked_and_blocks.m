function [pc_targets, pstate] = ...
    calc_ptarget_given_pright_unblocked_and_blocks(all_states, pright_noblocks, target_for_each_state, blocked)


% calc pstates as indep
pstate = calc_pstate_indep(all_states,pright_noblocks);

% block the ones that are blocked and renormalize among the others
I = ismember(target_for_each_state,blocked);
pstate(I) = 0;
pstate = pstate/sum(pstate);

% compute the probability correct of each target, given the block (curva_suma...)
pc_targets = calc_ptarget_given_pstate(pstate, target_for_each_state);

end

function pc_targets = calc_ptarget_given_pstate(pstate, target_for_each_state)
[~, pc_targets] = curva_suma(pstate, target_for_each_state);
end


function pstate_indep = calc_pstate_indep(all_states,pright)
%calc the prob of each state given the pright vector - assumes indep

aux = bsxfun(@times,all_states==1,pright') + bsxfun(@times,all_states==-1,1-pright');
pstate_indep = prod(aux,2);

end