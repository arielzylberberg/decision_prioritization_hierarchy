function stde = stderror(X,dim)
if nargin<2
    dim = nan;
end
transpose = false;
if ~isvector(X) && dim==2
    transpose = true;
    X = X';
end
if isvector(X)
    inds = ~isnan(X);
    N = sum(inds);
    stde = nanstd(X)/sqrt(N);
else
    N = nansum(~isnan(X),1);
    stde = nanstd(X,[],1);
    stde = bsxfun(@times,stde,1./sqrt(N));
end
if transpose
    stde = stde';
end