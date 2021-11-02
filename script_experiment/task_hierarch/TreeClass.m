classdef TreeClass < handle
    properties
        nodes = node.empty()
        n_nodes = 0
        connections = []
        offWindow_skeleton
        skeleton_color = .3*[255,255,255]
        
    end
    
    methods
        function obj = TreeClass(xlower,ylower,ydelta,nlevels)
        
            %bottom level
            for i=1:length(xlower)
                obj.add_node(xlower(i),ylower,nlevels)
            end
            
            %bottom - 1
            for curr_level=(nlevels-1):-1:1
                I = obj.find_nodes_below(curr_level);
                y = ylower - ydelta * (nlevels - curr_level);
                
                for i=1:2:length(I)
                    x = [obj.nodes(I(i)).x + obj.nodes(I(i+1)).x]/2;
                    obj.add_node(x,y,curr_level);
                    obj.add_connections(obj.n_nodes,I(i:i+1));
                end
            end
            
            % reorder the nodes, from top to bottom and left to right
            new_idx = [];
            for i=1:nlevels
                I = find([obj.nodes.level]==i);
                [~,ind] = sort([obj.nodes(I).x]);
                new_idx = [new_idx, I(ind)];
            end
            obj.nodes = obj.nodes(new_idx);
            obj.connections = arrayfun(@(x)find(new_idx==x,1),obj.connections);
            
            
        end
        
        function add_node(obj,x,y,level)
            obj.n_nodes = obj.n_nodes + 1;
            obj.nodes(obj.n_nodes) = node(x,y,level);
        end
        
        function I = find_nodes_below(obj,curr_level)
            I = [];
            for i=1:obj.n_nodes
                if obj.nodes(i).level == curr_level+1
                    I = [I, i];
                end
            end
        end
        
        function add_connections(obj,ID1,ID2)
            for i=1:length(ID1)
                for j=1:length(ID2)
                    row = size(obj.connections,1) + 1;
                    obj.connections(row,1) = ID1(i);
                    obj.connections(row,2) = ID2(j);
                end
            end
        end
        
        function offWindow = skeleton(obj,screenInfo)
            
            curWindow = screenInfo.curWindow;
            
            offWindow = Screen('OpenOffscreenWindow',curWindow);
            
            Screen('FillRect', offWindow, screenInfo.bckgnd);
            
            drawCurved_Flag = 1;
            if (drawCurved_Flag)
                for i=1:size(obj.connections,1)
                    fromH = obj.nodes(obj.connections(i,1)).x;
                    fromV = obj.nodes(obj.connections(i,1)).y;
                    toH = obj.nodes(obj.connections(i,2)).x;
                    toV = obj.nodes(obj.connections(i,2)).y;
                    P = [toH,toV;toH,fromV;fromH,fromV];
                    N = 200;
                    [x,y] = BezierCurve(N, P);
%                     Screen('DrawDots', offWindow, [x,y]' ,1,[255,255,255],[0,0]);
                    xy = [x,y]';
                    ind  =[1:size(xy,2)-1;2:1:(size(xy,2))];
                    xy = xy(:,ind);
                    [s_old, d_old] = Screen('BlendFunction', offWindow, GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
                    Screen('DrawLines', offWindow, xy,2,obj.skeleton_color,[0,0],1);
                    Screen('BlendFunction', offWindow, s_old,d_old);
                end
                
            else
                xy = [];
                for i=1:size(obj.connections,1)
                    fromH = obj.nodes(obj.connections(i,1)).x;
                    fromV = obj.nodes(obj.connections(i,1)).y;
                    toH = obj.nodes(obj.connections(i,2)).x;
                    toV = obj.nodes(obj.connections(i,2)).y;
                    xy = [xy, [fromH,fromV;toH,toV]'];
                end
                Screen('DrawLines', offWindow, xy ,2,obj.skeleton_color,[0,0],0);
            end
            
            obj.offWindow_skeleton = offWindow;
            
        end
        
        function draw(obj,screenInfo)
            
            curWindow = screenInfo.curWindow;
            
            Screen('CopyWindow',obj.offWindow_skeleton,curWindow);
            
            xy = [];
            for i=1:obj.n_nodes
                xy = [xy;obj.nodes(i).x,obj.nodes(i).y];
            end
            dotSize = 50;
            Screen('DrawDots', curWindow, xy', dotSize, [0,0,0], [0,0],1);
%             dotSize = 15;
%             Screen('DrawDots', curWindow, xy', dotSize, [255,0,0], [0,0],1);
            
        end
        
        function draw_matlab(obj)
            figure()
            hold on
            for i=1:obj.n_nodes
                plot(obj.nodes(i).x,obj.nodes(i).y,'bo')
            end
            
            for i=1:size(obj.connections,1)
                xf = obj.nodes(obj.connections(i,1)).x;
                yf = obj.nodes(obj.connections(i,1)).y;
                xt = obj.nodes(obj.connections(i,2)).x;
                yt = obj.nodes(obj.connections(i,2)).y;
                
                line([xf,xt],[yf,yt])
            end
            
        end
        
    end
end

%%
function [x y] = BezierCurve(N, P)
% This function constructs a Bezier curve from given control points. P is a
% vector of control points. N is the number of points to calculate.
%
% Example:
%
% P = [0 0; 1 1; 2 5; 5 -1];
% [x,y] = BezierCurve(1000, P);
% plot(x, y, P(:, 1), P(:, 2), 'x-', 'LineWidth', 2); set(gca, 'FontSize', 16)
%
% Prakash Manandhar, pmanandhar@umassd.edu

Np = size(P, 1);
u = linspace(0, 1, N);
B = zeros(N, Np);
for i = 1:Np
B(:,i) = nchoosek(Np-1,i-1).*u.^(i-1).*(1-u).^(Np-i); %B is the Bernstein polynomial value
end
S = B*P;
x = S(:, 1);
y = S(:, 2);
end