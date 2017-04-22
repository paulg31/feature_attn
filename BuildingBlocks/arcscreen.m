% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;
dur = 1;
startx = xCenter/2;
starty = 0;
endx = xCenter+xCenter/2;
endy = xCenter;
arcl = 90;
start = -45;
radius = 340;

% Draw some filled and framed polygons:
polyCenterX=xCenter;
polyCenterY=yCenter;
numPoints=3000;
polyRadius=50;
count = 1;
xval = zeros(1,37);
yval = zeros(1,37);
for angle  = pi/2:pi/72:pi
    xval(count) = cos(angle)*radius +xCenter;
    yval(count) = sin(angle)*radius +yCenter;
    count = count +1;
end
polyPoints2 = [xval',yval'];
sigma = pi/15;
cent = (pi/2 + pi)/2;
newx = zeros(1,37);
newy = zeros(1,37);
count = 1;
for val = pi/2:pi/72:pi
    newy(count) = 10*normpdf(val,cent,sigma)+yval(count);
    newx(count) = xval(count);
    count = count+1;
end

newxval = [xval newx];
newyval = [yval newy];
newpolyPoints = [newxval',newyval'];
% Draw a filled polygon:

Screen('FillPoly', window, [0.5, 0.5, 1], newpolyPoints);
Screen('FillPoly', window, black, polyPoints2);  

% Draw a white dot where the mouse cursor is
Screen('DrawDots', window, [xCenter yCenter], 10, white, [], 2);

% Flip to the screen
vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
KbWait;
    
% Clear the screen
sca;