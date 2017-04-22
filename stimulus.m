function stimulus(screen,gabor)

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
baseRect = [0 0 gabor.grateAlphaMaskSize gabor.grateAlphaMaskSize];
allRects = nan(4, nGabors);
for i = 1:nGabors
    allRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos(i));
end

% Make the destination rectangles for all the Gabors in the array
baseRectout = [0 0 gabor.grateAlphaMaskSize gabor.grateAlphaMaskSize];
allRectsout = nan(4, nGaborsout);
for i = 1:nGaborsout
    allRectsout(:, i) = CenterRectOnPointd(baseRectout, xPosout(i), yPosout(i));
end

% Randomise the Gabor orientations 
gaborAngles = rand(1, nGabors) .* 180 - 90;
gaborAnglesout = rand(1, nGaborsout) .* 180 - 90;

% Perform initial flip to gray background and sync us to the retrace:
Screen('Flip', screen.window);

% Animation loop
while ~KbCheck

    % Batch draw all of the Gabors to screen
    Screen('DrawTextures', screen.window, gabor.tex, [], allRects, gaborAngles - 90,...
        [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');
    
%     % Batch draw all of the Gabors to screen
%     Screen('DrawTextures', screen.window, gabor.tex, [], allRectsout, gaborAnglesout - 90,...
%         [], [], [], [], kPsychDontDoRotation, gabor.propertiesMat');

    % Draw the fixation point
    Screen('DrawDots', screen.window, [screen.xCenter; screen.yCenter], 5, screen.black, [], 2);

    % Flip our drawing to the screen
    Screen('Flip', screen.window, screen.ifi);

end
end