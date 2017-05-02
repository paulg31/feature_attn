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

vbl = Screen('Flip', window);
waitframes = 1;
dur = 1;
radius = 340;
step = pi/180;
baseRect = [0 0 680 680];
baseRect2 = [0 0 670 670];
circlerect = CenterRectOnPointd(baseRect, xCenter, yCenter);
circlerect2 = CenterRectOnPointd(baseRect2,xCenter, yCenter);
type2draw = 'FillOval';

Screen(type2draw, window, white, circlerect);
Screen(type2draw, window, black, circlerect2);

% Flip to the screen
vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
KbWait;
    
% Clear the screen
sca;