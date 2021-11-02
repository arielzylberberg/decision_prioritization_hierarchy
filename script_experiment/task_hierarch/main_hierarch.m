function main_hierarch()

addpath('../mpsych_v0.1/')
addpath('./files_add_to_path/');
TASK_ID = 560;

%%

workspace
KbName('UnifyKeyNames');
query = QuerySubjectClass();
extension = mfilename;
extension = strrep(extension,'.mat','');
extension = strrep(extension,'main_','');


try
    
    screenInfo = openExperiment(37,48); % psychophysics, small room
    curWindow = screenInfo.curWindow;
    dontclear = screenInfo.dontclear;
    
    % set eyetracker
    Eye = EyeTrackerClass();
    if isequal(screenInfo.computer,'Ariels-MacBook-Pro.local')
        Eye.setPars('dummymode',1);
    end
    
    Mouse = MouseClass();
    
    d = DotsClass(1);
    %remove 0% coh trials
    d.setPars(1,'cohSet',[3.2, 6.4, 12.8, 25.6, 51.2]*10);
    
    
    cx = screenInfo.center(1);
    cy = screenInfo.center(2);
    
    deltay = 4.8*screenInfo.ppd;
    tree = TreeClass(([1:8]-4.5)*deg2pix(4,screenInfo) + cx, 3*deltay/2 + cy, deltay, 4);
    tree.skeleton(screenInfo);
    
    %set targets at node positions
    targets = TargetsClass();
    targets.setPars('tar_accept_radius_deg',2.2);
    for i=1:length(tree.nodes)
        x = tree.nodes(i).x;
        y = tree.nodes(i).y;
        targets.add(x,y,10,[255 0 0]);
    end
    
    payoff = [-1,-3,10]; %listen,loss,win
    
    %sonido feedback
    Audi = AudioPlayClass('files',{'ding.wav','signoff.wav','secalert.wav','click.wav'});
    
    key = KeysClass();
    
    times = TimeClass('interdots','dots_on','intertrial','show_choice',...
        'error_timeout','nochoice_timeout','fixbreak_timeout','refract_post_dots','show_feedback');
    
    Mouse.Hide(screenInfo);
    
    % pasar a otro lado:
    Priority(MaxPriority(screenInfo.curWindow));
    
    nBlocks = 5;
    nTr = 50; %trials per block
    
    for iBlock = 1:nBlocks
        
        %name of file to save
        filename = createFileName(query.subject,extension,TASK_ID);
        
        % setapear el eye tracker
        Eye.setupEyetracker(screenInfo);
        
        %
        WaitSecs(3);
        
        % 
        reward_block = 0;
        
        %randomize seeds
        RandomizeGlobalSeed;
        
        clear trialData
        
        tro = trialOrgaClass(nTr);
        while tro.trials_left()
            
            trCount = tro.increse_trial_count();
            
            done = 0;
            trial_result = '';
            [vCoh,vDir,correct_node] = set_trial(d,tree);
            dotsData = [];
            
            reward_trial = [0,0,0];% counter: listen,loss,win
            trial_with_calibration = 0;
            
            
            nextstep = 'show_tree';
            
            times.sample('dots_on',      {'type',0,'min',0.2});
            times.sample('refract_post_dots',      {'type',0,'min',0.3});
            times.sample('show_feedback',   {'type',0,'min',1.0});
            times.sample('interdots',   {'type',0,'min',1.0});
            times.sample('intertrial',   {'type',0,'min',1.0});
            times.sample('error_timeout',{'type',0,'min',1.0});
            times.sample('show_choice',  {'type',0,'min',0.1});
            times.sample('nochoice_timeout',{'type',0,'min',2.0});
            times.sample('fixbreak_timeout',{'type',0,'min',2.0});
            
            ref_time = GetSecs();
            
            while ~done
                
                switch nextstep
                    
                    case 'show_tree'
                        Eye.Message(nextstep);
                        boolTarSelected = false;
                        key.cleanForNextTrial();
                        targets.resetAllColors([255,0,0]);
                        while ~key.space || ~boolTarSelected
                            
                            targets.resetAllColors([255,0,0]);
                            boolTarSelected = targets.colorHover(screenInfo,Eye,key,[255/2,255/2,255]);
                            tree.draw(screenInfo);
                            targets.draw(screenInfo);
                            % Eye.ShowEyePosition(screenInfo);
                            
                            Screen('Flip',screenInfo.curWindow,0,1);
                            
                            if targets.selTar<=7 %non terminal node
                                nextstep = 'prepare_show_dots';
                            elseif targets.selTar>7 %terminal node
                                nextstep = 'check_accuracy';
                            end
                            
                            if key.calibrate_eye
                                Eye.Message('eyecalibration_in');
                                Eye.doCalibration();
                                key.wait_and_clean();
                                Eye.Message('eyecalibration_out');
                                trial_with_calibration = 1;
                            end
                            
                            if key.abort
                                error('out!')
                            end
                        end
                        if targets.selTar>7 %terminal node
                            dotsData = [dotsData; targets.selTar,nan,nan,nan,GetSecs()-ref_time];
                        end
                        
                        
                    case 'prepare_show_dots'
                        Eye.Message(nextstep);
                        I = targets.selTar;
                        x = targets.targ(I).dat.position.x - screenInfo.center(1);
                        y = targets.targ(I).dat.position.y - screenInfo.center(2);
                        xdeg_rex = 10*x/screenInfo.ppd;
                        ydeg_rex = -1 * 10*y/screenInfo.ppd;
                        dotdiam_rex = 40; %deg * 10
                        apXYD = [xdeg_rex, ydeg_rex, dotdiam_rex];
                        seed = ceil(1000000*rand);
                        
                        d.df{1}.setPars('coh',vCoh(I),'dir',vDir(I),...
                            'rseed',seed,'apXYD',apXYD);
                        
                        d.prepare_draw(screenInfo);
                        
                        dotsData = [dotsData; targets.selTar,seed,vCoh(I),vDir(I),GetSecs()-ref_time];
                        nextstep = 'dots_on_fix_dur';
                        
                    case 'dots_on_fix_dur'
                        disp(nextstep)
                        
                        while d.df{1}.frames <= sec2frames(times.dat.dots_on,screenInfo)
                            
                            tree.draw(screenInfo);
                            targets.draw(screenInfo);
                            d.df{1}.draw(screenInfo);
                            
                            
                            
                            Screen('Flip',screenInfo.curWindow,0,0);
                            if d.df{1}.frames == 1
                                Eye.Message(nextstep);
                            end
                        end
                        
                        reward_trial(1) = reward_trial(1)+1;
                        nextstep = 'dots_off';
                        
                    case 'dots_off'
                        disp('dots_off')
                        Eye.Message(nextstep);
                        
                        nextstep = 'refractory_post_dots';
                        
                    case 'refractory_post_dots'
                        Eye.Message(nextstep);
                        Screen('FillRect',screenInfo.curWindow,screenInfo.bckgnd);
                        tree.draw(screenInfo);
                        targets.draw(screenInfo);
                        Screen('Flip',screenInfo.curWindow,0,1);
                        tini = GetSecs();
                        while (GetSecs()-tini)<times.dat.refract_post_dots
                            
                        end
                        
                        nextstep = 'show_tree';
                        
                    case 'check_accuracy'
                        disp(nextstep)
                        Eye.Message(nextstep);
                        
                        correct = correct_node == targets.selTar;
                        if correct == 1
                            trial_result = 'CORRECT';
                            reward_trial(3) = reward_trial(3) + 1;
                            Audi.playSound('ding.wav');
                            WaitSecs(times.dat.interdots);
                            
                            nextstep = 'show_feedback';
                            
                        else
                            trial_result = 'WRONG';
                            reward_trial(2) = reward_trial(2) + 1;
                            Audi.playSound('signoff.wav');
                            WaitSecs(times.dat.interdots);
                            
                            nextstep = 'show_tree';
                        end
                        
                    case 'show_feedback'
                        disp(nextstep)
                        Eye.Message(nextstep)
                        
                        reward_block = reward_block + sum(reward_trial.*payoff);
                        
                        while KbCheck(-1);end
                        
                        Eye.Message('enter_feedback_screen')
                        show_points(screenInfo,reward_trial,payoff,reward_block);
                        
                        KbWait(-1);
                        Eye.Message('left_feedback_screen')
                        
                        nextstep = 'intertrial';
                        
                    case 'intertrial'
                        disp(nextstep)
                        Eye.Message(nextstep)
                        
                        %pantalla negra
                        Screen('FillRect', curWindow, screenInfo.bckgnd)
                        Screen('Flip', curWindow,0,dontclear);
                        WaitSecs(times.dat.intertrial);
                        
                        nextstep = 'blockfeedback';
                        
                        trialData(trCount).correct = correct;
                        trialData(trCount).vCoh = vCoh;
                        trialData(trCount).vDir = vDir;
                        trialData(trCount).correct_node = correct_node;
                        trialData(trCount).dotsData = dotsData;
                        
                        trialData(trCount).trial_result = trial_result;
                        trialData(trCount).rdm1 = d.df{1}.trialInfo();
                        trialData(trCount).times = times.trialInfo();
                        trialData(trCount).TASK_ID = TASK_ID;
                        trialData(trCount).reward_trial = reward_trial;
                        trialData(trCount).reward_block = reward_block;
                        trialData(trCount).trial_with_calibration = trial_with_calibration;
                        
                        
                        eyeInfo = Eye.sessionInfo();
                        mouseInfo = Mouse.sessionInfo();
                        targetsInfo = targets.sessionInfo();
                        keysInfo = key.sessionInfo();
                        dotInfo = d.sessionInfo();
                        queryInfo = query.sessionInfo();
                        
                        save(filename,'trialData','screenInfo',...
                            'eyeInfo','mouseInfo','targetsInfo',...
                            'keysInfo','dotInfo','queryInfo',...
                            'payoff');
                        Eye.Message('trial_saved');
                        
                        targets.cleanForNextTrial();
                        key.cleanForNextTrial();
                        
                        
                    case 'blockfeedback'
                        % mostrar performance en el block, e historia
                        % anterior
                        
                        disp(nextstep)
                        Eye.Message(nextstep)
                        
                        done = 1;
                        
                        nextstep = 'show_tree';
                        if tro.is_last_trial()
                            
                            img = get_prev_performance(query.subject,extension,TASK_ID,reward_block);
                            
                            % rest every 100 trials
                            Screen('FillRect', curWindow, screenInfo.bckgnd)
                            [nx, ny, bbox] = DrawFormattedText(curWindow, 'You can take a break',...
                                'center', 200, [255 255 255]);
                            
                            [nx, ny, bbox] = DrawFormattedText(curWindow, ['Points in block: ',num2str(reward_block)],...
                                'center', 260, [255 255 255]);
                            
                            [nx, ny, bbox] = DrawFormattedText(curWindow, 'Please wait to continue...',...
                                0, 700, [255 255 255]);
                            
                            
                            rr = size(img,1)./size(img,2);
                            ww = 500;
                            Screen('PutImage', curWindow, img, [cx-ww/2,320,cx+ww/2,320 + ww*rr]);%put image on screen

                            Screen('Flip', curWindow,0,1);
                            
                            
                            
                            
                        end
                        
                end
                
            end
        end
        
        if iBlock<nBlocks
            Eye.StopAndGetFile(filename);
        
            % press key to continue screen
            Screen('FillRect', curWindow, screenInfo.bckgnd)
            [nx, ny, bbox] = DrawFormattedText(curWindow, 'Press key when ready...',...
                                0, 700, [255 255 255]);
            Screen('Flip', curWindow,0,1);
            KbWait(-1);
            
        else
            Screen('FillRect', curWindow, screenInfo.bckgnd)
            [nx, ny, bbox] = DrawFormattedText(curWindow, 'done.',...
                                0, 700, [255 255 255]);
            Screen('Flip', curWindow,0,1);
            Eye.StopAndGetFile(filename);
            
        end
                
    end
    
    Priority(0);
    sca
    Audi.close();
    
    
catch
    sca
    Priority(0);
    Audi.close();
    ple
end

clear screen

end



