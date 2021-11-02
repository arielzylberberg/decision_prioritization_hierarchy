function [pplot, params] = draw_transitions_between_levels(TMat_levels, normalize_to_max)
% TMat_levels: transition matrices between levels. TMat_levels(j,i):
% transitions from i to j


TMat_levels = TMat_levels';

if nargin==1
    normalize_to_max = 0;
end

% sanity check 
if ~all(size(TMat_levels)==[4,4])
    error('wrong size');
end

% resort rows and cols, from levels to nodes (now 1 is the lowest level); 
M = TMat_levels(4:-1:1,:);
M = M(:,4:-1:1);

params.max_prob = max(M(:));

if normalize_to_max
    M = M/max(M(:));
end


% probs to line width
scaling_line_width = 10;
W = M * scaling_line_width;

min_v = 1/20;
W(M<min_v) = 0;

params.min_v = min_v;
params.scaling_line_width = scaling_line_width;

pplot = publish_plot(1,1);
set(gcf,'Position',[430  267  444  538]);

CX = [0,0,0,0];
CY = 1:4;

draw_as_circles_flag = 0;
if draw_as_circles_flag
    % draw circles
    for i=1:4
        r = 0.2;
        pos = [0-r i-r 2*r 2*r];
        hrect(i) = rectangle('Position',pos,'Curvature',[1 1]);
        hold all
    end
    axis equal
end
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
        if W(i,j)~=0
            plot(B(:,1),B(:,2),'r','LineWidth',W(i,j));
        else
            plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
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
        
        if W(i,j)~=0
            plot(B(:,1),B(:,2),'r','LineWidth',W(i,j));
        else
            plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
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
    if W(i,i)~=0
        plot(B(:,1),B(:,2),'r','LineWidth',W(i,i));
    else
        plot(B(:,1),B(:,2),'k--','LineWidth',0.5);
    end

      
end

if draw_as_circles_flag==0
    plot(CX,CY,'linestyle','none','marker','o','markerfacecolor','w','markeredgecolor','k','markersize',20);
end

end