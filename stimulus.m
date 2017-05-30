function stimulus(screen,gabor,design,params)

% Stim params
contrast        = params.contrast;
else_mean     = design.thetamean(1);
gabor_sigma      = design.sigmas(3);
jitter_std      = design.sigmas(2);

% Radii for how far from center to draw gabors
radius_outer    = design.radii(2)*screen.pxPerDeg;
radius_inner    = design.radii(1)*screen.pxPerDeg;

% Set the steps for gabor positions around circle
step            = pi/4;
shift           = pi/8;
span            = 0:step:2*pi-step;
xPosout = zeros(1,numel(span));
yPosout = zeros(1,numel(span));
xPos    = zeros(1,numel(span));
yPos    = zeros(1,numel(span));

% Set the xPosition and yPosition for the Gabros
count = 1;
for val = span
    % Jittered radius of each gabor
    jitterxout = randn*jitter_std + radius_outer;
    jitteryout = randn*jitter_std + radius_outer;
    jitterx = randn*jitter_std + radius_inner;
    jittery = randn*jitter_std + radius_inner;   
    
    % XY values of gabors, outer gabors are shifted
    xvalout = (jitterxout)*cos(val+shift);
    yvalout = (jitteryout)*sin(val+shift);
    xval = (jitterx)*cos(val);
    yval = (jittery)*sin(val);
    
    % Create array of values for 'draw' functions
    xPosout(count) = screen.xCenter+xvalout;
    yPosout(count) = screen.yCenter+yvalout;
    xPos(count) = screen.xCenter+xval;
    yPos(count) = screen.yCenter+yval;
    
    count = count+1;
end

% Count how many Gabors there are
nGabors = numel(xPos);
nGaborsout = numel(xPosout);

% Make the destination rectangles for all the Gabors
baseRect    = [0 0 gabor.grateAlphaMaskSize gabor.grateAlphaMaskSize];
allRects    = nan(4, nGabors);
allRectsout = nan(4, nGaborsout);

for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
    allRectsout(:, i) = CenterRectOnPointd(baseRect, xPosout(i), yPosout(i));
end

% Gabor orientations 
target_mean  = params.trial_mean;
gaborAngles = zeros(1,nGabors);
gaborAnglesout = zeros(1,nGaborsout);
for ii = 1:nGabors
    gaborAngles(ii) = randn*gabor_sigma + target_mean;
    gaborAnglesout(ii) = randn*gabor_sigma + target_mean;
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