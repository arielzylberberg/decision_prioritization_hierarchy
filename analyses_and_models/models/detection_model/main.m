addpath('../../../matlab_files_addtopath/');


%%

redo_fit = 0;

nsuj = 4;
for suj=1:nsuj
    
    load(['../../exportdata_for_DTB_with_errors/dataformodel_0560_group',num2str(suj),'.mat']);
    
    
    %% optim likelihood
    
    % kappa,coh0, phis, scale_noise, crit_slope_queries
    
    tl = [1,  0, 0, 0, 0, 0.0, 0];
    th = [40, 0, 1, 1, 1, 4.0, 20];
    tg = [20, 0, 0.2, 0.2, 0.1,1.0, 0];
    
    
    plot_flag = false;
    pars = [];
    
    
    var_names = {'kappa','coh0','phi1','phi2','phi3','scale_noise','crit_slope_queries'};
    
    if redo_fit
        fn_fit = @(theta) (wrapper_sdt_tree_choice_sbet(theta,dotdur,level,coh,choice,correct,sbet_on,optedout...
            ,nquery,visits_parents,var_names,plot_flag));
        
        options = optimset('Display','final','TolFun',.1,'FunValCheck','on');
        [theta, fval, exitflag, output] = fminsearchbnd(@(theta) fn_fit(theta),...
            tg,tl,th,options);
        
        out.theta    = theta;
        out.fval     = fval;
        out.exitflag = exitflag;
        out.output   = output;
        out.tguess   = tg;
        out.n_obs = length(dotdur);
        out.n_params = sum(th~=tl);
    else
        load(['optim',num2str(suj)]);
    end
    
    %% eval best
    
    plot_flag = true;
    [err,P,p_up,p_lo,p_out] = ...
        wrapper_sdt_tree_choice_sbet(theta,dotdur,level,coh,choice,correct,sbet_on,optedout,nquery, ...
        visits_parents, var_names,plot_flag);
    
    coh_fine = repmat(linspace(-0.6,0.6,300),1,3);
    coh_fine = coh_fine(:);
    nans = nan(size(coh_fine));
    level_fine = repmat([1,2,3],300,1);
    level_fine = level_fine(:);
    plot_flag = false;
    dotdur_fine = 0.2*ones(size(coh_fine));
    
    % for different number of prev queries
    for iprev = 1:20
        i = iprev;
        nqueries_visits = ones(size(coh_fine))*iprev;
        [~,~,p_up_fine_nq(:,i),p_lo_fine_nq(:,i),p_out_fine_nq(:,i)] = ...
            wrapper_sdt_tree_choice_sbet(theta,dotdur_fine,level_fine,coh_fine,...
            nans,nans,nans,nans,nqueries_visits,nans,var_names,plot_flag);

        pright_fine_nq(:,i) = p_up_fine_nq(:,i)./(p_up_fine_nq(:,i)+p_lo_fine_nq(:,i));
        correct_fine_nq(:,i) = choose([pright_fine_nq(:,i), 1-pright_fine_nq(:,i)],...
            [coh_fine>0,coh_fine<0]);
    end
    
    
    % marginalize over number_of_queries
    [ne,nq] = size(pright_fine_nq);

    cprod = [ones(ne,1), cumprod(p_out_fine_nq(:,1:end-1),2)];

    W = (1-p_out_fine_nq).*cprod; %prob of motion choice after x queries

    correct_fine = sum(W.*correct_fine_nq,2);
    pright_fine = sum(W.*pright_fine_nq,2);
    p_out_fine = sum(W.*p_out_fine_nq,2);

    
    forplot(suj) = struct('pright_fine', pright_fine, ...
        'correct_fine', correct_fine, ...
        'p_out_fine',p_out_fine, ...
        'level_fine', level_fine, ...
        'coh_fine', coh_fine,...
        'group_fine', ones(size(coh_fine))*suj, ...
        'correct', correct, ...
        'choice', choice, ...
        'nquery_anytime', nquery_anytime, ...
        'coh', coh, ...
        'level', level, ...
        'optedout', optedout, ...
        'pright_fine_nq',pright_fine_nq,...
        'correct_fine_nq',correct_fine_nq,...
        'p_out_fine_nq',p_out_fine_nq,...
        'group', ones(size(choice))*suj);
    
    
    p = publish_plot(2,1);
    set(gcf,'Position',[683  146  317  571]);
    p.displace_ax(1,-0.07,2);
    p.displace_ax([1,2],0.07,1);
    colores = movshon_colors(3);
    p.next();
    [tt,xx,ss] = curva_media_hierarch(correct,abs(coh),level,optedout==0,0);
    for i=1:3
        terrorbar(tt,xx(:,i),ss(:,i),'LineStyle','none','marker','.','markersize',20,'color',colores(i,:));
        hold all
        [ttf,xxf] = curva_media(correct_fine,abs(coh_fine),level_fine==i,0);
        plot(ttf,xxf,'color',colores(i,:));
    end
    
    p.next();
    [tt,xx,ss] = curva_media_hierarch(optedout==1,abs(coh),level,[],0);
    for i=1:3
        terrorbar(tt,xx(:,i),ss(:,i),'LineStyle','none','marker','.','markersize',20,'color',colores(i,:));
        hold all
        [ttf,xxf] = curva_media(p_out_fine,abs(coh_fine),level_fine==i,0);
        plot(ttf,xxf,'color',colores(i,:));
    end
    
    p.current_ax(1);
    
    ylabel('Proportion correct')
    
    p.current_ax(2);
    xlabel('Motion coherence')
    ylabel('Proportion watch again')
    
    
    set(p.h_ax,'xlim',[0.02,0.8],'xscale','log');
    set(p.h_ax,'xtick',[0.032,0.064,0.128,0.256,0.512],...
        'xticklabel',100*[0.032,0.064,0.128,0.256,0.512],'xminortick','off','tickdir','out')
    set(p.h_ax(1),'xticklabel','');
    
    set(p.h_ax(1),'ylim',[0.5,1]);
    set(p.h_ax(2),'ylim',[0,0.8]);
    
    p.format('FontSize',14);
    
    
    
    %%
    save(['optim',num2str(suj)],'err','P','theta','out','tl','th','tg');
    
    
end

save forplot forplot

%%
run_do_plot();