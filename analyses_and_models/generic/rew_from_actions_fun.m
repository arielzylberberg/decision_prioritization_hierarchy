function [av_rew,rew_per_trial] = rew_from_actions_fun(actions,payoffs)
if nargin==1
    payoffs = get_payoffs();
end


R = (actions<=7)*payoffs(1)+(actions>7 & actions<15)*payoffs(2)+(actions==15)*payoffs(3);
rew_per_trial = nansum(R,2);
av_rew = mean(rew_per_trial);

end