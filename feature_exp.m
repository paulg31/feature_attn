function feature_exp
subjId = 'pjg';
sessionNo = 1;
suffix = 'abc';
familyId = 'abc';

% %Folders
% [thispath,~,~] = fileparts(mfilename('fullpath'));
% filename = [thispath filesep 'designs' filesep 'optdesign_' subjId '.mat'];
[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'results' filesep()];
outputFile          = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) familyId '_data' suffix,'.mat'];
                        
                        
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

% Centers
[screen.xCenter, screen.yCenter] = RectCenter(screen.windowRect);

% pixels per degree                        
screen.pxPerDeg   = screen.windowRect(4) / screen.angle; 

% IFI and Screen Infot
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');
screen = crossinfo(screen);

design.contrasts = [.5 .25];

HideCursor;

showinstructions(0,screen);
WaitSecs(.5);

for iBlock = 1:numel(design.contrasts)
    data.mat{iBlock}    = [];
end

for iBlock = 1:1
    

    data.block_type{iBlock}     = 'trialz';
    data.fields{iBlock}         = {'trial','response','correct','trial_mean','mouse start x','mouse start y'};    

    %Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(3,6); %trial num, item to save nume
    end

    for trial = 1:3
        trial_mean = rand(1)*180
        [point_totes,mouse_start,responseAngle] = runtrial(screen,trial_mean);
   
        data.mat{iBlock}(trial,:) = [ ...
            trial, responseAngle, point_totes,trial_mean,mouse_start(1), mouse_start(2) ...
        ];
        
        % Save data at the end of each trial
        save(outputFile, 'data');
    end
    
    % Save data at the end of the block
    save(outputFile, 'data'); 
    
    % Write Text
    text = 'Experiment completed!\n\n\n\nPlease find the experimenter';

    % Draw all the text
    Screen('TextSize', screen.window, screen.text_size);
    DrawFormattedText(screen.window, text, 'center', screen.Ypixels * 0.4, screen.white);
    Screen('Flip', screen.window);

    % Enable only SPACE to continue
    RestrictKeysForKbCheck(32);
    KbWait([],2);
    RestrictKeysForKbCheck([]);

    %Return Cursor
    ShowCursor;

    % Clear screen
    sca;

end
end