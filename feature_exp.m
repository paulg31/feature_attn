function feature_exp
%Inputs for function: to be changed
subjId = 'pjg';
sessionNo = 1;
suffix = 'abc';
familyId = 'abc';

% Exp Design
design.types        = [1 2 3 4 5];
design.contrasts    = [.1 .5 1];  % (low, high, train)
design.width        = [2.5 5 3];    % distribution width types, narrow, wide, train
design.numtrials    = [3 3 3 3 3];    % trials per block at each index
design.radii        = [4 6 8];  % [in out arc] radii in visual angle
design.sigmas       = [NaN 6.5 2.5]; % [arc sigma. gabor position sigma. gabor orientation sigma]
design.thetamean    = [5.5];    % mean of noise for orientation arount target mean
 

% Folders
[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'results' filesep()];
outputFile          = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) familyId '_data' suffix,'.mat'];            
                        
%Create results folder if it does not exist already
if ~exist([currentPath filesep() 'results'],'dir')
    mkdir(currentPath,'results');
end
               
% PTB Setup
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
screen.stim_duration = .5; % Stimulus presentation time       

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

% IFI and Screen Info
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');
screen = crossinfo(screen);

% Begin
HideCursor;
showinstructions(0,screen);
WaitSecs(.5);

% Empty data mats for each block
for iBlock = 1:numel(design.types)
        data.mat{iBlock} = [];
end

% Begin Block
for iBlock = 1:numel(design.types)
            
    data.block_type{iBlock}     = 'trialz';
    data.fields{iBlock}         = {'trial','response','correct','trial mean','mouse start x','mouse start y','cues'};    

    % Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(design.numtrials(iBlock),numel(data.fields{iBlock})) ; %trial num, item to save nume
    end
    
    % Block Type
    switch design.types(iBlock)%% probabily will start from 1:?? but cb so that 2:?? is not train
        case 1 % Train
            params.width = design.width(3);
            params.contrast = design.contrasts(3);
            feedback_type = 1 ;
        case 2% Low-Narrow
            params.width = design.width(1);
            params.contrast = design.contrasts(1);
            feedback_type = 0 ;
        case 3% Low-Wide
            params.width = design.width(2);
            params.contrast = design.contrasts(1);
            feedback_type = 0 ;
        case 4% High-Narrow
            params.width = design.width(1);
            params.contrast = design.contrasts(2);
            feedback_type = 0 ;
        case 5% High-Wide
            params.width = design.width(2);
            params.contrast = design.contrasts(2);
            feedback_type = 0 ;
    end
    
        % Trials
            for trial = 1:design.numtrials(iBlock)
                design.trial_mean = rand(1)*180;
                design.type_draw = 1;
                
                     % Cue appearances
                     x = rand;
                     if x <.4
                        design.pre_cue = 1;
                        design.post_cue = 1;
                        cues = 3;
                        
                     elseif x <.8 && x >= .4
                        design.pre_cue = 0; 
                        design.post_cue = 1;
                        cues = 2;
                     else
                        design.pre_cue = 0;
                        design.post_cue = 0;
                        cues = 1;
                     end

                % Pass info to runtrial
                [point_totes,mouse_start,responseAngle] = runtrial(screen,design,iBlock,params);
                
%                 total = point_totes;
%                 completion = 0;
%                 displayscore(total, completion ,screen, feedback_type)

                % points to save
                data.mat{iBlock}(trial,:) = [ ...
                    trial, responseAngle, point_totes,design.trial_mean,mouse_start(1), mouse_start(2), cues ...
                ];

                % Save data at the end of each trial
                save(outputFile, 'data');
                
            end
    
    % Save data at the end of the block
    save(outputFile, 'data'); 
    
    % Show block feedback
    total = sum(data.mat{iBlock}(:,3),1);                   % Total score
    completion = sum(design.numtrials(1:iBlock))/sum(design.numtrials);   % Completed
    displayscore(total,completion,screen);
end 
    
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