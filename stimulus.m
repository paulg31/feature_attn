function stimulus(screen,gabor,trial_mean)
contrast = .5;
trial_dev = 5;
stimdevmean = 7.5;
stimdevdev = 2;
step = pi/4;
std = 11.5;
meanfirst = 65;
meansecond = 45;

count = 1;
for val = 0:step:2*pi-step
    jitterx = randn*std + meanfirst;
    jittery = randn*std + meanfirst;
    xval = (jitterx+100)*cos(val);
    yval = (jittery+100)*sin(val);
    xPos(count) = screen.xCenter+xval;
    yPos(count) = screen.yCenter+yval;
    count = count+1;
end

count = 1;
for val = 0:step:2*pi-step
    jitterx = randn*std + meansecond;
    jittery = randn*std + meansecond;
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
baseRect = [0 0 gabor.grateAlphaMaskSize gabor.grateAlphaMaskSize];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

% Make the destination rectangles for all the Gabors in the 2nd array
allRectsout = nan(4, nGaborsout);
for i = 1:nGaborsout
    allRectsout(:, i) = CenterRectOnPointd(baseRect, xPosout(i), yPosout(i));
end

% Gabor orientations 
gabmean  = randn(1)*trial_mean + trial_dev;
gaborAngles = zeros(1,nGabors);
gaborAnglesout = zeros(1,nGaborsout);
for ii = 1:nGabors
    stimdev = randn(1)*stimdevmean + stimdevdev;
    gaborAngles(ii) = gabmean + stimdev
end

for ii = 1:nGaborsout
    stimdev = randn(1)*stimdevmean + stimdevdev;
    gaborAnglesout(ii) = gabmean + stimdev
end

% Contrast
gabor.propertiesMat(4) = contrast;

% Perform initial flip to gray background and sync us to the retrace:
Screen('Flip', screen.window);


% Animation loop
while ~KbCheck
    
    %Screen('BlendFunction', screen.window, 'GL_ONE', 'GL_ZERO');
    
    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', screen.window, gabor.tex, [], allRects, gaborAngles,...
        [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');
    
     % Batch draw all of the Gabors to screen
     Screen('DrawTextures', screen.window, gabor.tex, [], allRectsout, gaborAnglesout,...
         [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');

    % Draw the fixation point
    Screen('DrawDots', screen.window, [screen.xCenter; screen.yCenter], 5, screen.white, [], 2);

    % Flip our drawing to the screen
    Screen('Flip', screen.window, screen.ifi);

end
end