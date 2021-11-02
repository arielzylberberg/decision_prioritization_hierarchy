addpath('../../generic/');
addpath(genpath('../../../matlab_files_addtopath/'));


%% fit a couple of extra params of the heuristic model

do_fit = 1;
simulate_from_actual_coh_flag = 0;


datadir = '../detection_model/';
        
if do_fit
    % get rew data per suj
    %     rew_data = get_data_reward_rates();
    
    err_criterion = 11;
    % optim_flag = 1;
    
    
    for suj=1:4
        
        [~,~,~, actions_data] = get_data_reward_rates(suj);
        
        model_fit = load(fullfile(datadir,['optim',num2str(suj),'.mat']));
        kappa = model_fit.theta(1);
        coh0 = model_fit.theta(2);
        actions_data = actions_data{1};
        criterion_on_ev = model_fit.theta(3:5);
        noise_scaling = model_fit.theta(6);
        % crit_scaling_queries = model_fit.theta(7);
        lambda_scaling_queries = model_fit.theta(7);
        
        
        if simulate_from_actual_coh_flag
            
            [~, ~, coh_fun, actions_fun] = get_data_reward_rates(suj);
            coh = coh_fun{1};
            actions_data = actions_fun{1};
        else
            
            ucoh = [0.032,0.064,0.128,0.256,0.512];
            ntrials = 50000;
            
            npatches = 7;
            N = ntrials * npatches;
            coh = randsample(ucoh,N,true);
            coh = reshape(coh,ntrials,npatches);
        end
        
    
            
            %             load params_max_reward
            tl = [0,0,0,0,0.5];
            th = [0,0,0,0,0.95];
            tg = [0,0,0,0,0.7];
        
        
        fn_fit = @(theta) (wrapper_fit(theta, actions_data, criterion_on_ev,kappa,coh0,coh,noise_scaling,...
            lambda_scaling_queries,err_criterion));
        
        
        options = optimset('Display','final','TolFun',.001,'FunValCheck','on');
        ptl = tl;
        pth = th;
        [theta,fval,exitflag,output] = bads(@(theta) fn_fit(theta),tg,tl,th,ptl,pth,options);
        
        %         blame_bias_multiplier_fit(suj) = theta(1);
        %         criterion_multiplier_fit(suj) = theta(2);
        %         prand_node_to_blame(suj) = theta(3);
        v_theta(suj,:) = theta;
        
    end
    save fit_to_match_reward v_theta
end


%% eval model - fitted or not

nsuj = 4;
use_fitted_params = 1;
simulate_from_actual_coh_flag = 0;
% use_fitted_params = 0;
for suj=1:nsuj
    
%     model_fit = load(['../sdt_model_adapt_criterion/optim',num2str(suj),'.mat']);
%     model_fit = load(['../sdt_model_adapt_criterion_only_one/optim',num2str(suj),'.mat']);
    model_fit = load(fullfile(datadir,['optim',num2str(suj),'.mat']));
    kappa = model_fit.theta(1);
    coh0 = model_fit.theta(2);
    criterion_on_ev = model_fit.theta(3:5);
    crit_scaling_parent = model_fit.theta(6);
    lambda_scaling_queries = model_fit.theta(7);
    
    ucoh = [0.032,0.064,0.128,0.256,0.512];
    % kappa = 3.07;
    
    % kappa = 1.8;
    
    
    if simulate_from_actual_coh_flag
        
        [~, ~, coh_fun, actions_fun] = get_data_reward_rates(suj);
        coh = coh_fun{1};
        actions_data = actions_fun{1};
    else
        
        ucoh = [0.032,0.064,0.128,0.256,0.512];
        ntrials = 50000;
        
        npatches = 7;
        N = ntrials * npatches;
        coh = randsample(ucoh,N,true);
        coh = reshape(coh,ntrials,npatches);
    end
    
    
    
    if 0
        load fit_to_match_reward
        
    else
        load fit_to_match_reward
        %         v_theta(:,end) = 0.6;
        % to do
    end
    %     blame_bias_multiplier = 0;
    
    [err, actions, evidence] = heuristic_model(criterion_on_ev,kappa,coh0,coh,crit_scaling_parent,...
        lambda_scaling_queries, v_theta(suj,:));
    
    filename = ['output_heuristic_model',num2str(suj)];
    save(filename,'actions','coh','evidence');
    
end

% plot
rew_data = get_data_reward_rates();
for i=1:4
    filename = ['output_heuristic_model',num2str(i)];
    aux = load(filename,'actions');
    [rew_model(i)] = rew_from_actions_fun(aux.actions);
end
figure();
plot(1:4,rew_data,'.-');
hold all
plot(1:4,rew_model,'.-');






