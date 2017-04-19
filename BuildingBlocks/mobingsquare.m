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
arcl = 120;
start = -45;
for ii = 1:.1:3
    Screen('DrawArc',window,white,[startx starty+75 endx endy],start,arcl)
    starty = starty - ii;
    endy = endy-ii;
    arcl = arcl - 2*ii;
    start = start + ii;
end
    

% Draw a white dot where the mouse cursor is
Screen('DrawDots', window, [xCenter yCenter], 10, white, [], 2);

% Flip to the screen
vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
KbWait;
    
% Clear the screen
sca;