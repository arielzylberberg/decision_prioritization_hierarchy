function y = choose(V,I)
% grabs de value of column j of V if I(:,j)==1

n = size(V,2);
y = nan(size(V,1),1);
for i=1:n
    J = I(:,i)==1;
    y(J) = V(J,i);
end

end