function existe = exists_pattern(dotsData,pat)

ntr = length(dotsData);
existe = zeros(ntr,1);
for i=1:ntr
    s = pat(i,:);
    idx = ismember(s,dotsData{i}(:,1));
    if all(idx==1)
        existe(i) = 1;
    end
end
