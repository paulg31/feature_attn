function [arc, arc_mean] = drawarc(screen,design,params)
%if nargin <4;params.cue_instruct = 0;end
% Creates the pre and post cues. Draws 2 arcs on opposite sides, then
% covers them so they're not 'blocky'

xCenter = screen.xCenter;
yCenter = screen.yCenter;    

% Circle Cue diameter and thickness in pixels
diam  = 2*screen.circle_size*screen.pxPerDeg;
thick = screen.circle_thickness*screen.pxPerDeg;

% Arc Cue Information
radius      = design.arc_dist*screen.pxPerDeg;
arc_sigma   = params.width;
dev_draw    = 3; % how far out to draw arcs
arc_mean    = (randn*arc_sigma + params.trial_mean)*pi/180;
arc_step    = pi/180;
arc_start   = arc_mean - (dev_draw*arc_sigma*pi/180);
arc_end     = arc_mean + (dev_draw*arc_sigma*pi/180);
sigma       = arc_sigma*pi/180;     % sigma in rads for normpdf

% Arc cover
count     = 1;
spans     = arc_start:arc_step:arc_end;
xval      = zeros(1,numel(spans));
yval      = zeros(1,numel(spans));
newx      = zeros(1,numel(spans));
newy      = zeros(1,numel(spans));
xvalop    = zeros(1,numel(spans));
yvalop    = zeros(1,numel(spans));
newxop    = zeros(1,numel(spans));
newyop    = zeros(1,numel(spans));

for angle  = spans
    
    % Height of Cues
    dist_height   = 10*normpdf(angle,arc_mean,sigma)+radius;

    % Arc cover points
    xval(count)   = cos(angle)*radius +xCenter;
    yval(count)   = -sin(angle)*radius +yCenter;
    xvalop(count) = -cos(angle)*radius +xCenter;
    yvalop(count) = sin(angle)*radius +yCenter;

    % Arc points
    newy(count)   = -sin(angle)*(dist_height) + yCenter;
    newx(count)   = cos(angle)*(dist_height) + xCenter;
    newyop(count) = sin(angle)*(dist_height) + yCenter;
    newxop(count) = -cos(angle)*(dist_height) + xCenter;
    
    count = count +1;
end

% Circle Cue Information
circle.baseRect = [0 0 diam diam ];
circle.baseRect2 = [0 0 diam-thick diam-thick];

% Precue
switch params.pre_cue
    
    case 1 % Arcs
        arc.type2draw.pre = 'FillPoly';  
        % Arc Cover
        arc.cover.pre     = [xval',yval'];
        arc.coveropp.pre   = [xvalop',yvalop'];
        % Arc
        arc.poly.pre   = [newx',newy'];
        arc.polyopp.pre = [newxop',newyop'];
        
    case 0 % Circle
        arc.poly.pre = CenterRectOnPointd(circle.baseRect,xCenter, yCenter);
        arc.cover.pre = CenterRectOnPointd(circle.baseRect2,xCenter, yCenter);
        arc.polyopp.pre = [0 0 0 0];
        arc.coveropp.pre = [0 0 0 0];
        arc.type2draw.pre = 'FillOval';
        
    case 2 % Nothing
        arc.poly.pre = [0 0 0 0];
        arc.cover.pre = [0 0 0 0];
        arc.polyopp.pre = [0 0 0 0];
        arc.coveropp.pre = [0 0 0 0];
        arc.type2draw.pre = 'FillOval';
end

% Postcue
switch params.post_cue

    case 1 % Arcs
        arc.type2draw.post = 'FillPoly';
        
        % Arc Cover
        arc.cover.post     = [xval',yval'];
        arc.coveropp.post   = [xvalop',yvalop'];

        % Arc
        arc.poly.post   = [newx',newy'];
        arc.polyopp.post = [newxop',newyop'];
        
    case 0 % Circle
        arc.poly.post = CenterRectOnPointd(circle.baseRect, xCenter, yCenter);
        arc.cover.post = CenterRectOnPointd(circle.baseRect2,xCenter, yCenter);
        arc.polyopp.post = [0 0 0 0];
        arc.coveropp.post = [0 0 0 0];
        arc.type2draw.post = 'FillOval';
        
    case 2 % Nothing
        arc.poly.post = [0 0 0 0];
        arc.cover.post = [0 0 0 0];
        arc.polyopp.post = [0 0 0 0];
        arc.coveropp.post = [0 0 0 0];
        arc.type2draw.post = 'FillOval';
end
end

