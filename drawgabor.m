function drawgabor(screen,stim,params,ring)

if params.instruct == 1 || params.instruct == 2
    
    switch params.instruct
        case 1
            params.trial_mean = params.instruct_mean;
        case 2
            params.trial_mean = params.add;
    end
    
    params.contrast = .23;
end

propertiesMat    = stim.gabor.propertiesMat;
propertiesMat(4) = params.contrast;    % Current Gabor contrast

w = stim.gabor.grateAlphaMaskSize;

if params.instruct == 2
    destRect = [stim.gabor.center stim.gabor.center] +[-w/2 -w/2 w/2 w/2];
    destRect = destRect + [0 190 0 190];
else
    destRect = [stim.gabor.center stim.gabor.center] +[-w/2 -w/2 w/2 w/2];
end


Screen('BlendFunction',screen.window,GL_ONE,GL_ZERO,[]);
% Check texture
Screen('DrawTexture', screen.window, stim.gabor.tex, [], destRect, params.trial_mean-90,...
    [], [], [], [], kPsychDontDoRotation, propertiesMat');

if params.instruct ~= 1 && params.instruct ~=2
    progress_bar( screen, design,trial,iBlock )
    Screen('FillOval', screen.window, ring.color, ring.allRects);
    screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
end

end