% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white/2;
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 100 300];

% Define red
red = [1 0 0];

texturerect = ones(10,300).*white;
recttexture = Screen('MakeTexture',window,texturerect);

% Sync us and get a time stampZ
%vbl = Screen('Flip', window);
waitframes = 1;
 
% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
currentAngle = 0;
degPerFrame = 1;
% Here we set the initial position of the mouse to be in the centre of the
% screen
SetMouse(xCenter, yCenter/2, window);

while ~KbCheck

    % Get the current position of the mouse
    [mx, my, buttons] = GetMouse(window);
    currentX = mx-xCenter;
    currentY = my-yCenter;
    shift = atan(currentY/currentX);
    degrees = 180/pi*shift;
    currentAngle = degrees;
    Screen('DrawTexture', window, recttexture, [], [], currentAngle);
    Screen('Flip', window);
end

sca;
clearvars;