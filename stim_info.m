function gabor = stim_info(screen)

gabor.display_length        = screen.stim_duration;
gabor.drift_speed           = screen.gabor_drift;
gabor.numCycles             = (2.15 / screen.stimwidthmultiplier);
gabor.degPerSec             = 360 * gabor.drift_speed; %lower multiple slower speed
gabor.degPerFrameGabors     = gabor.degPerSec * screen.ifi;
gabor.ifi                   = screen.ifi;    %inter-frame interval (1/Hz)
gabor.center                = 0.5*screen.windowRect(3:4);
gabor.phaseLine             = 0;
gabor.backgroundOffset      = [0.5 0.5 0.5 0.0];
gabor.disableNorm           = 1;
gabor.preContrastMultiplier = 0.5;
gabor.sigma                 = (0.27 * screen.stimwidthmultiplier) * screen.pxPerDeg; % ~ 1.2 visual degrees converted to pixels
gabor.freq                  = gabor.numCycles ./ screen.pxPerDeg;
gabor.aspectRatio           = 1.0;
gabor.grateAlphaMaskSize    = round(6*gabor.sigma);

% Build a procedural gabor texture 
gabor.tex = CreateProceduralGabor(screen.window, gabor.grateAlphaMaskSize, gabor.grateAlphaMaskSize, [],...
    gabor.backgroundOffset, gabor.disableNorm, gabor.preContrastMultiplier);

% Store 'DrawTexture' info for gabor in matrix
gabor.propertiesMat = [gabor.phaseLine, gabor.freq, gabor.sigma, NaN, gabor.aspectRatio, 0, 0, 0];

end