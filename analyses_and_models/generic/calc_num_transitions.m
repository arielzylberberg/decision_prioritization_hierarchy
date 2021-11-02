function count = calc_num_transitions(actions,filt)

if nargin==1 || isempty(filt)
    filt = ones(size(actions))==1;
end
% filt = ones(size(f))==1 & n_err>=0; % any number of prev errors

% sanity check
if any(size(filt)~=size(actions))
    error('wrong size');
end

f = actions';
f = f(:);


filt = filt';
filt = filt(:);

uni = nanunique(actions(:));
n = length(uni);
count = zeros(n,n);
for i=1:n %from
    for j=1:n %to
        I = find(f==uni(i) & filt);
        if ~isempty(I)
            count(j,i) = sum(f(I+1)==uni(j));
        end
    end
end

% 
% for i=1:14 % from
%     I = find(f==i & filt);
%     u = nanunique(f(I+1));
%     r = Rtable(f(I+1),true);
%     where_to(u,i) = r/sum(r);
% end