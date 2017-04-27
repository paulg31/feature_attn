function [arc] = drawarc( screen,trial_mean )
radius = 200;
trial_dev = 30;
angle_mean = (rand*trial_dev + trial_mean)*pi/180;
anglestep = pi/72;
anglestart = angle_mean - (30*pi/180);
angleend = angle_mean + (30*pi/180);

while angle_mean < anglestart|| angle_mean > angleend
    angle_mean = (rand*trial_dev + trial_mean)*pi/180;
    anglestep = pi/72;
    anglestart = angle_mean - (30*pi/180);
    angleend = angle_mean + (30*pi/180);
end

% trial_mean*pi/180
% angle_mean
% anglestart
% angleend

% Draw arc cover
count = 1;
sapns = anglestart:anglestep:angleend;
xval = zeros(1,numel(sapns));
yval = zeros(1,numel(sapns));
for angle  = anglestart:anglestep:angleend
    xval(count) = cos(angle)*radius +screen.xCenter;
    yval(count) = -sin(angle)*radius +screen.yCenter;
    xvalop(count) = -cos(angle)*radius +screen.xCenter;
    yvalop(count) = sin(angle)*radius +screen.yCenter;
    count = count +1;
end
arc.polyPoints2 = [xval',yval'];
arc.polyPoints2op = [xvalop',yvalop'];

% Arc stuff
sigma = (angleend-anglestart)/6;
cent = angle_mean;

% Draw Arc
newx = zeros(1,numel(sapns));
newy = zeros(1,numel(sapns));
count = 1;
for val = anglestart:anglestep:angleend
    newy(count) = -sin(val)*(10*normpdf(val,cent,sigma)+radius) + screen.yCenter;
    newx(count) = cos(val)*(10*normpdf(val,cent,sigma)+radius) + screen.xCenter;
    newyop(count) = sin(val)*(10*normpdf(val,cent,sigma)+radius) + screen.yCenter;
    newxop(count) = -cos(val)*(10*normpdf(val,cent,sigma)+radius) + screen.xCenter;
    count = count+1;
end
arc.newpolyPoints = [newx',newy'];
arc.newpolyPointsop = [newxop',newyop'];

end

