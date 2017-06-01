function stimulus(screen,gabor,design,params)

% Stim params
contrast        = params.contrast;
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
jitteredin = zeros(1,nGabors);
jitteredout = zeros(1,nGaborsout);

% Jitter gabors around 0
for ii = 1:nGabors
    jitteredin(ii) = randn*gabor_sigma;
    jitteredout(ii) = randn*gabor_sigma;
end

% Set mean of jittered gabors to 0
mean_fixin = mean(jitteredin);
mean_fixout = mean(jitteredout);
jitteredin = jitteredin - mean_fixin;
jitteredout = jitteredout - mean_fixout;

% Add target_mean so that target_mean = actual mean
gaborAngles = jitteredin + target_mean;
gaborAnglesout = jitteredout + target_mean;

% Check if any angles are negative and flip them around
for ii = 1:numel(gaborAngles)
    if gaborAngles(ii) < 0
        gaborAngles(ii) = 180 + gaborAngles(ii);
    end
    if gaborAnglesout(ii) < 0
        gaborAnglesout(ii) = 180 + gaborAnglesout(ii);
    end
end
% Check
% gaborAngles
% gaborAnglesout
% target_mean

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