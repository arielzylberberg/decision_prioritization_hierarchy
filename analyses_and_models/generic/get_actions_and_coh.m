function [actions,coh,group,labels] = get_actions_and_coh(suj, datasource)


dataset_labels = {'Data','Bayes shallow','Heuristic','Bayes','H-max','BayesCost','H-ratio','H-scale-noise',...
    'H-LDA','H-adapt-exp','H-LDA-A','H-adapt-one-exp-row','Bayes cheap','H-ratio-guess','Bayes-cheap-repeats',...
    'shallow_1','shallow_2','shallow_3','H-integration','H-conf','H-conf-last','H-conf-last-signed',...
    'data_early_ses','data_late_ses',...
    'Data_suj1','Data_suj1','Data_suj3','Data_suj4'};

labels = dataset_labels(datasource);


dir_base = '/Users/arielzy/Dropbox/Data/1 - LAB/01 - Proyectos/65 - HierarchTree/clean_for_sharing/';

dir_data = fullfile(dir_base,'data');
dir_model = fullfile(dir_base,'analyses_and_models','models');
dir_model_alt = fullfile(dir_base,'analyses_and_models','models_alt_data');


if length(suj)>1% many subjects
    actions = [];
    coh = [];
    group = [];
    for i=1:length(suj)
        [aa,cc] = get_actions_and_coh(suj(i), datasource);
        actions = [actions; aa];
        coh = [coh;cc];
        group = [group;ones(size(aa,1),1)*suj(i)];
    end
else
    
    switch datasource
        case 1 % data
            
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group,[suj]);
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            %         end
            
        case 4 % bayesian simulations
            load(fullfile(dir_model, 'Bayesian_model',['output',num2str(suj),'.mat']));
            
            
        case 5 % heuristic, max reward
            load(fullfile(dir_model_alt, 'model_heuristic_optimal',['output_heuristic_model',num2str(suj),'.mat']));
            
            
            
        case 6 % Bayesian sim, with different cost structure
            
            load(fullfile(dir_model_alt, 'Bayesian_cheaper_sampling',['output',num2str(suj),'_p2.mat']));
            
        case 7 % heuristic optimal, just optim ratio
            load(fullfile(dir_model_alt, 'model_heuristic_optimal',['model_heuristic_adapt_criterion_one_exp_row_scale_noise_just_ratios',num2str(suj),'.mat']));
            
        
        case 13 % Bayes shallow simulations
            load(fullfile(dir_model_alt, 'Bayesian_w_simulations_scale_noise_cheaper',['output',num2str(suj),'.mat']));
            
            
        case 15 % Bayes cheaper repeats
            load(fullfile(dir_model_alt, 'Bayesian_cheaper_repeats',['output',num2str(suj),'.mat']));
            
        case 16 % shallow 1
            load(fullfile(dir_model_alt, 'Shallow_metrics_exact',['output_s',num2str(suj),'_m',num2str(1),'.mat']));
            
        case 17 % shallow 2
            load(fullfile(dir_model_alt, 'Shallow_metrics_exact',['output_s',num2str(suj),'_m',num2str(2),'.mat']));
            
        case 18 % shallow 3
            load(fullfile(dir_model_alt, 'Shallow_metrics_exact',['output_s',num2str(suj),'_m',num2str(3),'.mat']));
            
        case 22
            load(fullfile(dir_model, 'heuristic_model',['output_heuristic_model',num2str(suj),'.mat']));
            
            
        case 23 % data, early blocks/trials
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group,[suj]) ...
                & d.alldata.session<=6; % testing !!
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            
        case 24 % data, late block/sessions
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            J = ismember(d.alldata.group,[suj]);
            max_sess = nanmax(d.alldata.session(J));
            I = J & (d.alldata.session>(max_sess-6)); % testing !!
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
        case 25 % data, suj1
            
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group, 1 );
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            
        case 26 % data, suj2
            
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group, 2 );
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            
        case 27 % data, suj3
            
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group, 3 );
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            
        case 28 % data, suj4
            
            d = load(fullfile(dir_data, 'alldata.mat'),'alldata');
            I = ismember(d.alldata.group, 4 );
            actions_fun = d.alldata.actions_fun(I,:);
            actions = actions_fun;
            coh = d.alldata.coh_fun(I,:)/1000;
            
            
    end
    
    group = suj * ones(size(actions,1),1);
    
end

end