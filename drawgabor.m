function drawgabor(screen,stim,params)
%draws the stimulus for a period of time from info in gaborinfo

propertiesMat    = stim.gabor.propertiesMat;
propertiesMat(4) = params.contrast;    % Current Gabor contrast
phaseLine        = stim.gabor.phaseLine;
startTime        = GetSecs;
lastTime         = 0;
frame            = 0;

w = stim.gabor.grateAlphaMaskSize;
destRect = [stim.gabor.center stim.gabor.center] +[-w/2 -w/2 w/2 w/2];

% while (lastTime - startTime) < gabor.display_length
%     frame = frame+1;
%     
%     % Increment the phase of Gabors
%     phaseLine = phaseLine + gabor.degPerFrameGabors;
%     propertiesMat(:,1) = phaseLine';
   
    % Check texture
    Screen('DrawTexture', screen.window, stim.gabor.tex, [], destRect, params.trial_mean-90,...
        [], [], [], [], kPsychDontDoRotation, propertiesMat');
    
%     lastTime = Screen('Flip',screen.window, startTime + frame*gabor.ifi);
% 
% end
    
% Flip our drawing to the screen
Screen('Flip', screen.window, screen.ifi);
end
