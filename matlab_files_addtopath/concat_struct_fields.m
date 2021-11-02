function out = concat_struct_fields(struc,fieldnames)

% 
if nargin<2 || isempty(fieldnames)
    fieldnames = fields(struc);
end

for j=1:length(fieldnames)
    out.(fieldnames{j}) = [];
end

for i=1:length(struc)
    for j=1:length(fieldnames)
        f = fieldnames{j};
        out.(f) = cat(1,out.(f),struc(i).(f));
    end
end
