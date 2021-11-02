function run_transition_matrices(v_datasource, min_num_errors, max_num_errors)

if nargin<1
    datasource = 1;
elseif nargin==1
    min_num_errors = 0;
    max_num_errors = inf;
elseif nargin==2
    max_num_errors = inf;
end

addpath('../../analysis_behavior/')
addpath('../../generic/')


datasets_string = {'Data','Shallow Bayes','Heuristic','Deep (stochastic) Bayes'};

for i=1:length(v_datasource)
    datasource = v_datasource(i);
    
    %%
    v_suj = 1:4;
    % datasource = 3;
    % v_suj = 1;
    % datasource = 1;
    nsuj = length(v_suj);
    
    for k=1:nsuj
        suj = v_suj(k);
        [actions{k},coh{k}] = get_actions_and_coh(suj, datasource);
        
        %%
        npatches = 7;
        [lev{k},coh_dad{k},perf_rel_dad{k}, nqueries_dad{k}, perf_rel_dad_from_dad{k},num_prev_errors{k}] ...
            = some_calcs(actions{k},coh{k},npatches);
        
    end
    
    %%
    where_to = zeros(15,14,nsuj);
    for k=1:nsuj
        %     n_err = num_prev_errors{k}';
        %     n_err = n_err(:);
        %     filt = num_prev_errors{k}>=0;
        %     filt = num_prev_errors{k}==0;
        
        filt = num_prev_errors{k}>=min_num_errors & ...
            num_prev_errors{k}<=max_num_errors;
        
        where_to(:,:,k) = calc_where_to(actions{k},filt);
    end
    
    v_where_to(:,:,i) = nanmean(where_to,3); % average over subjects
    
end

%%

p = publish_plot(1,length(v_datasource));
colores = colormap(hot);
% colores = cbrewer('div','Spectral',100);
for i=1:length(v_datasource)
    p.next();
    w = v_where_to(:,:,i);
    imagesc(w,[0,1])
    axis xy
    axis square
    colormap(colores);
    xlabel('Node From')
    if i==1
        ylabel('Node To');
    end
    title(datasets_string{v_datasource(i)});
end

cbar = draw_colorbar(colores,p.h_ax(end),[0,1]);

% p.unlabel_center_plots();
p.format('FontSize',12);

end
