classdef ColoredDotsClass < handle
    properties
        pars_exp
        vars_for_draw
        dir
        p_color_1 % careful: proportion of probability??

        
        % uni_p_color_1 = linspace(0.5,1,20);
        
        stimuli 
        
        rseed = []
        rand_algorithm = 'mt19937ar'
        rstream
        
    end
    
    
    methods
        
        % defined here
        function obj = ColoredDotsClass(varargin)
            %instantiates object with default values
            if ~isempty(varargin)
                obj.setPars(varargin{:})
            end
        end
        
        function setPars(obj,varargin)
            for i=1:2:length(varargin)
                obj.(varargin{i}) = varargin{i+1};
            end
        end
        
        function ForSessionData = sessionInfo(obj)
            ForSessionData = struct(obj);
        end
        
        function ForTrialData = trialInfo(obj)
            % save
            ForTrialData.p_color_1       = obj.p_color_1;
            ForTrialData.stimuli         = obj.stimuli;
            
        end
        
        function init_exp(obj,screenInfo)
            
            ppd = screenInfo.ppd;
            
            obj.pars_exp.annulusRadius          = 4 * ppd;
            obj.pars_exp.N                      = 40;
            obj.pars_exp.dotSize                = 4; % pixels
            obj.pars_exp.colors                 = [0,0.5,1; 1,0,0];
            
            
        end
        
        function prepare_draw(obj,screenInfo)
            

            rseed = sum(100*clock);
            rstream = RandStream(obj.rand_algorithm,'Seed',rseed);

            obj.rstream = rstream;
            obj.rseed = rseed;
            
            
            % make stim
            R = obj.pars_exp.annulusRadius;
            n = obj.pars_exp.N;
            [x,y] = sample_uniformly_from_cirlce(R,n,obj.rstream);
            
            nc1 = round(obj.p_color_1*n); % number of dots in color 1
            color_id = [ones(nc1,1);2*ones(n-nc1,1)];
            
            obj.stimuli.xy = [x(:),y(:)]';
            obj.stimuli.color_id = color_id;
            
                
        end
        
        
        function draw(obj,screenInfo)
            

            curWindow = screenInfo.curWindow;
            
            Screen('BlendFunction', curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
            xy = obj.stimuli.xy;
            color_id = obj.stimuli.color_id;
            dotSize = obj.pars_exp.dotSize;
            center = screenInfo.center;
            
            dotColor = obj.pars_exp.colors(color_id,:)' * 255;
            
            dot_type = 2;
            Screen('DrawDots', curWindow, xy, dotSize, dotColor, center, dot_type);
            
            
            
            
        end
        
    end
end

