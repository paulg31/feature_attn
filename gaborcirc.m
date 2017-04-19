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

% % Cut out an inner annulus
% innerDist = 0;
% x(dist <= innerDist) = nan;
% y(dist <= innerDist) = nan;
% 
% % Cut out an outer annulus
% outerDist = 5;
% x(dist >= outerDist) = nan;
% y(dist >= outerDist) = nan;
% 
% % Select only the finite values
% x = x(isfinite(x));
% y = y(isfinite(y));
count = 1; step = pi/6; mean = 65; std = 15;
for val = 0:step:2*pi-step
    jitterx = randn*std + mean;
    jittery = randn*std + mean;
    xval = (jitterx+100)*cos(val);
    yval = (jittery+100)*sin(val);
    xPos(count) = xCenter+xval;
    yPos(count) = yCenter+yval;
    count = count+1;
end

count = 1; step = pi/4; mean = 45; std = 15;
for val = 0:step:2*pi-step
    jitterx = randn*std + mean;
    jittery = randn*std + mean;
    xval = (jitterx+50)*cos(val);
    yval = (jittery+50)*sin(val);
    xPosout(count) = xCenter+xval;
    yPosout(count) = yCenter+yval;
    count = count+1;
end
% % Center the annulus coordinates in the centre of the screen
% xPos = x .* gaborDimPix + xCenter;
% yPos = y .* gaborDimPix + yCenter;

% Count how many Gabors there are
nGabors = numel(xPos);
nGaborsout = numel(xPosout);

% Make the destination rectangles for all the Gabors in the array
baseRect = [0 0 gaborDimPix gaborDimPix];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

% Make the destination rectangles for all the Gabors in the array
baseRectout = [0 0 gaborDimPix gaborDimPix];
allRectsout = nan(4, nGaborsout);
for i = 1:nGaborsout
    allRectsout(:, i) = CenterRectOnPointd(baseRect, xPosout(i), yPosout(i));
end

% Randomise the Gabor orientations 
gaborAngles = rand(1, nGabors) .* 180 - 90;
gaborAnglesout = rand(1, nGaborsout) .* 180 - 90;

% Randomise the phase of the Gabors and make a properties matrix. We could
% if we want have each Gabor with different properties in all dimensions.
% Not just orientation and drift rate as we are doing here.
% This is the power of using procedural textures
phaseLine = rand(1, nGabors) .* 360;
phaseLineout = rand(1,nGaborsout).*360;
propertiesMat = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGabors, 1);
propertiesMat(:, 1) = phaseLine';
propertiesMatout = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGaborsout, 1);
propertiesMatout(:,1) = phaseLineout';

% Perform initial flip to gray background and sync us to the retrace:
vbl = Screen('Flip', window);

% Numer of frames to wait before re-drawing
waitframes = 1;

% Animation loop
while ~KbCheck

    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', window, gabortex, [], allRects, gaborAngles - 90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMat');
    
    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', window, gabortex, [], allRectsout, gaborAnglesout - 90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMatout');
    
    

    % Draw the fixation point
    Screen('DrawDots', window, [xCenter; yCenter], 5, black, [], 2);

    % Flip our drawing to the screen
    vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end

% Clean up
sca;
close all;
clear all;