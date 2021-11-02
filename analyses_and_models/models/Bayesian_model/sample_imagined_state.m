function [estado_sampleado, target_sampleado, id_estado_sampleado] = ...
    sample_imagined_state(pe_noblocks, all_states, uni_e, target_for_each_state, blocked)

% sample one state given the distribution over states and coherences

pright_noblocks = sum(pe_noblocks(:,uni_e>0),2); % assumes no zeros
[~, pstate] = ...
    calc_ptarget_given_pright_unblocked_and_blocks(all_states, ...
    pright_noblocks, target_for_each_state, blocked);

state_sampled = randsample(1:length(pstate),1,1,pstate);
target_sampleado = target_for_each_state(state_sampled); 

s = all_states(state_sampled,:);
estado_sampleado = nan(length(s),1);
id_estado_sampleado = nan(length(s),1);
for i=1:length(s)
    p = pe_noblocks(i,:);
    if s(i)==1
        p(uni_e<0) = 0;
    else
        p(uni_e>0) = 0;
    end

    id_estado_sampleado(i) = randsample(1:length(uni_e), 1, 1, p);
    estado_sampleado(i) = uni_e(id_estado_sampleado(i));
end
end
