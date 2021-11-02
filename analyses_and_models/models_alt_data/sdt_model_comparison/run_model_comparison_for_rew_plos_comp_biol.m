clear 

addpath('../../../matlab_files_addtopath/')

nsuj = 4;
 

alt_models = {
        '../models/detection_model',...
        'sdt_model_integration',...
        'sdt_model_1_crit_3_kappas',...
        'sdt_model_3_crit_3_kappas',...
        'sdt_model_adapt_criterion_only_one_exp_in_row',...
        'RESP_REW_sdt_model_criterion_time',...
        };
    
model_names = {'base model','Integration','1\phi3\kappa',...
    '3\phi3\kappa','Constant noise (\gamma=0`)','Time'};
    
    
for j=1:length(alt_models)
    for i=1:nsuj
        d = load(['../',alt_models{j},'/optim',num2str(i),'.mat']);
        nlogl(j,i) = d.err;
        nParams(j) = sum(d.th~=d.tl);
    end
end

% num params
for i=1:nsuj
    d = load(['../../exportdata_for_DTB_with_errors/dataformodel_0560_group',num2str(i),'.mat'],'choice');
    numObs(i) = sum(ismember(d.choice,[0,1]));
end


logl = -1*nlogl;

for i=1:nsuj
    for j=1:length(alt_models)
        [aic(i,j),bic(i,j)] = aicbic(logl(j,i),nParams(j),numObs(i));
    end
end

%%

n = length(alt_models)-1;
p = publish_plot(1,n);
set(gcf,'Position',[233  340  961  206])

dif_bic = [bic-bic(:,1)]';


max_BIC_in_graph = 100;
% dif_bic(dif_bic>max_BIC_in_graph) = max_BIC_in_graph;
% dif_bic(dif_bic<-max_BIC_in_graph) = -max_BIC_in_graph;


for i=1:n
    p.next();
    hb(i) = barh(dif_bic(1+i,:)');
    ht(i) = title(model_names(1+i));
end

set(hb,'FaceColor','w','EdgeColor','k','BarWidth',0.9);

p.current_ax(1);
ylabel('Participant');
set(gca,'ytick',1:4,'yticklabel',{'S1','S2','S3','S4'});

p.current_ax(2);
xlabel('\DeltaBIC in favor of the detection model');
% dif_aic = [aic-aic(:,1)]';
% hb = bar(dif_aic(2:end,:)');

symmetric_x(p.h_ax);

% limit the x limit

% for i=1:n
%     p.current_ax(i);
%     xli = get(gca,'xlim');
%     if xli(2)>=max_BIC_in_graph
%         set(gca,'xlim',[-max_BIC_in_graph, max_BIC_in_graph],'xticklabel',{['<-', num2str(max_BIC_in_graph)], ...
%             '0', ['>',num2str(max_BIC_in_graph)]},...
%             'xtick', [-max_BIC_in_graph, 0, max_BIC_in_graph]);
%     end
% end

% set(p.h_ax,'ylim',[0.5,4.5]);


p.format('FontSize',14);
set(ht,'FontSize',14);
set(p.h_ax(2:end),'ycolor','none');
p.offset_axes();

p.visible_limits_until_tickmarks();


%%

