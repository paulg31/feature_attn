function [arc] = drawarc(screen,design,params)

% Arc Cue Information
radius      = design.radii(3)*screen.pxPerDeg;
arc_sigma   = params.width;
dev_draw    = 3; % how far out to draw arcs

arc_mean    = (randn*arc_sigma + design.trial_mean)*pi/180;
arc_step    = pi/180;
arc_start   = arc_mean - (dev_draw*arc_sigma*pi/180);
arc_end     = arc_mean + (dev_draw*arc_sigma*pi/180);
sigma       = arc_sigma*pi/180;     % sigma in rads for normpdf

% Draw arc cover
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
    dist_height   = 10*normpdf(angle,arc_mean,sigma)+radius;

    % Arc cover points
    xval(count)   = cos(angle)*radius +screen.xCenter;
    yval(count)   = -sin(angle)*radius +screen.yCenter;
    xvalop(count) = -cos(angle)*radius +screen.xCenter;
    yvalop(count) = sin(angle)*radius +screen.yCenter;

    % Arc points
    newy(count)   = -sin(angle)*(dist_height) + screen.yCenter;
    newx(count)   = cos(angle)*(dist_height) + screen.xCenter;
    newyop(count) = sin(angle)*(dist_height) + screen.yCenter;
    newxop(count) = -cos(angle)*(dist_height) + screen.xCenter;
    
    count = count +1;
end

% Circle Cue Information
circle.baseRect = [0 0 450 450 ];
circle.baseRect2 = [0 0 440 440];

% Precue
switch design.pre_cue
    
    case 1 % Arcs
        arc.type2draw.pre = 'FillPoly';  
        % Arc Cover
        arc.cover.pre     = [xval',yval'];
        arc.coveropp.pre   = [xvalop',yvalop'];
        % Arc
        arc.poly.pre   = [newx',newy'];
        arc.polyopp.pre = [newxop',newyop'];
        
    case 0 % circle
        arc.poly.pre = CenterRectOnPointd(circle.baseRect, screen.xCenter, screen.yCenter);
        arc.cover.pre = CenterRectOnPointd(circle.baseRect2,screen.xCenter, screen.yCenter);
        arc.polyopp.pre = [0 0 0 0];
        arc.coveropp.pre = [0 0 0 0];
        arc.type2draw.pre = 'FillOval';
        
    case 2 % nothing
        arc.poly.pre = [0 0 0 0];
        arc.cover.pre = [0 0 0 0];
        arc.polyopp.pre = [0 0 0 0];
        arc.coveropp.pre = [0 0 0 0];
        arc.type2draw.pre = 'FillOval';
end

% Postcue
switch design.post_cue

    case 1 %Arcs
        arc.type2draw.post = 'FillPoly';        
        % Arc Cover
        arc.cover.post     = [xval',yval'];
        arc.coveropp.post   = [xvalop',yvalop'];

        % Arc
        arc.poly.post   = [newx',newy'];
        arc.polyopp.post = [newxop',newyop'];
        
    case 0 % circle
        arc.poly.post = CenterRectOnPointd(circle.baseRect, screen.xCenter, screen.yCenter);
        arc.cover.post = CenterRectOnPointd(circle.baseRect2,screen.xCenter, screen.yCenter);
        arc.polyopp.post = [0 0 0 0];
        arc.coveropp.post = [0 0 0 0];
        arc.type2draw.post = 'FillOval';
        
    case 2 % nothing
        arc.poly.post = [0 0 0 0];
        arc.cover.post = [0 0 0 0];
        arc.polyopp.post = [0 0 0 0];
        arc.coveropp.post = [0 0 0 0];
        arc.type2draw.post = 'FillOval';
end
end

