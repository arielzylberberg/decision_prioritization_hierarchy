classdef TreeClassAnalysis < handle
    properties
        nodes = node.empty()
        n_nodes = 0
        connections = []
        
    end
    
    methods
        function obj = TreeClassAnalysis(xlower,ylower,ydelta,nlevels)
        
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
        
        %%%
        
        function set_correct_path(obj,correct_on_right)
            %sanity check
            if length(correct_on_right)~=(length(obj.nodes)-1)/2
                error('wrong size')
            end
            n = length(correct_on_right);
            for i=1:n
                inds = find(obj.connections(:,1)==i);
                if correct_on_right(i)==1
                    obj.connections(inds,3) = [0,1];
                else
                    obj.connections(inds,3) = [1,0];
                end
            end
        end
        
        function [path,last] = get_path_sequence(obj,seq)
            path = nan(length(seq)+1,1);
            path(1) = 1;
            last = 1;
            for i=1:length(seq)
                ind = obj.connections(:,1)==last & obj.connections(:,3)==seq(i);
                last = obj.connections(ind,2);
                path(i+1) = last;
            end
        end
        
        function [B,C,V] = node_role(obj , visited)
            % B: nodes in functional order
            % C: whether the next selection was correct or incorrect (only 
            % if the S went to a child node)
            
            % all sequences
            all_seq = [ nan   nan   nan
                        nan   nan   1
                        nan   nan   0
                        nan   1     1
                        nan   1     0
                        nan   0     1
                        nan   0     0
                        1     1     1
                        1     1     0
                        1     0     1
                        1     0     0
                        0     1     1
                        0     1     0
                        0     0     1
                        0     0     0 ];
                    
%             node_num_sorted = [1, 2 , 5, 3, 4, 6, 7, ...
%                 8, 9, 10, 11, 12, 13, 14, 15];%corresponding to the seq above
            
            

            node_num_sorted = [1,3,2,7,6,5,4,15,14,13,12,11,10,9,8];

        
%             node_num_sorted = [1:15];%corresponding to the seq above            
            
            V = [node_num_sorted(:),node_num_sorted(:)];
            for i = 1:size(all_seq,1)
                seq = all_seq(i,:);
                seq(isnan(seq)) = [];
                if ~isempty(seq)
                    [~,last] = obj.get_path_sequence(seq);
                    V(i,1) = last;
                end
            end
            
            B = changem( visited ,V(:,2),V(:,1)); %replace spatial nodes by functional
            
            %now I see if the Ss went to a child node after the dots, and
            %in that case whether it was correct or not
%             childs = [1 3 2; %start correct incorrect
%                       2 5 4;
%                       3 7 6;
%                       4 9 8;
%                       5 11 10;
%                       6 13 12;
%                       7 15 14;
%                       8 nan nan;
%                       9 nan nan;
%                       10 nan nan;
%                       11 nan nan;
%                       12 nan nan;
%                       13 nan nan;
%                       14 nan nan;
%                       15 nan nan;
%                       ];
%             childs = [1 2 5; %start correct incorrect
%                       2 3 4;
%                       5 6 7;
%                       3 8 9;
%                       4 10 11;
%                       6 12 13;
%                       7 14 15;
%                       8 nan nan;
%                       9 nan nan;
%                       10 nan nan;
%                       11 nan nan;
%                       12 nan nan;
%                       13 nan nan;
%                       14 nan nan;
%                       15 nan nan;
%                       ];
                  
             childs = [1 3 2; %start correct incorrect
                      2 5 4;
                      3 7 6;
                      4 9 8;
                      5 11 10;
                      6 13 12;
                      7 15 14;
                      8 nan nan;
                      9 nan nan;
                      10 nan nan;
                      11 nan nan;
                      12 nan nan;
                      13 nan nan;
                      14 nan nan;
                      15 nan nan;
                      ];
%             
             C = nan(size(B));
             Baux = B;
%              Baux(Baux>7) = nan;
             aa = changem( Baux ,childs(:,2),childs(:,1));
             inds = find(Baux(2:end)==aa(1:end-1));
             C(inds) = 1;% correct next
             aa = changem( Baux ,childs(:,3),childs(:,1));
             inds = find(Baux(2:end)==aa(1:end-1));
             C(inds) = 0;% correct next
                 
             

                 
                  
        end
        
        function [h_markers, h_lines, h_markers_white, h_text] = draw_matlab(obj, w, plot_type, ext_text)
            if nargin<2 || isempty(w)
                w = ones(obj.n_nodes,1);
            end
            if nargin<3 || isempty(plot_type)
                plot_type = 1;
            end
            w = w/nansum(w);
            
            switch plot_type
                case 1
                    draw_markers = 1;
                    draw_numbers = 0;
                    draw_ext = 0;

                case 2
                    draw_markers = 0;
                    draw_numbers = 1;
                    draw_ext = 0;
                case 3
                    draw_markers = 1;
                    draw_numbers = 1;
                    draw_ext = 0;
                case 4
                    draw_markers = 1;
                    draw_numbers = 0;
                    draw_ext = 1;
                    

            end
            

            h_markers = nan(obj.n_nodes,1);
            h_lines = nan(size(obj.connections,1),1);
            h_markers_white = nan(obj.n_nodes,1);
            
            figure()
            hold on
            
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
                    
                    n_ignore = 0;
                    I = [1:N]>n_ignore & [1:N]<=N-n_ignore;
                    
                    xy = [x(I),y(I)]';
                    ind  =[1:size(xy,2)-1;2:1:(size(xy,2))];
                    xy = xy(:,ind);
                    
                    h_lines(i) = plot(xy(1,:),xy(2,:),'k');
                    hold all
                    %         [s_old, d_old] = Screen('BlendFunction', offWindow, GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
                    %         Screen('DrawLines', offWindow, xy,2,tree.skeleton_color,[0,0],1);
                    %         Screen('BlendFunction', offWindow, s_old,d_old);
                end
            else
                for i=1:size(obj.connections,1)
                    xf = obj.nodes(obj.connections(i,1)).x;
                    yf = obj.nodes(obj.connections(i,1)).y;
                    xt = obj.nodes(obj.connections(i,2)).x;
                    yt = obj.nodes(obj.connections(i,2)).y;

                    h_lines(i) = line([xf,xt],[yf,yt]);
                end
            end
            
            
            
            for i=1:obj.n_nodes
                if ~isnan(w(i))
                    h_markers_white(i) = plot(obj.nodes(i).x,obj.nodes(i).y,'bo','markersize',ceil(w(i)*400),'markerfacecolor','w','markeredgecolor','w');
                end
            end
            h_markers = [];
            if draw_markers
                for i=1:obj.n_nodes
                    if ~isnan(w(i))
                        h_markers(i) = plot(obj.nodes(i).x,obj.nodes(i).y,'bo','markersize',ceil(w(i)*300),'markerfacecolor','k');
                    end
                end
            end
            
            h_text = [];
            if draw_numbers
                for i=1:obj.n_nodes
                    if ~isnan(w(i))
                        h_text(i) = text(obj.nodes(i).x,obj.nodes(i).y,num2str(i));
                        set(h_text(i),'verticalalignment','middle',...
                            'horizontalalignment','center','FontSize',14);
                    end
                end
            end    
            
            if draw_ext
                for i=1:obj.n_nodes
                    if ~isnan(w(i))
                        h_text(i) = text(obj.nodes(i).x,obj.nodes(i).y,num2str(ext_text(i)));
                        set(h_text(i),'verticalalignment','middle',...
                            'horizontalalignment','center','FontSize',14);
                    end
                end
            end
            
            if plot_type==2
                set(h_markers_white,'markeredgecolor',0.7*[1,1,1]);
                set(h_lines,'color',0.7*[1,1,1]);
                
            elseif plot_type==3
                set(h_markers,'markersize',10,'markerfacecolor',0.7*[1,1,1],'markeredgecolor','none');
                set(h_lines,'color',0.7*[1,1,1]);
                for i=1:length(h_text)
                    pos = get(h_text(i),'position');
                    pos(2) = pos(2)-0.2;
                    set(h_text(i),'position',pos);
                end
            
            elseif plot_type==4
                set(h_markers,'markersize',10,'markerfacecolor',0.7*[1,1,1],'markeredgecolor','none');
                set(h_lines,'color',0.7*[1,1,1]);
                for i=1:length(h_text)
                    pos = get(h_text(i),'position');
                    pos(2) = pos(2)-0.2;
                    set(h_text(i),'position',pos);
                end
            end
            
            % format
            set(gca,'visible','off');
            set(gcf,'Position',[358  290  629  341]);
            
        end
        
    end
end

