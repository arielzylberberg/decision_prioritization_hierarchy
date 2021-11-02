function [tup,evup] = upsample_ev(t,ev,uprate)
if uprate==1
    tup=t;
    evup=ev;
    
elseif uprate>1
    [ntr,nt] = size(ev);
    ind = repmat([1:nt],uprate,1);
    ind = ind(:);
    evup = nan(ntr,length(ind));
    for i=1:length(ind)
        evup(:,i) = ev(:,ind(i));
    end
    
    dt = t(2)-t(1);
    dt = dt/uprate;
    tup = t(1):dt:[t(1)+dt*length(ind)-dt];
    
elseif uprate<1 %downsample
    error('improve')
%     evup = resample(ev',1,1/uprate)';
%     % tup  = resample(t,1,1/uprate);
%     tup = linspace(min(t),max(t),size(evup,2));
end