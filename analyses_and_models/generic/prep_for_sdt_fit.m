function [choice, optedout,level,coh, correct, group,nquery,sbet_on, dotdur] = prep_for_sdt_fit(actions,coh,group)



if nargin == 2
    group = nan(size(actions));
end

dotdur = 0.2*ones(size(actions));

[ntrials,nactions] = size(actions);
[levels, ~, sons] = get_levels_paths_sons();
choice = nan(size(actions));
optedout = zeros(size(actions));
level = nan(size(actions));
coh_patch = nan(size(actions));
nquery = ones(size(actions));
for i=1:ntrials
    for j=1:nactions-1
        if actions(i,j)<=7 && actions(i,j+1)==actions(i,j)
            optedout(i,j) = 1;
            nquery(i,j+1) = nquery(i,j)+1;
        elseif actions(i,j)<=7 && actions(i,j+1)==sons(actions(i,j),2)
            choice(i,j) = 0;
        elseif actions(i,j)<=7 && actions(i,j+1)==sons(actions(i,j),3)
            choice(i,j) = 1;
            
        end
        if actions(i,j)<=7
            coh_patch(i,j) = coh(i, actions(i,j));
            level(i,j) = levels(actions(i,j));
        end
    end
end
correct = choice; % assumes all correct decisions are rightward
sbet_on = ones(size(actions));

good = ismember(choice,[0,1]) | optedout==1;
    
% outputs
choice = choice(good);
correct = correct(good);
optedout = optedout(good);
level = level(good);
coh = coh_patch(good);
group = group(good);
sbet_on = sbet_on(good);
nquery = nquery(good);
dotdur = dotdur(good);
    