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
gray = white/2;
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, gray);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 5 5];

radius = 200;
range = pi/12:pi/12:2*pi;
count = 1;
for ii = range
    xpos(count) = radius*cos(ii);
    ypos(count) = radius*sin(ii);
    count = count + 1;
end


% Screen X positions of our three rectangles
squareXpos = [screenXpixels * 0.25 screenXpixels * 0.5 screenXpixels * 0.75];
numSqaures = length(squareXpos);

% Make our rectangle coordinates
for i = 1:numel(xpos)
    allRects(:, i) = CenterRectOnPointd(baseRect, xpos(i)+xCenter, ypos(i)+yCenter);
end

% Draw the rect to the screen
Screen('FillOval', window, white, allRects);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;