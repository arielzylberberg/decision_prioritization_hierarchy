addpath('/Users/arielzy/Dropbox/Data/default_matlab_ariel_files/ternplot/');

ae = run_on_path_off_path_other(1:4, 1);
filt = ismember(ae.on_path,[0,1]);
coh_path = ae.coh_path_to_error(filt,:);
on_path = ae.on_path(filt);

%%
% logistic model - STATS


%%
coh_not_error = [];
for i=1:size(ae.level_node_blamed,1)
    if ~isnan(ae.level_node_blamed(i))
        ind = ~ismember(1:3,ae.level_node_blamed(i));
        coh_not_error = [coh_not_error; ae.coh_path_to_error(i,ind)];
    end
end

%% STATS
I = ~isnan(ae.on_path);
depvar = ae.on_path(I);
indepvar = {'coh',ae.coh(I), 'coh_other',coh_not_error(:,1).*coh_not_error(:,2),'group',adummyvar(ae.group(I))};
testSignificance.vars  = [1,2];
[beta,idx,stats,x,LRT] = f_regression(depvar,[],indepvar,testSignificance);

LRT(2)
stats.beta(2)
stats.se(2)
stats.p(2)

%% PLOT

% [uni_coh_path, ~,Ic] = unique(coh_path,'rows');
% [~,uni_on_path] = curva_media(on_path,Ic,[],0);
I = ~isnan(ae.level_node_blamed);
[Mean,Stdev,uni_cond,tr_per_cond,idx_cond] = average_per_condition(ae.on_path(I), coh_not_error);

p = publish_plot(1,1);
set(gcf,'Position',[440  402  449  396]);
y = ae.on_path(I);
x = coh_not_error(:,1).*coh_not_error(:,2);
[tt,xx,ss] = curva_media(y, x,[],0);
tt = 100*100*tt;
terrorbar(tt,xx,ss,'color','k','LineStyle','none','Marker','o','MarkerSize',6,'MarkerFaceColor','k');
xlabel('Product of motion strengths [%^2]');
ylabel('Prob. on-path query');
p.format('FontSize',16,'LineWidthPlot',1);
% p.offset_axes();



fun = @(b,x) b(1).*exp(b(2).*x) + b(3);
NLM = fitnlm(x,y,fun,[1,1,1]);
xx = linspace(min(x),max(x),1000);
plot(100^2*xx,NLM.feval(xx),'k--','LineWidth',1);

set(gca,'tickdir','out');
xlim([-50,max(xx*100^2)]);
p.visible_limits_until_tickmarks();
% limits{1} = [-1,0;1,0];

% limits{2} = [1,0;0,sqrt(2)];
% limits{3} = [0,sqrt(2);-1,0];
% 
% % first plot triangle
% for i=1:3
%     plot(limits{i}(:,1),limits{i}(:,2),'k','LineWidth',2)
%     hold all
% end
% 
% n = size(uni_coh_path,1);
% for i=1:n
%     c = uni_coh_path(i,:);
%     x = limits{1}(1,1)+c(1)*(limits{1}(2,1)-limits{1}(1,1));
%     for j=2:3
%         x = x + limits{j}(1,1)+c(1)*(limits{j}(2,1)-limits{1}(1,1));
%     end
% end    
    
    

