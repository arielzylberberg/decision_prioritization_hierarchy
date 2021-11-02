function [err, actions_model] = wrapper_fit(theta, actions_data, criterion_on_ev,kappa,coh0,coh,noise_scaling,...
                                    crit_slope_queries, err_criterion)


[~,actions_model] = heuristic_model(criterion_on_ev,kappa,coh0,coh, noise_scaling,crit_slope_queries, theta);


% err_criterion = 1;
switch err_criterion
    case 1 % average rew
        [av_rew_model] = rew_from_actions_fun(actions_model);
        [av_rew_data] = rew_from_actions_fun(actions_data);

        err = abs(av_rew_data - av_rew_model);
        
    case 2 % trial-by-trial difference in rew rate (assumes indentical trials simulated for model and data)
        [~,trial_rew_model] = rew_from_actions_fun(actions_model);
        [~,trial_rew_data] = rew_from_actions_fun(actions_data);

        err = sqrt(sum((trial_rew_data - trial_rew_model).^2));
        
    case 3 % match the prop of queries at each level
        [Ld,Ed] = get_prop_queries_and_errors(actions_data);
        [Lm,Em] = get_prop_queries_and_errors(actions_model);
        % minimize the dife
        err = sqrt(sum((Ld-Lm).^2));
    case 4 % match the error rates
        [Ld,Ed] = get_prop_queries_and_errors(actions_data);
        [Lm,Em] = get_prop_queries_and_errors(actions_model);
        % minimize the dife
        err = sqrt((Ed-Em).^2);
        
    case 5 % combine 1 and 3
        [av_rew_model] = rew_from_actions_fun(actions_model);
        [av_rew_data] = rew_from_actions_fun(actions_data);
        
        [Ld,Ed] = get_prop_queries_and_errors(actions_data);
        [Lm,Em] = get_prop_queries_and_errors(actions_model);
        % minimize the dife
        err = sqrt(sum((Ld-Lm).^2)) + abs(av_rew_data - av_rew_model);
        
    case 6 % fit the where-to matrix
        where_to_data = calc_where_to(actions_data);
        where_to_model = calc_where_to(actions_model);
        err = sum(abs(where_to_data(:)-where_to_model(:))); % see a smarter way
    
    case 7 % combine 6 and 1
        [av_rew_model] = rew_from_actions_fun(actions_model);
        [av_rew_data] = rew_from_actions_fun(actions_data);
        err1 = abs(av_rew_data - av_rew_model);
        
        where_to_data = calc_where_to(actions_data);
        where_to_model = calc_where_to(actions_model);
        err2 = mean(abs(where_to_data(:)-where_to_model(:))); % see a smarter way
        
        w = 0.5;
        err = w*err1 + (1-w)*err2;
        
    case 8 % just maximize reward for the model
        [av_rew_model] = rew_from_actions_fun(actions_model);
        err = -av_rew_model;
    
    case 9 % max rew but penalize dev from prop_on
        [av_rew_model] = rew_from_actions_fun(actions_model);
        err1 = -av_rew_model;
        
        [prop_on_model,prop_on_model_per_level] = calc_prop_on_off_path(actions_model);
        [prop_on_data,prop_on_data_per_level] = calc_prop_on_off_path(actions_data);
        
        err2 = abs(prop_on_model-prop_on_data);
%         err2 = sqrt(sum((prop_on_model_per_level-prop_on_data_per_level).^2));
        if isnan(err2)
            err2 = sqrt(1);
        end
        err = err1 + 3*err2;
        % err = err1 + 10*err2;
        
        
    case 10 % get rewards right and penalize deviations from prop_on
        [av_rew_model] = rew_from_actions_fun(actions_model);
        [av_rew_data] = rew_from_actions_fun(actions_data);

        err1 = abs(av_rew_data - av_rew_model);
        
        [~,prop_on_model_per_level] = calc_prop_on_off_path(actions_model);
        [~,prop_on_data_per_level] = calc_prop_on_off_path(actions_data);
        err2 = sqrt(sum((prop_on_model_per_level-prop_on_data_per_level).^2));
        if isnan(err2)
            err2 = sqrt(3);
        end
        err = err1 + 2*err2;
        
    case 11 % penalize dev from prop_on
                
        [prop_on_model,prop_on_model_per_level] = calc_prop_on_off_path(actions_model);
        [prop_on_data,prop_on_data_per_level] = calc_prop_on_off_path(actions_data);
        
        err = abs(prop_on_model-prop_on_data);

        if isnan(err)
            err = sqrt(1);
        end

        
        
        
end

variables = {'m1a','m2a','m1b','m2b','p','c1','c2','c3','kappa','coh0','noise scaling',...
            'crit slope queries'};
params = [theta,criterion_on_ev,kappa,coh0,noise_scaling,crit_slope_queries];
fprintf_params(variables, err, params);

end