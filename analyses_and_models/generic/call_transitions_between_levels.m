function [p,params] = call_transitions_between_levels(v_datasource, varargin)

if nargin==0
    v_datasource = 1;
end

addpath('../../analysis_behavior/')
addpath('../../generic/')
    
for idata = 1:length(v_datasource)
    datasource = v_datasource(idata);
    
    min_num_errors = 0;
    max_num_errors = inf;
    same_norm_flag = 0;
    v_suj = 1:4;
    coh_top = nan; % which means include them all
    for i=1:length(varargin)
        if isequal(varargin{i},'min_num_errors')
            min_num_errors = varargin{i+1};
        elseif isequal(varargin{i},'max_num_errors')
            max_num_errors = varargin{i+1};
        elseif isequal(varargin{i},'v_suj')
            v_suj = varargin{i+1};
        elseif isequal(varargin{i},'coh_top')
            coh_top = varargin{i+1};
        elseif isequal(varargin{i},'same_norm_flag')
            same_norm_flag = varargin{i+1};
        end
    end
    
 %%
 
    nsuj = length(v_suj);
    
    for k=1:nsuj
        suj = v_suj(k);
        [actions{k},coh{k}] = get_actions_and_coh(suj, datasource);
        
        %%
        npatches = 7;
        [lev{k},coh_dad{k},perf_rel_dad{k}, nqueries_dad{k}, perf_rel_dad_from_dad{k},...
            num_prev_errors{k}, coh_top_node{k}] ...
            = some_calcs(actions{k},coh{k},npatches);
        
    end
    
    
    %%
    count = zeros(4,4,nsuj);
    for k=1:nsuj
        %     n_err = num_prev_errors{k}';
        %     n_err = n_err(:);
        %     filt = num_prev_errors{k}>=0;
        %     filt = num_prev_errors{k}==0;
        
        
        filt = num_prev_errors{k}>=min_num_errors & ...
            num_prev_errors{k}<=max_num_errors;
        
        if ~isnan(coh_top)
            filt = filt & ismember(coh_top_node{k},coh_top);
        end
        
        count(:,:,k) = calc_num_transitions(lev{k},filt);
        
        
    end
    
    % normalize per subject
    for k=1:nsuj
        aux = count(:,:,k);
        norm = sum(aux(:));
        count(:,:,k) = aux/norm; 
    end
    
    % average over subjects
    v_count{idata} = nanmean(count,3);
    
end


%% plot

% to normalize all plots the same way
% same_norm_flag = 1; % was 0 before

if same_norm_flag
    max_val = max(cellfun(@max,cellfun(@max,v_count,'UniformOutput',false)));
else
    max_val = nan;
end

    

p = publish_plot(1,length(v_datasource));
for idata = 1:length(v_datasource)
    %%
    count = v_count{idata};

    if same_norm_flag
        count = count/max_val; %normalize
        [pplot, pars] = draw_transitions_between_levels(count, 0);
    else
        [pplot, pars] = draw_transitions_between_levels(count, 1);
    end
    
    p.copy_from_ax(pplot.h_ax,idata,1);
    
end

same_ylim(p.h_ax);

params.pars = pars;
params.max_val = max_val;
params.min_num_errors = min_num_errors;
params.max_num_errors = max_num_errors;
params.same_norm_flag = same_norm_flag;

end