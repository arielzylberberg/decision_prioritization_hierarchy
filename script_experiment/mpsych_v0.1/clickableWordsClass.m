classdef clickableWordsClass < handle
    properties
        
        color_words = [255 255 255];
        color_words_selected = [255,125,0];
        
        marker_color = [255 204 77];
        mouse_acceptance_dist_px = 50;
        
        words = {'sure','pretty sure','could be','maybe'}
        
        left_x_deg
        center_y_deg
        font_size
        vert_size_deg
        
        xpos
        ypos
        
        word_rect
        
        traj
        choice
        RT
        resp_given
        resp_id
        
        
        
    end
    
    methods
        function obj = clickableWordsClass()
            
        end
        
        function setPars(obj,varargin)
            for i=1:2:length(varargin)
                obj.(varargin{i}) = varargin{i+1};
            end
        end
        
        function init_exp(obj,screenInfo)
            
            cx = screenInfo.center(1);
            cy = screenInfo.center(2);
            
            % calc the position of each word in pixels
            %         left_x_deg
            %         center_y_deg
            %         font_size
            %         vert_size_deg
            
            left_x_px = cx + obj.left_x_deg * screenInfo.ppd;
            center_y_px = cy + obj.center_y_deg * screenInfo.ppd;
            vert_size_px = obj.vert_size_deg * screenInfo.ppd;
            
            nwords = length(obj.words);
            obj.ypos = center_y_px + linspace(-vert_size_px/2,vert_size_px/2,nwords);
            obj.xpos = left_x_px * ones(1,nwords);
            
            % make a plo
            
            for i=1:nwords
                
                [normBoundsRect, offsetBoundsRect, textHeight, xAdvance] = Screen('TextBounds', ...
                    screenInfo.curWindow,obj.words{i},obj.xpos(i),obj.ypos(i));
                
                obj.word_rect(i,:) = offsetBoundsRect;
            end
            
            
            
        end
        
        function ForSessionData = sessionInfo(obj)
            ForSessionData = struct(obj);
        end
        
        function ForTrialData = trialInfo(obj)
            ForTrialData.traj = obj.traj;
            ForTrialData.RT = obj.RT;
            ForTrialData.resp_id = obj.resp_id;
            ForTrialData.resp_given = obj.resp_given;
            
        end
        
        function prepare_trial(obj)
            %reset traj
            obj.traj = [];
            obj.choice = nan;
            obj.RT = nan;
            obj.resp_given = false;
            obj.resp_id = nan;
            
        end
        
        function draw(obj,screenInfo)
            
            Screen('BlendFunction', screenInfo.curWindow, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            curWindow   = screenInfo.curWindow;
            n = length(obj.words);
            %             center_x = nan(n,1);
            %             center_y = nan(n,1);
            
            colores = repmat(obj.color_words,n,1);
            if ~isnan(obj.resp_id)
                colores(obj.resp_id,:) = obj.color_words_selected;
            end
            
            for i=1:n
                [newX,newY,textHeight] = Screen('DrawText', curWindow, ...
                    obj.words{i},obj.xpos(i),obj.ypos(i),colores(i,:));
                %                 center_x(i) = obj.xpos(i) + newX/2;
                %                 center_y(i) = obj.ypos(i) + textHeight/2;
                %
                %                 wx = newX-obj.xpos(i);
                %                 obj.word_rect(i,:) = [obj.xpos(i),obj.ypos(i),obj.xpos(i)+wx, obj.ypos(i) + textHeight];
            end
            
            
            
        end
        
        
        function [respGiven,resp] = gotResp(obj,tini,screenInfo,Mouse)
            
            respGiven = false;
            resp = nan;
            
            [mx,my,buttons] = Mouse.GetMousePosition(screenInfo.curWindow);
            
            % guardar
            if isempty(obj.traj) || ...
                    (obj.traj(end,2)~=mx && obj.traj(end,3)~=my)
                obj.traj = [obj.traj; GetSecs()-tini mx my];
                
            end
            
            pos = [mx,my];
            for i=1:length(obj.words)
                region.type = 'rect';
                region.spec = obj.word_rect(i,:);
                inside(i) = isInsideRegion(pos, region);
            end
            
            if any(inside) && any(buttons)
                respGiven = true;
                resp = find(inside);
            end
            
            obj.resp_given = respGiven;
            obj.resp_id = resp;
            obj.RT = GetSecs()-tini;
            
            
            
            %             region.type = 'rect';xs
            %             delta = 10;%tolerance for response
            %             miniX = min(obj.puntos(2).x);
            %             maxiX = max(obj.puntos(1).x);
            %             region.spec = [miniX-screenInfo.center(1) obj.ypos_px-delta maxiX-screenInfo.center(1) obj.ypos_px+delta];
            %             if obj.vertical
            %                 pos = [my mx];
            %             else
            %                 pos = [mx my];
            %             end
            %             inside = isInsideRegion(pos, region);
            %
            %             %ver si el trial termina
            %             if (inside)
            %                 respGiven = true;
            %             end
            
        end
        
        
        
        
        
        
        
        
        
        
        
    end
end