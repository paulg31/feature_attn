function stimulus(screen)
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
numCycles = 3;
freq = numCycles / gaborDimPix;

% Build a procedural gabor texture
gabortex = CreateProceduralGabor(screen.window, gaborDimPix, gaborDimPix,...
    [], [0.5 0.5 0.5 0.0], 1, 0.5);


count = 1; step = pi/6; mean = 65; std = 15;
for val = 0:step:2*pi-step
    jitterx = randn*std + mean;
    jittery = randn*std + mean;
    xval = (jitterx+100)*cos(val);
    yval = (jittery+100)*sin(val);
    xPos(count) = screen.xCenter+xval;
    yPos(count) = screen.yCenter+yval;
    count = count+1;
end

count = 1; step = pi/4; mean = 45; std = 15;
for val = 0:step:2*pi-step
    jitterx = randn*std + mean;
    jittery = randn*std + mean;
    xval = (jitterx+50)*cos(val);
    yval = (jittery+50)*sin(val);
    xPosout(count) = screen.xCenter+xval;
    yPosout(count) = screen.yCenter+yval;
    count = count+1;
end
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

% Randomise the phase of the Gabors and make a properties matrix.
phaseLine = rand(1, nGabors) .* 360;
phaseLineout = rand(1,nGaborsout).*360;
propertiesMat = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGabors, 1);
propertiesMat(:, 1) = phaseLine';
propertiesMatout = repmat([NaN, freq, sigma, contrast, aspectRatio, 0, 0, 0],...
    nGaborsout, 1);
propertiesMatout(:,1) = phaseLineout';

% Perform initial flip to gray background and sync us to the retrace:
Screen('Flip', screen.window);

% Animation loop
while ~KbCheck

    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', screen.window, gabortex, [], allRects, gaborAngles - 90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMat');
    
    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', screen.window, gabortex, [], allRectsout, gaborAnglesout - 90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMatout');

    % Draw the fixation point
    Screen('DrawDots', screen.window, [screen.xCenter; screen.yCenter], 5, screen.black, [], 2);

    % Flip our drawing to the screen
    Screen('Flip', screen.window, screen.ifi);

end
end