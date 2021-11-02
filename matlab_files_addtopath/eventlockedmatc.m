function [datamp,timeslocked] = eventlockedmatc(data,times,E,win)
%function [datamp,timeslocked] = eventlockedmatc(data,times,E,win)
% Helper function to create an event triggered matrix from univariate
% continuous data

% Inputs:
% data   (input time series as a column vector) - required
% times  (time of each sample of data) - required
% E      (events (in times unit) to use as triggers) - required 
% win    (window around triggers to use data matrix -[winl winr]) - optional 
%          e.g [1 1] uses a window starting 1 * Fs samples before E and
%              ending 1*Fs samples after E. Fs is obtained from "times"
%         defaults: no window and return all data (with NaNs) locked to the
%         event
% Note that E, Fs, and win must have consistent units 
%
% Outputs:
% datamp      (event triggered data)
% timeslocked (times locked to event)

% switch dimensions if required

% Dic2015: ignores (fill with NaN's) trials where E has nan's



if ~(size(data,1)==length(times))
    data = data';
end


withWindow = 0;

Fs = 1/(times(2)-times(1));

[E,aux] = redondear(E,times);

nE = round(E*Fs-times(1)*Fs)+1;
ND = size(data,1);
NE = length(E);

if nargin == 4
    nwinl=round(win(1)*Fs);
    nwinr=round(win(2)*Fs);
    nR = max(nE) + nwinr;
    if min(nE)>=nwinl && nR<=ND %all data inside range
        withWindow = 1;
    else
        withWindow = 0;
    end
end

if withWindow == 1
    nwinl=round(win(1)*Fs);
    nwinr=round(win(2)*Fs);
    indsaux = -nwinl:nwinr;
    datamp = nan(length(indsaux),size(data,2));
    
    for n=1:NE
        try
            indx=nE(n)-nwinl:nE(n)+nwinr;
            if ~isnan(E(n)) % added, Dic2015
                datamp(:,n) = data(indx,n);
            end
        catch
            aa
        end
    end
    
    timeslocked = times(indx) - times(nE(n)); % BEFOFE DEC2015
    
    % ADDED DEC 2015 - in case it ends with a NaN
    for n=1:NE %will only go a few trials at most
        indx=nE(n)-nwinl:nE(n)+nwinr;
        if ~isnan(E(n))
            timeslocked = times(indx) - times(nE(n));
            break;
        end
    end
    % END ADDED

    
else
    nwinl=max(nE)-1; %numero de datos a izquierda, para el caso más desfavorable
    nwinr=ND - min(nE); %numero de datos a derecha, para el caso más desfavorable
    indsaux = -nwinl:nwinr;
    datamp = nan(length(indsaux),size(data,2));
    fr=max(nE)-nE+1;%from
    for n=1:NE
        if ~isnan(E(n)) % added, Dic2015
            datamp(fr(n):fr(n)+ND-1,n) = data(1:end,n);
        end
    end
    
    % indx=nE(1)-nwinl:nE(1)+nwinr;
    
    t1 = times - nanmax(E);
    t2 = times - nanmin(E);
    
    %timeslocked = min(t1):1/Fs:max(t2);
    timeslocked = min(t1):1/Fs:max(t2)+1/(2*Fs);
end


end

function [Y,pos] = redondear(E,t)
%function Y = redondear(E,t)
% Y = devuelve los valores de E redondeado a los valores de t;
pos = zeros(size(E));
Y = zeros(size(E));
for i=1:length(E)
    [a,b] = min(abs(t-E(i)));
    Y(i) = t(b);
    pos(i) = b;
end

Y(isnan(E)) = nan; % added, Dic2015

end




