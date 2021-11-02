function existe = exists_seq(dotsData,seq)

ntr = length(dotsData);
existe = zeros(ntr,1);
for i=1:ntr
    s = seq(i,:);
    idx = findPattern(dotsData{i}(:,1), s);
    if ~isempty(idx)
        existe(i) = idx(1);
    end
end
