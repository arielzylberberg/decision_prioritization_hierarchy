function [err,P,p_up,p_lo,p_out] = ...
    wrapper_sdt_tree_choice_sbet(theta,dotdur,level,coh,choice,c,sbet_on,...
    optedout,nquery_anytime,visits_parents,var_names,plot_flag,varargin)


%%

kappa  = theta(1);
coh0 = theta(2);
PHI    = theta(3:5); % confidence separatrix in ev. scale, one per level
scale_noise = theta(6); % not used
lambda_slope_queries = theta(7);


%%

if numel(unique(dotdur))>1
    error('not coded for non-fixed duration stimuli');
end

mu = unique(dotdur) * kappa * unique(coh+coh0);

uni_mu = unique(mu);
[uni_coh,~,Icoh] = nanunique(coh+coh0);

sigma = sqrt(unique(dotdur)*(1+scale_noise*abs(unique(coh+coh0))));

% for each unique condition, compute the probability of correct as a
% function of the 'accumulated' evidence
maxy = max(abs(uni_mu))+4 * sqrt(max(dotdur)); % four standard deviations
uni_ev = linspace(-maxy,maxy,5000);

pdf_ev = nan(length(uni_mu),length(uni_ev));
for i=1:length(uni_mu)
    pdf_ev(i,:) = normpdf(uni_ev,uni_mu(i),sigma(i));
    
end
pdf_ev = bsxfun(@times,pdf_ev,1./sum(pdf_ev,2));


uni_levels = unique(level);


%% For each coherence and each level I get the probability of the three
% responses: left, again, right

crit = PHI(level)' .* (exp(-lambda_slope_queries*(nquery_anytime-1)));

PL = pdf_ev(Icoh,:) .* (uni_ev(:)<=-crit')';
PA = pdf_ev(Icoh,:) .* (abs(uni_ev(:))<crit')';
PR = pdf_ev(Icoh,:) .* (uni_ev(:)>=crit')';


%% likelihood

p_out = sum(PA,2);
p_lo = sum(PL,2);
p_up = sum(PR,2);

pchoice = (optedout==0).*((choice==1).*p_up+(choice==0).*p_lo) + (optedout==1).*p_out;


pchoice(pchoice==0) = eps;
nlogl = -sum(log(pchoice));

err = nlogl;

%% just for saving:
if nargout > 1
    P.ev = uni_ev;
    P.pdf = pdf_ev;
    P.uni_coh = uni_coh;
    P.uni_levels = uni_levels;
    P.PHI = PHI;
end

%% print

fprintf_params(var_names,err,theta);

%%
if plot_flag

    
    figure(1);clf
    
    subplot(1,2,1);
    
    
     color = [0,0,1;1,0,0;0,0.5,0];

    for i=1:3
        I = sbet_on==1 & optedout==0 & level==i;
        [tt,xx,ss] = curva_media(choice,coh,I==1,0);
        errorbar(tt,xx,ss,'LineStyle','none','color',color(i,:),'marker','.','MarkerSize',20)
        hold all
        [tt,xx,ss] = curva_media(p_up./(p_up+p_lo),coh,I==1,0);
        plot(tt,xx,'color',color(i,:));
        
    end
    
    
    
    subplot(1,2,2)
    
    for i=1:3
        I = sbet_on==1 & level==i;
        [tt,xx,ss] = curva_media(optedout,coh,I==1,0);
        errorbar(tt,xx,ss,'LineStyle','none','color',color(i,:),'marker','.','MarkerSize',20)
        hold all
        
        [tt,xx,ss] = curva_media(p_out,coh,I==1,0);
        plot(tt,xx,'color',color(i,:));
        
    end
    
    format_figure(gcf,'FontSize',15);
    
    drawnow
    
end