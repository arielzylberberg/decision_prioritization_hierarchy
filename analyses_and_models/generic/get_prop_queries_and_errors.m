function [L,E] = get_prop_queries_and_errors(actions)

ntr = size(actions,1);
L = nan(3,1);
L(1) = sum(ismember(actions(:),[1]))/ntr;
L(2) = sum(ismember(actions(:),[2,3]))/ntr;
L(3) = sum(ismember(actions(:),[4:7]))/ntr;
E = sum(ismember(actions(:),[8:14]))/ntr;

end