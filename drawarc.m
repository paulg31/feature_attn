function [arc] = drawarc(screen,trial_mean)

radius      = 200;
arc_sigma   = 2.5;
dev_draw    = 3;
arc_mean    = (randn*arc_sigma + trial_mean)*pi/180;
arc_step    = pi/180;
arc_start   = arc_mean - (dev_draw*arc_sigma*pi/180);
arc_end     = arc_mean + (dev_draw*arc_sigma*pi/180);
sigma       = arc_sigma*pi/180;     %sigma in rads

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
% Arc Cover
arc.polyPoints2     = [xval',yval'];
arc.polyPoints2op   = [xvalop',yvalop'];

% Arc
arc.newpolyPoints   = [newx',newy'];
arc.newpolyPointsop = [newxop',newyop'];
end

