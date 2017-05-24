function feature_exp(subjId,sessionNo,reload)

if nargin < 1 || isempty(subjId) || ~ischar(subjId) || numel(subjId) ~= 3
    error('First argument is subject''s 3-letter identifier.');
end
subjId = upper(subjId); % Subject identifier is all uppercase

if nargin < 2 || isempty(sessionNo)
    error('Second argument is session number.');
end

if nargin < 3 || isempty(reload)
    reload = 0; 
end

% Exp Design
design.types        = [1 2 3 4 5];
design.contrasts    = [.1 .5 1];        % (low, high, train)
design.width        = [2.5 5 3];        % distribution width types, narrow, wide, train
design.trial_nums   = [1 1 1 1 1];      % trials per block at each index
design.radii        = [4 6 8];          % [in out arc] radii in visual angle
design.sigmas       = [NaN 6.5 2.5];    % [arc sigma. gabor position sigma. gabor orientation sigma]
design.thetamean    = 5.5;              % mean of noise for orientation of target mean
target_cue          = 1;                % arc
null_cue            = 0;                % 0 for circle, 2 for nothing
num_reps            = 2;

% Folders
[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'results' filesep()];
outputFile          = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) '_data.mat'];            
                        
% Create results folder if it does not exist already
if ~exist([currentPath filesep() 'results'],'dir')
    mkdir(currentPath,'results');
end

% Check if Outputfile already exists
if exist(outputFile,'file')
    if ~reload
        error(['File ''' outputFile ''' already exists in Results directory.']);
    end
    fprintf('Recovering from interrupted session.\n');
    
    % Recover from interrupted session
    load(outputFile);
    if isinf(trial)           % Crashed at the end of the block, start from next block
        design.types = design.types; 
        trialStart = 1;
        blockStart = iBlock + 1;
    else
        design.types = design.types; 
        trialStart = trial+1; % Start from the following trial
        blockStart = iBlock; 
    end
    
else
    % Start from scratch
    trialStart = 1;
    blockStart = 1;
    
    % Block Order
    perm_order = design.types(2:numel(design.types));
    design.types = [1];
    stop = 0;
    while stop == 0
        for n = 1:num_reps
            perm = perm_order(randperm(numel(perm_order)));
            design.types = [design.types perm];
        end

        if design.types(5) == design.types(6)
            stop = 0;
            design.types = [1];
        else
            stop = 1;
        end
    end
    
    % Empty data mats for each block and organize trials
    for iBlock = 1:numel(design.types)
            data.mat{iBlock} = [];
            design.mat{iBlock}  = [];
            design.numtrials(iBlock) = design.trial_nums(design.types(iBlock));
    end   
end

% PTB Setup
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 2);
screenNumber = max(Screen('Screens'));

% Screen and display info   
screen.width         = 19.7042; % iPad screen width in cm
screen.distance      = 32;      % Screen distance in cm
screen.angle         = 2*(180/pi)*(atan((screen.width/2) / screen.distance)) ; % total visual angle of screen in degrees
screen.text_size     = 36;
screen.white         = WhiteIndex(screenNumber);
screen.black         = BlackIndex(screenNumber);
screen.bgcolor       = screen.white / 2;
screen.darkgray      = 10/255;
screen.fixationdur   = 0.5;
screen.ISI           = 0.5;     % Inter-stimulus-interval
screen.betweentrials = 0.3;
screen.feedback_time = 1.1;
screen.sound_volume  = 2;
screen.jitter        = 0.1;     % 10% random jitter of durations
screen.gabor_drift   = 0;       % Gabor drift speed (0=static)
screen.stim_duration = .5;      % Stimulus presentation time     
screen.circle_size   = design.radii(3);   % Size of circle cue(should be same as arc radius*2)
screen.circle_thickness   = .2;  % Thickness of circle cue in degrees(can be changed)

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

% Begin Block
for iBlock = blockStart:numel(design.types)
    
    data.fields{iBlock}         = {'trial','response','correct','trial mean','pre cue', 'post cue'};
    design.fields{iBlock}       = {'trial', 'mouse start x','mouse start y', ' width', 'contrast'}; 
    
    % Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(design.numtrials(iBlock),numel(data.fields{iBlock})) ; %trial num, item to save nume
    end
    
    % Block Type
    switch design.types(iBlock)
        case 1 % Train
            params.width = design.width(3);
            params.contrast = design.contrasts(3);
            data.block_type{iBlock}     = 'T';

        case 2% Low-Narrow
            params.width = design.width(1);
            params.contrast = design.contrasts(1);
            data.block_type{iBlock}     = 'LN';

        case 3% Low-Wide
            params.width = design.width(2);
            params.contrast = design.contrasts(1);
            data.block_type{iBlock}     = 'LW';

        case 4% High-Narrow
            params.width = design.width(1);
            params.contrast = design.contrasts(2);
            data.block_type{iBlock}     = 'HN';

        case 5% High-Wide
            params.width = design.width(2);
            params.contrast = design.contrasts(2);
            data.block_type{iBlock}     = 'HW';

    end
    
    % Trials
    for trial = trialStart:design.numtrials(iBlock)
        params.trial_mean = rand(1)*180;

             % Cue appearances
             x = rand;
             if x <.4 %arc arc
                params.pre_cue = target_cue;
                params.post_cue = target_cue;

             elseif x <.8 && x >= .4 %none arc
                params.pre_cue = null_cue; 
                params.post_cue = target_cue;
                
             else %none none
                params.pre_cue = null_cue;
                params.post_cue = null_cue;
             end

        % Pass info to runtrial
        [point_totes,mouse_start,responseAngle] = runtrial(screen,design,iBlock,params);

        % save into mat
        data.mat{iBlock}(trial,:) = [ ...
            trial, responseAngle, point_totes,params.trial_mean, params.pre_cue, params.post_cue   ...
        ];
        
        design.mat{iBlock}(trial,:) = [...
            trial, mouse_start(1), mouse_start(2), params.width, params.contrast ...
        ];

        % Save data at the end of each trial
        save(outputFile, 'data', 'design','trial','iBlock');

    end
    
    % Save data at the end of the block
    save(outputFile, 'data', 'design','trial','iBlock'); 
    
    % Show block feedback
    total = sum(data.mat{iBlock}(:,3),1);                   % Total score
    completion = sum(design.numtrials(1:iBlock))/sum(design.numtrials);   % Completed
    displayscore(total,completion,screen);
    trialStart = 1;    
    trial = Inf;    % Reached end of the block
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