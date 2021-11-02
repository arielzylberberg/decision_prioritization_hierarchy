function [p1,p2] = run_in_tree(datasource, min_num_errors, max_num_errors, v_suj)

if nargin==0
    datasource = 1;
elseif nargin==1
    min_num_errors = 0;
    max_num_errors = inf;
elseif nargin==2
    max_num_errors = inf;
end

if nargin<4 || isempty(v_suj)
    v_suj = 1:4;
end

addpath('../../analysis_behavior/');
addpath('../../generic/');


%%

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

where_to = nanmean(where_to,3); % average over subjects

figure()
imagesc(where_to)
axis xy
axis square
colormap(hot);
xlabel('Node From')
ylabel('Node To');

addpath('/Users/arielzy/Dropbox/Data/1 - LAB/01 - Proyectos/65 - HierarchTree/0560/analysis_behavior');
p1 = draw_transitions_in_tree(where_to);

p2 = draw_transitions_in_tree_more_compact(where_to);


end
