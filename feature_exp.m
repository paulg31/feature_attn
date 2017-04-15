function feature_exp
screenNumber = max(Screen('Screens'));
%Screen and display info
screen.width         = 19.7042; %iPad screen width in cm
% screen.distance      = 50; % Screen distance in cm (incorrect, fixed)
screen.distance      = 32; % Screen distance in cm
screen.angle         = 2*(180/pi)*(atan((screen.width/2) / screen.distance)) ; % total visual angle of screen in degrees
screen.text_size     = 36;
screen.white         = WhiteIndex(screenNumber);
screen.bgcolor       = screen.white / 2;
screen.darkgray      = 10/255;
screen.fixationdur   = 0.5;
screen.ISI           = 0.5;  % Inter-stimulus-interval
screen.betweentrials = 0.3;
screen.feedback_time = 1.1;
screen.sound_volume  = 2;
screen.jitter        = 0.1;  % 10% random jitter of durations
% screen.gabor_drift   = 6;    % Gabor drift speed
screen.gabor_drift   = 0;    % Gabor drift speed (static)
screen.stim_duration = .1; % Stimulus presentation time

% Correction to stimulus width/period since previously reported dva were off
screen.stimwidthmultiplier = 1.5352;
% Open the screen
[screen.window, screen.windowRect] = PsychImaging('OpenWindow', screenNumber, screen.bgcolor,...
                            [], 32, 2,[], [],  kPsychNeed32BPCFloat);
% Get the size of the on screen window in pixels
[~, screen.Ypixels] = Screen('WindowSize', screen.window);

% Centers
[screen.xCenter, screen.yCenter] = RectCenter(screen.windowRect);

% IFI and Screen Info
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');
showinstructions(0,screen);
sca;
end