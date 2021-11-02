function [rew,rew_per_trial, coh_fun, actions] = get_data_reward_rates(v_suj)

if nargin==0
    v_suj = 1:4;
end

for i=1:length(v_suj)
    suj = v_suj(i);
    d = load('../../../data/alldata.mat');
    I = ismember(d.alldata.group,[suj]);
    actions_fun = d.alldata.actions_fun(I,:);
    actions{i} = actions_fun;
    [rew(i),rew_per_trial{i}] = rew_from_actions_fun(actions{i});
    
    coh_fun{i} = d.alldata.coh_fun(I,:)/1000;
end
end