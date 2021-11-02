clear;clc;

%% carga
datadir = '../raw_data/';
sujetos = {'0560_dahsan','0560_laura','0560_amy','0560_melody'};

alldata = parseTrialData('sujetos',sujetos,'datadir',datadir);


%%
vcoh = cat(1,alldata.vCoh{:});
vdir = cat(1,alldata.vDir{:});

vcoh_signed = [2*(vdir==0)-1].*vcoh;

fun = @(x)size(x,1);
m = cellfun(fun,alldata.dotsData);

%%

tree = TreeClassAnalysis(([1:8]-4.5), 1, -1, 4);


ntr = length(alldata.group);
dat = [];
group = [];
vcoh_fun = nan(ntr,7);

for i=1:ntr
    right_is_correct = vdir(i,:)==0;
    
    tree.set_correct_path(right_is_correct);
    [B,C,V] = tree.node_role( alldata.dotsData{i}(:,1) ); % mapping of spatial nodes to functional nodes
    
    % add it to all data
    
    alldata.dotsData{i} = [alldata.dotsData{i}, B,C];
    
    % maybe...
    vcoh_fun(i,V(1:7,2)) = vcoh(i,V(1:7,1));
    
    d = alldata.dotsData{i};
    dat = [dat; ones(size(d,1),1)*i, d]; % all in one matrix
    group = [group; ones(size(d,1),1) * alldata.group(i)];
    % now see if a child was visited after the query, and it that case
    % whetehr the response was correct or not
    

    
end

level = nan(size(dat,1),1);
level(ismember(dat(:,7),1)) = 1;
level(ismember(dat(:,7),[2,3])) = 2;
level(ismember(dat(:,7),[4,5,6,7])) = 3;

% make matrix with trials x actions (functional)
max_num_actions = max(cellfun(@length,alldata.dotsData));
M = nan(ntr,max_num_actions);
for i=1:ntr
    dd = alldata.dotsData{i}(:,end-1);
    ind = 1:length(dd);
    M(i,ind) = dd;
end
alldata.actions_fun = M;

alldata.coh_fun = vcoh_fun;



    

%% 

ucoh = unique(vcoh(:,1)); 


%% given an incorrect first decision, does the amount of 
%% exploration in the incorrect branch depends on the coherence of the top one?
error_on_first = zeros(ntr,1);
n_wrong_first_nodes = zeros(ntr,1);
% wrong_first_nodes = [5,6,7,12:15];
wrong_first_nodes = [2,4,5,8:11];
I = ismember(dat(:,7),wrong_first_nodes);
for i=1:ntr
    inds = dat(:,1)==i & dat(:,7)==5;
    error_on_first(i) = sum(inds);
    inds = dat(:,1)==i & I;
    n_wrong_first_nodes(i) = sum(inds);
end


%% given a correct first decision, does the amount of 
%% time in the incorrect branch depends on the coherence of the top one?
correct_on_first = zeros(ntr,1);
n_correct_first_nodes = zeros(ntr,1);
% correct_first_nodes = [2:4,8:11];
correct_first_nodes = [3,6,7,12:15];
I = ismember(dat(:,7),correct_first_nodes);
for i=1:ntr
    inds = dat(:,1)==i & I;
    n_correct_first_nodes(i) = sum(inds);
end


%% reward per trial
[~,~,I] = unique([alldata.group,alldata.session],'rows');
uI = unique(I);
reward_per_trial=nan(ntr,1);
for i=1:length(uI)
    ff = find(I==uI(i));
    reward_per_trial(ff) = [alldata.reward_block(ff(1));diff(alldata.reward_block(ff))];
end
alldata.reward_per_trial = reward_per_trial;


%%
flat.c = dat(:,8);
flat.trnum = dat(:,1);
signed_coh = dat(:,4).*sign(90-dat(:,5));
flat.scoh = signed_coh;
flat.level = level;
flat.fnode = dat(:,7);
flat.node_spatial = dat(:,2);
flat.time = dat(:,6);
flat.is_dots = ~isnan(flat.scoh);

utr = unique(flat.trnum);
flat.time_delta = nan(size(flat.trnum));
for i=1:length(utr)
    I = flat.trnum==utr(i);
    flat.time_delta(I) = diff([0; flat.time(I)]);
end

% calc errors in a row
flat.num_errors_in_trial = nan(size(flat.trnum));
flat.visited = nan(length(flat.trnum),15);
uni_tr = unique(flat.trnum);
for i=1:length(uni_tr)
    I = flat.trnum==uni_tr(i);
    flat.num_errors_in_trial(I) = cumsum(flat.fnode(I)>7 & flat.fnode(I)<15);
    
    % calc number of times nodes were visited
    fI = find(I);
    for j=1:length(fI)
        visited = histcounts(flat.fnode(fI(1:j)),[0.5:1:15.5]);
        flat.visited(fI(j),:) = visited;
    end
    
end

n = length(flat.c);
KK = sub2ind(size(flat.visited),[1:n]', flat.fnode);
flat.nquery_anytime = flat.visited(KK);

%% get how many time the S queries the same RDM stimulus IN A ROW

nquery = nan(n,1);
nquery(flat.is_dots) = 1;
for i=2:n
   if flat.trnum(i)==flat.trnum(i-1) && ...
           flat.fnode(i)==flat.fnode(i-1)
       nquery(i) = nquery(i-1)+1;
   end
end
cextended = flat.c; % get the value of c from the last of the queries
maxquery = nquery;
for i = max(nquery):-1:2
    inds = find(nquery==i);
    cextended(inds-1) = cextended(inds);
    maxquery(inds-1) = maxquery(inds);
end

flat.nquery = nquery;
flat.maxquery = maxquery;
flat.cextended = cextended;

%%
c = flat.c;
r = nan(size(c)); %response
r(c==1 & dat(:,5)==0 | c==0 & dat(:,5)==180) = 1;
r(c==0 & dat(:,5)==0 | c==1 & dat(:,5)==180) = 0;

c = flat.cextended;
rextended = nan(size(c)); %response
rextended(c==1 & dat(:,5)==0 | c==0 & dat(:,5)==180) = 1;
rextended(c==0 & dat(:,5)==0 | c==1 & dat(:,5)==180) = 0;

flat.r = r;
flat.rextended = rextended;
flat.dotdur = ones(size(c))*unique(alldata.times_dots_on); % I assume they are all the same !!
flat.group = group;
flat.nquery_intrial = nan(size(c));

flat.query_nonseq = nan(size(c));
unode = nanunique(flat.fnode);
for i=1:nanmax(flat.trnum)
    I = flat.trnum==i;
    flat.nquery_intrial(I) = 1:sum(I);
    for j=1:length(unode)
        inds = I & flat.fnode==unode(j);
        flat.query_nonseq(inds) = sum(inds);
    end
end

%% block num
block_num = [];
for i=1:length(alldata.correct)
    na = size(alldata.dotsData{i},1);
    block_num = [block_num; repmat(alldata.session(i),[na,1])];
end

flat.block_num = block_num;


%% node changes are usually to lower level nodes
n = length(flat.c);
f = flat.fnode(1:end-1)~=flat.fnode(2:end) & flat.trnum(1:end-1)==flat.trnum(2:end) & ...
    ~isnan(flat.level(1:end-1)) & ~isnan(flat.level(2:end));

dife_level = flat.level(1:end-1)-flat.level(2:end);


%% are terminal nodes only queried once?
uni_tr = unique(flat.trnum);
is_terminal = ismember(flat.fnode,8:15);
terminal_nodes_queried = zeros(length(uni_tr),8);
for i=1:length(uni_tr)
    I = flat.trnum==uni_tr(i);
    aux = Rtable(flat.fnode(is_terminal & I));
    uni = unique(flat.fnode(is_terminal & I));
    terminal_nodes_queried(i,uni-7) = aux;
end

%% remove fields not needed for analyses

fields_to_remove = {'times_interdots','times_dots_on','times_intertrial',...
    'times_show_choice',...
    'times_error_timeout',...
    'times_nochoice_timeout',...
    'times_fixbreak_timeout',...
    'times_refract_post_dots',...
    'times_show_feedback',...
    'correct','trial_result',...
    'rdm1_coh_std','rdm1_cohframes'};

alldata = rmfield(alldata,fields_to_remove);
flat = rmfield(flat, {'time','time_delta'});

%%
save alldata alldata flat

