function me_res = calc_residuals(motion_energy,coh,method)
% function me_res = calc_residuals(motion_energy,coh,method)
% removes effect of coherence from motion energy

% method. 1: asdummy; 2: lineal; 3: substract mean; 4: substract mean (assume stationary)


[I,J] = size(motion_energy);
me_res = nan(I,J);

if ismember(method,[1,2]) %with regression
    cutoff = .9999;%does regression until this cutoff of the proportion of nans
    nans = mean(isnan(motion_energy));
    N = find(nans>cutoff,1);
    if isempty(N); N = J; end
    for i = 1:N
        
        depvar = motion_energy(:,i);
        ginds  = ~isnan(depvar);
        depvar = depvar(ginds);
        
        if method==1
            indepvar = {'coh',adummyvar(coh(ginds))};
        else
            indepvar = {'coh',coh};
        end
        
        testSignificance.vars = [];
        boolNormalize = [];
        
        try
            [beta,~,~,x] = f_regression(depvar,boolNormalize,indepvar,testSignificance);
        catch
            aa
        end
        yfit = glmval(beta,x,'identity','constant','off');
        
        if method==1
            me_res(ginds,i) = depvar - yfit;
        else
            me_res(:,i) = depvar - yfit;
        end
    end
elseif method==3 %substract average
    ucoh = nanunique(coh);
    nucoh = length(ucoh);
    for i = 1:nucoh
        inds = coh == ucoh(i);
        m = nanmean(motion_energy(inds,:));
%         plot(m);hold all
        me_res(inds,:) = bsxfun(@plus,motion_energy(inds,:),-1*m);
    end
elseif method==4 % substract average - assume stationary signal
    ucoh = nanunique(coh);
    nucoh = length(ucoh);
    for i = 1:nucoh
        inds = coh == ucoh(i);
        aux = motion_energy(inds,:);
        aux = aux(:);
        m = nanmean(aux);
%         plot(m);hold all
        me_res(inds,:) = bsxfun(@plus,motion_energy(inds,:),-1*m);
    end
    
end