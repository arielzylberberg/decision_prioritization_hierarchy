function p = run_transitions_across_levels_scaled(v_datasource, p_norm, titles)

if nargin==0 || isempty(v_datasource)
    % v_datasource = [1,3,4];
    % v_datasource = [1,12,4];
    % v_datasource = [1, 8, 4];
    v_datasource = [1, 22, 4, 13];
end

if nargin<3 || isempty(titles)
    titles = {'A: Data','B: Heuristic model','C: Bayesian model','D: Bayesian cheaper sampling'};
end

n = length(v_datasource);



%% before and after 1st error


[p1, params1] = call_transitions_between_levels(v_datasource,'min_num_errors',0,'max_num_errors',0,...
    'p_norm',p_norm);
[p2, params2] = call_transitions_between_levels(v_datasource,'min_num_errors',1,'max_num_errors',inf,...
    'p_norm',p_norm);


p = publish_plot(2,n);


if length(v_datasource)==2
    set(gcf,'Position',[202  163  533  556]);
elseif length(v_datasource)==4
    set(gcf,'Position',[202  271  906  448])
end

% set(gcf,'Position',[276  179  832  540]);
for i=1:n
    p.copy_from_ax(p1.h_ax(i),i);
    p.copy_from_ax(p2.h_ax(i),i+n);
end


p.current_ax(1);
hold all
dx = 1.35;
plot([-dx,-dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);
plot([dx,dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);

% for i=1:2*n
%     p.current_ax(i);
%     hold all
%     dx = 1.35;
%     plot([-dx,-dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);
%     plot([dx,dx],[2,3],'LineWidth',4,'Color',0.7*[1,1,1]);
% end



for i=1:length(v_datasource)
    if i<=length(titles)
        ht(i) = p.add_text(i,titles{i},'center','top');
    end
end

set(p.h_ax,'visible','off');
p.format('FontSize',14);

% for i=1:n
%     p.displace_ax([(1+i):n,(n+1+i):2*n],-0.05,1);
% end
p.displace_ax([(n+1):(2*n)],0.075,2);


%% draw a traingle to indicate the size
draw_triangles = 1;

if draw_triangles
    ids = p.new_axes_in_rect([0.9,0.7,0.1,0.06],1);
    set(gca,'Units','pixels');
    % Get and update the axes width to match the plot aspect ratio.
    % pos = get(gca,'Position');
    xli = [0,1];
    
    
    [xp(1)] = ax2fig(gca,xli(1),0);
    [xp(2)] = ax2fig(gca,xli(2),0);
    
    w_max = params1.pars.scaling_line_width; %pixels
    
    xbottom = [xli(1), xli(1) + w_max/diff(xp)*xli(2)];
    
    % plot(xbottom,[0,0],'k-');
    % hold all
    
    w_min = w_max * params1.pars.min_v;
    xtop = [xli(1), xli(1) + w_min/diff(xp)*xli(2)];
    delta = [diff(xbottom)-diff(xtop)]/2;
    xtop = xtop + delta;
    % plot(xtop,[1,1],'k-');
    
    % plot([xbottom(1), xtop(1)],[0,1],'k');
    % plot([xbottom(2), xtop(2)],[0,1],'k');
    
    xx = [xbottom(1),xbottom(2),xtop(2),xtop(1)];
    yy = [0,0,1,1];
    
    patch(xx,yy,'red');
    
    %     [xp(1)] = ax2fig(gca,xli(1),0);
    %     [xp(2)] = ax2fig(gca,xli(2),0);
    %
    %     w_max = params1.pars.scaling_line_width; %pixels
    %
    %     xbottom = [xli(1), xli(1) + w_max/diff(xp)*xli(2)];
    %     plot(xbottom,[0,0],'k-');
    %     hold all
    %
    %     w_min = w_max * params1.pars.min_v;
    %     xtop = [xli(1), xli(1) + w_min/diff(xp)*xli(2)];
    %     delta = [diff(xbottom)-diff(xtop)]/2;
    %     xtop = xtop + delta;
    %     plot(xtop,[1,1],'k-');
    %
    %     plot([xbottom(1), xtop(1)],[0,1],'k');
    %     plot([xbottom(2), xtop(2)],[0,1],'k');
    
    xlim([0,1]);
    ylim([0,1]);
    
    axis off
    
    ids = p.new_axes_in_rect([0.9,0.3,0.1,0.06],1);
    p.copy_from_ax(p.h_ax(end-1),p.h_ax(end));
    
    p.current_ax(ids-1);
    text(0.5,0,num2str(redondear(params1.max_val,2)),'horizontalalignment','center');
    text(0.5,1,num2str(redondear(params1.max_val * params1.pars.min_v,2)),'horizontalalignment','center');
    
    p.current_ax(ids);
    text(0.5,0,num2str(redondear(params2.max_val,2)),'horizontalalignment','center');
    text(0.5,1,num2str(redondear(params2.max_val * params2.pars.min_v,2)),'horizontalalignment','center');
    
end

% close_all_but(p.h_fig);

end

%%%%%%%%%%%%%%%%%%


function [p,params] = call_transitions_between_levels(v_datasource, varargin)

if nargin==0
    v_datasource = 1;
end

addpath('../../analysis_behavior/')
addpath('../../generic/')

for idata = 1:length(v_datasource)
    datasource = v_datasource(idata);
    
    min_num_errors = 0;
    max_num_errors = inf;
    p_norm = 1;
    v_suj = 1:4;
    coh_top = nan; % which means include them all
    for i=1:length(varargin)
        if isequal(varargin{i},'min_num_errors')
            min_num_errors = varargin{i+1};
        elseif isequal(varargin{i},'max_num_errors')
            max_num_errors = varargin{i+1};
        elseif isequal(varargin{i},'v_suj')
            v_suj = varargin{i+1};
        elseif isequal(varargin{i},'coh_top')
            coh_top = varargin{i+1};
        elseif isequal(varargin{i},'p_norm')
            p_norm = varargin{i+1};
        end
    end
    
    %%
    
    nsuj = length(v_suj);
    
    for k=1:nsuj
        suj = v_suj(k);
        [actions{k},coh{k}] = get_actions_and_coh(suj, datasource);
        
        %%
        npatches = 7;
        [lev{k},coh_dad{k},perf_rel_dad{k}, nqueries_dad{k}, perf_rel_dad_from_dad{k},...
            num_prev_errors{k}, coh_top_node{k}] ...
            = some_calcs(actions{k},coh{k},npatches);
        
    end
    
    
    %%
    count = zeros(4,4,nsuj);
    for k=1:nsuj
        %     n_err = num_prev_errors{k}';
        %     n_err = n_err(:);
        %     filt = num_prev_errors{k}>=0;
        %     filt = num_prev_errors{k}==0;
        
        
        filt = num_prev_errors{k}>=min_num_errors & ...
            num_prev_errors{k}<=max_num_errors;
        
        if ~isnan(coh_top)
            filt = filt & ismember(coh_top_node{k},coh_top);
        end
        
        count(:,:,k) = calc_num_transitions(lev{k},filt);
        
        
    end
    
    % normalize per subject
    for k=1:nsuj
        aux = count(:,:,k);
        norm = sum(aux(:));
        count(:,:,k) = aux/norm;
    end
    
    % average over subjects
    v_count{idata} = nanmean(count,3);
    
end


%% plot

% to normalize all plots the same way
% same_norm_flag = 1; % was 0 before

% if same_norm_flag
%     max_val = max(cellfun(@max,cellfun(@max,v_count,'UniformOutput',false)));
% else
%      max_val = nan;
% end



p = publish_plot(1,length(v_datasource));
for idata = 1:length(v_datasource)
    %%
    count = v_count{idata};
    %
    %     if same_norm_flag
    %         count = count/max_val; %normalize
    %         [pplot, pars] = draw_transitions_between_levels(count, 0);
    %     else
    
    [pplot, pars] = draw_transitions_between_levels(count, p_norm);
    %     end
    
    max_val = p_norm; %??
    
    
    p.copy_from_ax(pplot.h_ax,idata,1);
    
end

same_ylim(p.h_ax);

params.pars = pars;
params.max_val = max_val;
params.min_num_errors = min_num_errors;
params.max_num_errors = max_num_errors;
% params.same_norm_flag = same_norm_flag;

end


%%%%%%%%%%%%%%%%%%%%%%%%%


function [pplot, params] = draw_transitions_between_levels(TMat_levels, p_norm)
% TMat_levels: transition matrices between levels. TMat_levels(j,i):
% transitions from i to j


TMat_levels = TMat_levels';


% sanity check
if ~all(size(TMat_levels)==[4,4])
    error('wrong size');
end

% resort rows and cols, from levels to nodes (now 1 is the lowest level);
M = TMat_levels(4:-1:1,:);
M = M(:,4:-1:1);

params.max_prob = max(M(:));

% if normalize_to_max
%     M = M/max(M(:));
% end


% probs to line width
scaling_line_width = 10;
Wred = M * scaling_line_width / p_norm;

Wblue = zeros(size(Wred));
Wblue((M/p_norm)>1) = Wred((M/p_norm)>1);
Wred((M/p_norm)>1) = 0;



% min_v = 1/20;
% min_v = 1/100;
min_v = 1/50;
Wred(M<min_v) = 0;

params.min_v = min_v;
params.scaling_line_width = scaling_line_width;

pplot = publish_plot(1,1);
set(gcf,'Position',[430  267  444  538]);

CX = [0,0,0,0];
CY = 1:4;


rr = 0;

a = .5; % controls the horizontal span of the bezier curves

% top down
for i=1:4
    for j=1:(i-1)
        delta = i-j;
        
        p = [0,i;a*delta,i;a*delta,j;0,j];
        B = bezier(p);
        
        % remove inside circle
        I = any(sqrt((B(:,1)-CX).^2+(B(:,2)-CY).^2)<rr,2);
        B(I,:) = [];
        
        hold all
        if Wred(i,j)~=0
            plot(B(:,1),B(:,2),'r','LineWidth',Wred(i,j));
        else
            plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
        end
        
        if Wblue(i,j)~=0
            plot(B(:,1),B(:,2),'b','LineWidth',Wblue(i,j));
        end
        
    end
end

% bottom up
for i=1:4
    for j=(i+1):4
        delta = i-j;
        
        p = [0,i;a*delta,i;a*delta,j;0,j];
        B = bezier(p);
        
        % remove inside circle
        I = any(sqrt((B(:,1)-CX).^2+(B(:,2)-CY).^2)<rr,2);
        B(I,:) = [];
        
        if Wred(i,j)~=0
            plot(B(:,1),B(:,2),'r','LineWidth',Wred(i,j));
        else
            plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
        end
        
        if Wblue(i,j)~=0
            plot(B(:,1),B(:,2),'b','LineWidth',Wblue(i,j));
        end
        
        
    end
end

% self connection

for i=1:4
    
    p = [0,i;-a,i+.5;a,i+.5;0,i];
    B = bezier(p);
    
    % remove inside circle
    I = any(sqrt((B(:,1)-CX).^2+(B(:,2)-CY).^2)<rr,2);
    B(I,:) = [];
    
    hold all
    if Wred(i,i)~=0
        plot(B(:,1),B(:,2),'r','LineWidth',Wred(i,i));
    else
        plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
    end
    
    if Wblue(i,i)~=0
        plot(B(:,1),B(:,2),'b','LineWidth',Wblue(i,i));
    end
    
end


plot(CX,CY,'linestyle','none','marker','o','markerfacecolor','w','markeredgecolor','k','markersize',20);


end


