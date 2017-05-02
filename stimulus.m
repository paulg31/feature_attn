function stimulus(screen,gabor,trial_mean)
contrast        = .5;
stimdevmean     = 5.5;
stimdevdev      = 2.5;
jitter_std      = 6.5;
radius_outer    = 175;
radius_inner    = 95;
step            = pi/4;
span            = 0:step:2*pi-step;
xPosout = zeros(1,numel(span));
yPosout = zeros(1,numel(span));
xPos    = zeros(1,numel(span));
yPos    = zeros(1,numel(span));

count = 1;
for val = span
    jitterxout = randn*jitter_std + radius_outer;
    jitteryout = randn*jitter_std + radius_outer;
    jitterx = randn*jitter_std + radius_inner;
    jittery = randn*jitter_std + radius_inner;   
    
    xvalout = (jitterxout)*cos(val);
    yvalout = (jitteryout)*sin(val);
    xval = (jitterx)*cos(val);
    yval = (jittery)*sin(val);
    
    xPosout(count) = screen.xCenter+xvalout;
    yPosout(count) = screen.yCenter+yvalout;
    xPos(count) = screen.xCenter+xval;
    yPos(count) = screen.yCenter+yval;
    
    count = count+1;
end

% Count how many Gabors there are
nGabors = numel(xPos);
nGaborsout = numel(xPosout);

% Make the destination rectangles for all the Gabors in the array
baseRect    = [0 0 gabor.grateAlphaMaskSize gabor.grateAlphaMaskSize];
allRects    = nan(4, nGabors);
allRectsout = nan(4, nGaborsout);

for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
    allRectsout(:, i) = CenterRectOnPointd(baseRect, xPosout(i), yPosout(i));
end

% Gabor orientations 
gabmean  = trial_mean;
gaborAngles = zeros(1,nGabors);
gaborAnglesout = zeros(1,nGaborsout);
for ii = 1:nGabors
    stimdev = randn*stimdevdev + stimdevmean;
    stimdev2 = randn*stimdevdev + stimdevmean;
    gaborAngles(ii) = gabmean + stimdev;
    gaborAnglesout(ii) = gabmean + stimdev2;
end

% Contrast
gabor.propertiesMat(4) = contrast;

% Flip
Screen('Flip', screen.window);

% Batch draw all of the Gabors to screen
Screen('DrawTextures', screen.window, gabor.tex, [], allRects, gaborAngles-90,...
    [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');

% Batch draw all of the Gabors to screen
Screen('DrawTextures', screen.window, gabor.tex, [], allRectsout, gaborAnglesout-90,...
    [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');

% Draw the fixation point
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);

% Flip our drawing to the screen
Screen('Flip', screen.window, screen.ifi);
end