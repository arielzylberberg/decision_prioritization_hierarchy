function [true_e, sigma_e, uni_e, true_s] = sample_unique_trials(n_uni_trials, kappa, noise_scaling, npatches, t_stim, seed)

%t_stim = 0.2

if nargin>4 && ~isempty(seed)
    rng(seed,'twister');
end

uni_scoh = [-0.5120, -0.2560, -0.1280, -0.0640, -0.0320, 0.0320, 0.0640, 0.1280, 0.2560, 0.5120];


sigma_e = sqrt(t_stim*(1 + noise_scaling * abs(uni_scoh)));


uni_e = t_stim*kappa*uni_scoh;

k = n_uni_trials * npatches;

true_e_id = randsample(1:length(uni_e),k,true);
true_e_id = reshape(true_e_id,[n_uni_trials,npatches]);
true_e = uni_e(true_e_id);
true_e = abs(true_e); %all correct to the right
true_s = sigma_e(true_e_id);


end

