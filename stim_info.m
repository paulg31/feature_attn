function stim = stim_info(screen,params)

switch params.stim_type
    case 'gabor'

        stim.gabor.display_length        = screen.stim_duration;
        stim.gabor.drift_speed           = screen.gabor_drift;
        stim.gabor.numCycles             = (.8 / screen.stimwidthmultiplier);
        stim.gabor.degPerSec             = 360 * stim.gabor.drift_speed; %lower multiple slower speed
        stim.gabor.degPerFrameGabors     = stim.gabor.degPerSec * screen.ifi;
        stim.gabor.ifi                   = screen.ifi;    %inter-frame interval (1/Hz)
        stim.gabor.center                = 0.5*screen.windowRect(3:4);
        stim.gabor.phaseLine             = 0;
        stim.gabor.backgroundOffset      = [0.5 0.5 0.5 0.0];
        stim.gabor.disableNorm           = 1;
        stim.gabor.preContrastMultiplier = 0.5;
        stim.gabor.sigma                 = (.8 * screen.stimwidthmultiplier) * screen.pxPerDeg; % ~ 1.2 visual degrees converted to pixels
        stim.gabor.freq                  = stim.gabor.numCycles ./ screen.pxPerDeg;
        stim.gabor.aspectRatio           = 1.0;
        stim.gabor.grateAlphaMaskSize    = round(6*stim.gabor.sigma);

        % Build a procedural gabor texture 
        stim.gabor.tex = CreateProceduralGabor(screen.window, stim.gabor.grateAlphaMaskSize, stim.gabor.grateAlphaMaskSize, [],...
            stim.gabor.backgroundOffset, stim.gabor.disableNorm, stim.gabor.preContrastMultiplier);

        % Store 'DrawTexture' info for gabor in matrix
        stim.gabor.propertiesMat = [stim.gabor.phaseLine, stim.gabor.freq, stim.gabor.sigma, NaN, stim.gabor.aspectRatio, 0, 0, 0];

    case 'ellipse'
        % Ellipse parameters
        stim.ellipse.AreaDegSq = 2; % ellipse area in degrees squared??
        stim.ellipse.AreaPx = screen.pxPerDeg^2 * stim.ellipse.AreaDegSq; % ellipse area in number of pixels
        stim.ellipse.Color = 0;
        stim.ellipse.attention_stim_spacing = 5; % ran as 7 in pilot 1 % for multiple stimuli, distance from center (ie radius), in degrees
        stim.ellipse.stim_dist = round(stim.ellipse.attention_stim_spacing * screen.pxPerDeg); % distance from center in pixels
        stim.ellipse.cur_sigma = params.roundness; %linspace(.15,.8,6)
end

end