function [idx, me_normcoh,cohme] = map_me_to_coh(sig_coh,me_vec,filt,upratio)

if nargin<3 || isempty(filt)
    filt = ones(length(sig_coh),1)==1;
end
if nargin<4 || isempty(upratio)
    upratio = 1;
end


%up sample if required
if ~ispowof2(upratio)
    error('upratio must be power of 2');
end

% normalize with a regression
b = regress(me_vec,sig_coh);
me_normcoh = me_vec/b;

%
coh = sig_coh;
ucoh = unique(coh);
d = diff(ucoh);
while upratio>1
    ucoh = sort([ucoh;ucoh(1:end-1)+d/2]);
    d = diff(ucoh);
    upratio = upratio/2;
end

% average in bins centered at each coh

edges = [-inf;ucoh(1:end-1)+d/2;inf];
idx = nan(length(sig_coh),1);
for i=1:length(edges)-1
    inds = me_normcoh>edges(i) & me_normcoh<edges(i+1) & filt==1;
    idx(inds) = i;
end

cohme = nan(size(idx));
cohme(~isnan(idx))=ucoh(idx(~isnan(idx)));