clearvars;
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2);
screenNumber = max(Screen('Screens'));
%Screen and display info   
screen.width         = 19.7042; %iPad screen width in cm
screen.distance      = 32; % Screen distance in cm
screen.angle         = 2*(180/pi)*(atan((screen.width/2) / screen.distance)) ; % total visual angle of screen in degrees
screen.text_size     = 36;
screen.white         = WhiteIndex(screenNumber);
screen.black         = BlackIndex(screenNumber);
screen.bgcolor       = screen.white / 2;
screen.darkgray      = 10/255;
screen.fixationdur   = 0.5;
screen.ISI           = 0.5;  % Inter-stimulus-interval
screen.betweentrials = 0.3;
screen.feedback_time = 1.1;
screen.sound_volume  = 2;
screen.jitter        = 0.1;  % 10% random jitter of durations
screen.gabor_drift   = 0;    % Gabor drift speed (0=static)
screen.stim_duration = .1; % Stimulus presentation time       

% Correction to stimulus width/period since previously reported dva were off
screen.stimwidthmultiplier = 1.5352;

% Open the screen
[screen.window, screen.windowRect] = PsychImaging('OpenWindow', screenNumber, screen.bgcolor,...
                            [], 32, 2,[], [],  kPsychNeed32BPCFloat);
                        
% Get the size of the on screen window in pixels
[~, screen.Ypixels] = Screen('WindowSize', screen.window);
trial_mean = 45;

% Centers
[screen.xCenter, screen.yCenter] = RectCenter(screen.windowRect);

% pixels per degree                        
screen.pxPerDeg     = screen.windowRect(4) / screen.angle; 

% IFI and Screen Info
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Set Mouse
xstart = rand(1)*screen.windowRect(3);
ystart = rand(1)*screen.windowRect(4);
SetMouse(xstart,ystart,screen.window);

secs0 = GetSecs;
while ~KbCheck
    % Get the current position of the mouse
    [mx, ~, ~] = GetMouse(screen.window);
    if mx < 2
        SetMouse(1598,screen.yCenter,screen.window);
    elseif mx > 1598
        SetMouse(2,screen.yCenter,screen.window);
    end
    Xdiff = screen.xCenter-mx;
    L = screen.xCenter/2;
    theta = mod(Xdiff/L,1)*pi;
    actual = pi - theta;

    Screen('DrawTexture', screen.window, recttexture, [], [], theta*180/pi);
    Screen('Flip', screen.window,screen.ifi);
end

sca;