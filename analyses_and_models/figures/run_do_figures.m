function run_do_figures(id_analysis_to_plot)

datadir = '../';
addpath('../generic/');
addpath(genpath('../../matlab_files_addtopath/'));


%%

switch id_analysis_to_plot
    
    case 1
        
        % Figure 2
        run(fullfile(datadir,'models','detection_model','run_do_plot.m'));
        
    case 2
        % Figure 4
        run(fullfile(datadir,'analysis_motion_energy','run_kernels.m'));
        
    case 3
        % Supp Fig 1
        run(fullfile(datadir,'analysis_motion_energy','run_kernels_by_level.m'));
        
    case 4
        % tree - data
        addpath('../analysis_behavior');
        run_plot_tree(1);
        
    case 5
        % tree - model, heuristic
        run_plot_tree(22);
        
    case 6
        % tree - model - cheaper bayesian
        run_plot_tree(13);
        
    case 7
        % Figure 9
        p = run_fig_after_error_data_model([22, 1]);
        
    case 8
        % Figure 8
        
        % after Review:
        addpath(fullfile(datadir,'models','compare_models'));
        p1 = run_transitions_across_levels_scaled([1, 22, 4, 13], 0.25);
        p2 = run_transitions_across_levels_scaled([1, 22, 4, 13], 0.8);
        cla(p1.h_ax(3));
        cla(p1.h_ax(7));
        p1.copy_from_ax(p2.h_ax(3), 3);
        p1.copy_from_ax(p2.h_ax(7), 7);
        
    case 9
        % queries and rewards
        run(fullfile(datadir,'models','compare_models','run_plot_rewards_and_num_queries.m'));
        
    case 10
        % Figure 7
        datasets = [1,22,5,4,13,15,17:18];
        
        addpath('../analysis_behavior/'); 
        p = run_distrib_of_actions_different_models(datasets);
        set(gcf,'Position',[483   94  517  704]);
        str = {'A: Data', 'B: Heuristic model','C: Heuristic model fit to maximize reward',...
            'D: Bayesian model','E: Bayesian model with cheaper sampling','F: Bayesian model with cheaper sampling and re-queries',...
            'G: Information gain and probability gain','H: Impact'};
        for i=1:length(p.text.number_plot)
            p.text.number_plot(i).String = str{i};
            pos = p.text.number_plot(i).Position;
            pos(2) = pos(2) - 0.025;
            pos(3) = 0.9 - pos(1);
            p.text.number_plot(i).Position = pos;
        end
        p.format('FontSize',10);
        set(p.text.number_plot,'FontSize',11);
        
    case 11
        % For R1 plos comp biol
        addpath(fullfile(datadir,'models','compare_models'));
        run_transitions_across_levels_scaled([23,24],0.25,{'First 6 blocks','Last 6 blocks'});
        
    case 12
        % Learning effects
        run(fullfile(datadir,'analysis_behavior','run_learning_effects.m'));
        
end
end
