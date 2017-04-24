function drawarc( screen,trial_mean )
waitframes = 1;
radius = 200;
% trial_mean = -45;
angle_mean = trial_mean*pi/180;
anglestep = pi/72;
anglestart = angle_mean - pi/4;
angleend = angle_mean+pi/4;

% Draw arc cover
count = 1;
sapns = anglestart:anglestep:angleend;
xval = zeros(1,numel(sapns));
yval = zeros(1,numel(sapns));
for angle  = anglestart:anglestep:angleend
    xval(count) = cos(angle)*radius +screen.xCenter;
    yval(count) = sin(angle)*radius +screen.yCenter;
    count = count +1;
end
polyPoints2 = [xval',yval'];

% Draw pdf for arc
cent = angle_mean;
sigma = cent/3;
if sigma < 0
    sigma = -sigma;
end

newx = zeros(1,numel(sapns));
newy = zeros(1,numel(sapns));
count = 1;
for val = anglestart:anglestep:angleend
    newy(count) = -10*normpdf(val,cent,sigma)+yval(count);
    newx(count) = xval(count);
    count = count+1;
end
newpolyPoints = [newx',newy'];

% Draw pdf then cover
Screen('FillPoly', screen.window, screen.white, newpolyPoints);
Screen('FillPoly', screen.window, screen.bgcolor, polyPoints2);  

% Draw a white dot(fixation)
Screen('DrawDots', screen.window, [screen.xCenter screen.yCenter], 10, screen.white, [], 2);

% Flip to the screen
Screen('Flip', screen.window, (waitframes - 0.5) * screen.ifi);
KbWait;

end

