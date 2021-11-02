load('../../data/alldata.mat','flat')
ME = load('../prepro_motion_energy/motion_energy.mat','me');


% should be read from elsewhere
parents_fnode = [1,nan; 
                 2, 1; 
                 3, 1; 
                 4, 2; 
                 5, 2; 
                 6, 3; 
                 7, 3;
                 8, 4;
                 9, 4;
                 10, 5;
                 11, 5;
                 12, 6;
                 13, 6;
                 14, 7;
                 15, 7];


             
ugroup = nanunique(flat.group);

for i=1:length(ugroup)
    
    I = ~isnan(flat.rextended) & flat.group==ugroup(i); 
    
    choice = flat.r(I);
    correct = flat.c(I);
    dotdur = flat.dotdur(I);
    
    coh = flat.scoh(I)/1000;
    sbet_on = ones(sum(I),1)==1;
    optedout = flat.nquery(I)~=flat.maxquery(I);
    level = flat.level(I);
    
    group = ones(sum(I),1)*ugroup(i);
    
    fnode = flat.fnode(I);
    nquery = flat.nquery(I);
    
    me = ME.me(I,:); % need to re-scale
    me_time = [1:size(me,2)]/75;
    
    % calc the parent's coherence
    coh_parent = nan(sum(I),1);
    fI = find(I);
    for j=1:length(fI)
        k = flat.fnode(fI(j));
        parent = parents_fnode(k,2);
        K = find(fnode==parent & flat.trnum(I)==flat.trnum(fI(j)),1);
        if ~isempty(K)
            coh_parent(j) = coh(K);
        end
    end
    
    visited = flat.visited(I,:);
    visits_parents = nan(sum(I),2);
    for j=1:length(fI)
        lev = flat.level(fI(j));
        k = flat.fnode(fI(j));
        for ll = lev:-1:2
            parent = parents_fnode(k,2);
            visits_parents(j,ll-1) = visited(j, parent);
            k = parent;
        end
    end
    
    nquery_anytime = flat.nquery_anytime(I);
    nquery_intrial = flat.nquery_intrial(I);
    trial_num = flat.trnum(I);
    block_num = flat.block_num(I);
    
    %
    save(['dataformodel_0560_group',num2str(i)],'choice','correct','dotdur','coh','sbet_on',...
        'optedout','me','me_time','level','coh_parent','fnode','nquery','group','visited','visits_parents',...
        'nquery_anytime','nquery_intrial','trial_num','block_num');
end

%% concatenar
clear dat
for i=1:length(ugroup)
    dat(i) = load(['dataformodel_0560_group',num2str(i)]);
end
dat = concat_struct_fields(dat);
save('dataformodel_0560_all','-struct','dat');
