function [lev,coh_dad,perf_rel_dad, nqueries_dad, perf_rel_dad_from_dad,num_prev_errors, coh_top_node] ...
    = some_calcs(actions,coh,npatches)

if nargin==2
    npatches = size(coh,2);
end

if npatches==7
    levels = [1,2,2,3,3,3,3,4,4,4,4,4,4,4,4];
    child_dad = [2,1;3,1;4,2;5,2;6,3;7,3;8,4;9,4;10,5;11,5;12,6;13,6;14,7;15,7];
elseif npatches==3
    levels = [1,2,2,3,3,3,3];
    child_dad = [2,1;3,1;4,2;5,2;6,3;7,3];
    
end

% nobs = [0:10];

[ntrials,nactions] = size(actions);

% for each sampled node, calc the number of times the father was queried
nqueries_dad = nan(size(actions));
coh_dad = nan(size(actions));
for i=1:ntrials
    for j=1:nactions
        ind = child_dad(:,1)==actions(i,j);
        if sum(ind)>0
            dad = child_dad(ind,2);
            % count
            nqueries_dad(i,j) = sum(actions(i,1:j)==dad);
            coh_dad(i,j) = coh(i,dad);
        end
    end
end

lev = nan(size(actions));
for i=1:length(levels)
    ind = actions==i;
    lev(ind) = levels(i);
end

perf_rel_dad = nan(size(actions));
perf_rel_dad(ismember(actions,[3:2:15])) = 1;
perf_rel_dad(ismember(actions,[2:2:15])) = 0;

% perf rel only from dad, that is, only counting performance for which
% the action was preceeded by a query at the parent's node. This is
% important because sometimes you can get things right from second choices
[I,J] = find(ismember(actions,[2:15]));
I(J==1) = [];
J(J==1) = [];
ss = sub2ind(size(actions),I,J);
ss_prev = sub2ind(size(actions),I,J-1);
a = actions([ss(:),ss_prev(:)]);

[~,K] = ismember(a(:,1),child_dad(:,1));

include = child_dad(K,2)==a(:,2);
perf_rel_dad_from_dad = perf_rel_dad;
perf_rel_dad_from_dad(ss(~include)) = nan;


coh_top_node = repmat(coh(:,1),1,size(actions,2));
coh_top_node(isnan(actions)) = nan;

%%
num_prev_errors = nan(size(actions));
for i=1:size(actions,1)
    num_prev_errors(i,:) = cumsum(ismember(actions(i,:),[8:14]));
end
num_prev_errors(isnan(actions)) = nan;