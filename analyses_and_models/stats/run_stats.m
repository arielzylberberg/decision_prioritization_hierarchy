function run_stats()

addpath('../../matlab/files_addtopath/');

%%

d = load('../../data/alldata.mat');


%% num queries
nqueries = sum(~isnan(d.alldata.actions_fun),2);
[~,m,se] = curva_media(nqueries,d.alldata.group,[],1);

%% level transitions

level = d.flat.level;
level(isnan(level))=4;
level(d.flat.fnode==15) = nan;

for i = 1:4
    I = level(2:end)>=level(1:end-1) & level(1:end-1)<=3 & d.flat.group(1:end-1)==i;
    J = level(2:end)<level(1:end-1) & level(1:end-1)<=3 & d.flat.group(1:end-1)==i;
    M(i) = sum(I)./(sum(J)+sum(I));
end

%% stronger motion leads to more accurate decisions

d = load('../exportdata_for_DTB_with_errors/dataformodel_0560_all.mat');
I = ismember(d.choice,[0,1]);

depvar = d.correct(I);
indepvar = {'coh',abs(d.coh(I)),'level',d.level(I),'group',adummyvar(d.group(I))};

testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

eq = 'logit[p_{\text{correct}}] = \beta_0 + \beta_1 c + \beta_2 \ell + \sum_{i=1}^{N_{\text{subj}}-1}\beta_{2+i}I_{\text{subj}}';

stats.beta(1)
stats.se(1)

stats.beta(2)
stats.se(2)


%% stronger motion leads to more sensitive decision

d = load('../exportdata_for_DTB_with_errors/dataformodel_0560_all.mat');
I = ismember(d.choice,[0,1]);

depvar = d.choice(I);
indepvar = {'coh',d.coh(I),'coh_x_level',d.coh(I).*(d.level(I)),'group',adummyvar(d.group(I))};

testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

eq = 'logit[p_{\text{rightward}}] = \beta_0 + \beta_1 s + \beta_2 s \ell + \sum_{i=1}^{N_{\text{subj}}-1}\beta_{2+i}I_{\text{subj}}';

stats.beta(1)
stats.se(1)

stats.beta(2)
stats.se(2)



%% opt out stats

I = ismember(d.choice,[0,1]) | d.optedout==1; % all

depvar = d.optedout(I);
indepvar = {'coh',abs(d.coh(I)),'level',d.level(I),'group',adummyvar(d.group(I))};

testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

eq = 'logit[p_{\text{correct}}] = \beta_0 + \beta_1 c + \beta_2 \ell + \sum_{i=1}^{N_{\text{subj}}-1}\beta_{2+i}I_{\text{subj}}';

stats.beta(1)
stats.se(1)

stats.beta(2)
stats.se(2)

%% same, restricted to the first block of each participant (for the Learning section)

I = ismember(d.choice,[0,1]) | d.optedout==1 & d.block_num==1; % all

depvar = d.optedout(I);
indepvar = {'coh',abs(d.coh(I)),'level',d.level(I),'group',adummyvar(d.group(I))};

testSignificance.vars = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

stats.beta(2)
stats.se(2)

%% motion energy


I = find(d.optedout==0 & d.nquery==2);

me = sum(d.me,2);

me_last = me(I);
me_prev = me(I-1);

depvar = d.choice(I);
testSignificance.vars = [1,2,3,4];
indepvar = {'coh',d.coh(I),'level',d.level(I),'me_last',me_last,'me_prev',me_prev,'group',adummyvar(d.group(I))};

[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

LRT(4)

% nquery  = 1

I = find(d.optedout==0 & d.nquery==1);
me_last = me(I);
depvar = d.choice(I);
testSignificance.vars = [1,2,3];
indepvar = {'coh',d.coh(I),'level',d.level(I),'me_last',me_last,'group',adummyvar(d.group(I))};

[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);


%% number of off-path on-path queries
ae = run_on_path_off_path_other(1:4, 1);
[tt,xx] = curva_media([ae.on_path==0,ae.on_path==1,isnan(ae.on_path)],ae.group,[],0);
prop_off_plus_on = redondear(sum(xx(:,1:2),2),2);
media = mean(sum(xx(:,1:2),2));

%% fraction of 'other' actions that are terminal
other = isnan(ae.on_path);
[tt,xx] = curva_media(ae.fnode>7,ae.group,other==1,0);
to_terminal = ae.fnode>7;
mean(to_terminal(other==1))

%% on path and off path vs level
ae = run_on_path_off_path_other(1:4, 1);

n = length(ae.coh);
blamed = zeros(n,3);
for i=1:n
    if ~isnan(ae.level_node_blamed(i))
        blamed(i,ae.level_node_blamed(i)) = 1;
    end
end

conditions = [ae.on_path==1, ae.on_path==0,ismember(ae.on_path,[0,1])];

% on path
for i=1:size(conditions,2)
    I = conditions(:,i); 
    
    blame = blamed(I,:);
    blame = blame(:);
    coh_path = ae.coh_path_to_error(I,:);
    coh_path = coh_path(:);

    lev = repmat([1,2,3],sum(I),1);
    lev = lev(:);
    group = repmat(ae.group(I,:),[1,3]);
    group = group(:);

    depvar = blame;
    testSignificance.vars = [1,2,3];
    indepvar = {'coh',coh_path,'level',lev,'group',adummyvar(group)};
    [beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

    % for paper
    LRT(2)
    
    LRT(1)
end


end



