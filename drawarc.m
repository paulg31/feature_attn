function [arc] = drawarc( screen,trial_mean )
radius = 200;
angle_mean = trial_mean*pi/180;
anglestep = pi/72;
anglestart = angle_mean - pi/4;
angleend = angle_mean + pi/4;

% Draw arc cover
count = 1;
sapns = anglestart:anglestep:angleend;
xval = zeros(1,numel(sapns));
yval = zeros(1,numel(sapns));
for angle  = anglestart:anglestep:angleend
    xval(count) = cos(angle)*radius +screen.xCenter;
    yval(count) = -sin(angle)*radius +screen.yCenter;
    count = count +1;
end
arc.polyPoints2 = [xval',yval'];

% Draw pdf for arc
cent = angle_mean;
% if trial_mean < 0
%     sigma = -cent/3;
% else
%     sigma = cent/3;
% end
sigma = cent/8;

% Draw Arc
newx = zeros(1,numel(sapns));
newy = zeros(1,numel(sapns));
count = 1;
for val = anglestart:anglestep:angleend
    newy(count) = -sin(val)*(10*normpdf(val,cent,sigma)+radius) + screen.yCenter;
    newx(count) = cos(val)*(10*normpdf(val,cent,sigma)+radius) + screen.xCenter;
    count = count+1;
end
arc.newpolyPoints = [newx',newy'];

end

