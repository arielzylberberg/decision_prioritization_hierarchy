function all = parseTrialData(varargin)
%all = parseTrialData('trialData',trialData);
%or
%all = parseTrialData('sujetos',sujetos,'datadir',datadir);


struct2vars(cell2struct(varargin(2:2:end),varargin(1:2:end),2));

doLoad = false;
doParse = false;
if ~exist('struct_name','var')
    struct_name = 'trialData';
end
if exist('trialData','var')
    doParse = true;
end
if exist('sujetos','var') && exist('datadir','var')
    doLoad = true;
    doParse = true;
    if exist('trialData','var');
        error('do not include trialData as input if re-loading the data')
    end
end

all = [];

%%
if doLoad
    trialData = [];
    for i=1:length(sujetos)
        if iscell(datadir)
            ddir = datadir{i};
        else
            ddir = datadir;
        end
        files = dir(fullfile(ddir,[sujetos{i},'*.mat']));
        
        [~,idx] = sort([files.datenum]);
        files = files(idx);
        for j=1:length(files)
            temp = load(fullfile(ddir,files(j).name),struct_name);
            if isempty(struct_name)
                temp.trialData = temp;
            else
                temp.trialData = temp.(struct_name);
            end
            for k=1:length(temp.trialData)
                temp.trialData(k).group = i;
                temp.trialData(k).session = j;
                temp.trialData(k).filename = files(j).name;
                temp.trialData(k).trialnum = k;
            end
            trialData = cat(2,trialData,temp.trialData);
        end
    end
end

if doParse
    n = length(trialData);
    fnames = fieldnames(trialData);
    for j=1:length(fnames)
        for i=1:n
            a = trialData(i).(fnames{j});
            if ischar(a)
                all.(fnames{j})(i) = {a};
            elseif isempty(a)
                all.(fnames{j})(i) = nan;
            
            elseif isvector(a) && ~isscalar(a) %adz
                all.(fnames{j}){i} = a;
            
            elseif ismatrix(a) && ~isscalar(a) %adz
                all.(fnames{j}){i} = a;
                
            elseif isnumeric(a) || ...
                    islogical(a)
                all.(fnames{j})(i) = double(a);
                
                
            elseif isstruct(a)
                fn = fieldnames(a);
                for k=1:length(fn)
                    b = a.(fn{k});
                    str = [fnames{j},'_',fn{k}];
                    if isempty(b) %vacio?
                        if i>1 && iscell(all.(str)(i-1)) %celda?
                            all.(str)(i) = {nan};
                        else
                            all.(str)(i) = nan;
                        end
                        
                    elseif isnumeric(b) && length(b)==1 && ...
                        (i==1 || isnumeric(all.(str)(i-1)))
                        all.(str)(i) = b;
                    else
                        
                        all.(str){i} = b;
                        
                    end
                end
            end
        end
    end

    %column vectors
    fnames = fieldnames(all);
    for i=1:length(fnames)
        all.(fnames{i}) = all.(fnames{i})(:);
    end
end