% Clear the workspace
close all;
clearvars;
sca;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2);
% Seed the random number generator. Here we use the an older way to be
% compatible with older systems. Newer syntax would be rng('shuffle'). Look
% at the help function of rand "help rand" for more information
rand('seed', sum(100 * clock));

% Screen Number
screenNumber = max(Screen('Screens'));

% Define black, white and grey
white = WhiteIndex(screenNumber);
grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, [], 32, 2,...
    [], [],  kPsychNeed32BPCFloat);

% Flip to clear
Screen('Flip', window);
windowRect;
% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Maximum priority level
topPriorityLevel = MaxPriority(window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

%--------------------
% Gabor information
%--------------------

% Dimensions
gaborDimPix = 55;

% Sigma of Gaussian
sigma = gaborDimPix / 6;

% Obvious Parameters
orientation = 90;
contrast = 0.5;
aspectRatio = 1.0;

% Spatial Frequency (Cycles Per Pixel)
% One Cycle = Grey-Black-Grey-White-Grey i.e. One Black and One White Lobe
numCycles = 3;
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture
gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix,...
    [], [0.5 0.5 0.5 0.0], 1, 0.5);

% Positions of the Gabors
dim = 8;
[x, y] = meshgrid(-dim:dim, -dim:dim);

% Calculate the distance in "Gabor numbers" of each gabor from the center
% of the array
dist = sqrt(x.^2 + y.^2);

% Cut out an inner annulus
innerDist = 2;
x(dist <= innerDist) = nan;
y(dist <= innerDist) = nan;

% Cut out an outer annulus
outerDist = 5;
x(dist >= outerDist) = nan;
y(dist >= outerDist) = nan;

% Select only the finite values
x = x(isfinite(x));
y = y(isfinite(y));

% Center the annulus coordinates in the centre of the screen
xPos = x .* gaborDimPix + xCenter;
yPos = y .* gaborDimPix + yCenter;

% Count how many Gabors there are
nGabors = numel(xPos);

% Make the destination rectangles for all the Gabors in the array
baseRect = [0 0 gaborDimPix gaborDimPix];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

% Randomise the Gabor orientations and determine the drift speeds of each gabor.
% This is given by multiplying the global motion speed by the cosine
% difference between the global motion direction and the global motion.
% Here the global motion direction is 0. So it is just the cosine of the
% angle we use. We re-orientate the array when drawing
gaborAngles = rand(1, nGabors) .* 180 - 90;

% Randomise the phase of the Gabors and make a properties matrix. We could
% if we want have each Gabor with different properties in all dimensions.
% Not just orientation and drift rate as we are doing here.
% This is the power of using procedural textures
phaseLine = rand(1, nGabors) .* 360;
propertiesMat = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGabors, 1);
propertiesMat(:, 1) = phaseLine';

% Perform initial flip to gray background and sync us to the retrace:
vbl = Screen('Flip', window);

% Numer of frames to wait before re-drawing
waitframes = 1;

% Animation loop
while ~KbCheck

    % Set the right blend function for drawing the gabors
    Screen('BlendFunction', window, 'GL_ONE', 'GL_ZERO');

    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', window, gabortex, [], allRects, gaborAngles - 90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMat');

    % Change the blend function to draw an antialiased fixation point
    % in the centre of the array
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    % Draw the fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 10, black, [], 2);


    % Flip our drawing to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

% Clean up
sca;
close all;
clear all;