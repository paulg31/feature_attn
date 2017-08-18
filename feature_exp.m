function feature_exp(subjId,sessionNo,reload,control,debug)

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

if nargin < 4 || isempty(control)
    control = 0;
end

if nargin < 5 || isempty(debug)
    debug = 0;
end

% Exp Design
design.types        = [1 2 5 5];                    % Blocks
design.contrasts    = [.004 .008 .017 .033 .067 .135];  % Used  only for Gabor stimulus
design.roundness    = [15 15];                           % Larger value, more circular
design.width        = [10 10];                         % distribution width types, narrow, wide
design.arc_dist     = 5;                % arc distance from center in dva
design.thetamean    = 5.5;              % mean of noise for orientation of target mean
design.med2sd       = 1.48;             % conversion for median to sd
design.mean_mult    = 1.25;
design.wide_ratio   = sqrt(3);          % multiplier for wide cue
design.cue_ratio    = .25;              % ratio for both the pre+post and post conditions
design.target_lowerbound = .75;
design.target_upperbound = 1.25;
design.target_SDerror = 10;
design.adapt_type = 1;
design.pointsigma_mult = .7;
target_cue          = 2;                % arc
null_cue            = 0;                % 0 for circle, 2 for nothing

switch debug
    case 0
        design.s1_trials    = [100 152 152 152 152 152];      % Trials for the first session [180 152 152 152 152]
        design.other_trials = [180 180 180 180];        % Trials for the rest of the sessions [180 180 180 180]
        params.highstep_trials = 100;
        params.start_check = 100;
        params.mod_val = 10;
        params.move_wind_size = 50;
        start_width = 29;
    case 1
        design.s1_trials    = [10 10 4 4 4 4];      % Trials for the first session [180 152 152 152 152]
        design.other_trials = [8 8 8 8];        % Trials for the rest of the sessions [180 180 180 180]
        params.highstep_trials = 10;
        params.start_check = 10;
        params.mod_val = 5;
        params.move_wind_size = 10;
        start_width = 1;
end


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

    % Shuffle test blocks
    [design] = shuffle_blocks( design, sessionNo, resultsFolder, subjId);
    
    % Empty structs if loaded prev session
    if sessionNo ~= 1
        design.mat = [];
        design.numtrials = [];
        design.fields = [];
        data.mat = [];
        data.fields = [];
        data.block_type = [];
    end
    
    % Empty data mats for each block and organize trials
    for iBlock = 1:numel(design.types)
            data.mat{iBlock} = [];
            design.mat{iBlock}  = [];
            design.numtrials(iBlock) = design.trial_nums(iBlock);
            design.cue_order{iBlock} = counterbalance(design,iBlock);
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
screen.lesswhite     = screen.white / .1;
screen.darkgray      = 10/255;
screen.sound_volume  = 2;
screen.jitter        = 0.1;     % 10% random jitter of durations
screen.gabor_drift   = 0;       % Gabor drift speed (0=static)     
screen.circle_size   = 2*design.arc_dist;   % Size of circle cue(should be same as arc radius*2)
screen.circle_thickness   = .2;  % Thickness of circle cue in degrees(can be changed)
screen.bar_width     = 4; 
screen.bar_height    = 180; % was 250 when cue distance was 7

% Timings
screen.stim_duration = 0.05;    % Stimulus presentation time
screen.cue_duration  = 0.3;     % Cue duration 
screen.fixationdur   = 0.5;     % fixation duration
screen.ISI           = 0.5;     % Inter-stimulus-interval
screen.betweentrials = 0.3;     % Time between trials
screen.feedback_time = 0.8;     % Feedback Presentation Time
screen.stim_pre      = 0.15;    % Time between pre cue and stim
screen.stim_post     = 0.3;     % Time between stim and post cue

% Correction to stimulus width/period since previously reported dva were off
screen.stimwidthmultiplier = 1.5352;

% Open the screen
[screen.window, screen.windowRect] = PsychImaging('OpenWindow', screenNumber, screen.bgcolor,...
                            [], 32, 2,[], [],  kPsychNeed32BPCFloat);
% Get the size of the on screen window in pixels
[screen.Xpixels, screen.Ypixels] = Screen('WindowSize', screen.window);

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
showinstructions(0,screen,1);
WaitSecs(.5); % Why is this here?
exp_start = GetSecs;
ring = grid_info(screen, design, control);

% Begin Block
for iBlock = blockStart:numel(design.types)
    
    block_start = GetSecs;
    showinstructions(1, screen, iBlock)
 
    data.fields{iBlock}         = {'trial','response','ellipse orientation','points','error','cue center','cue ID','resp_time'};
    design.fields{iBlock}       = {'trial','mouse start x','mouse start y',' width','roundness','trial duration'}; 
    
    % Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(design.numtrials(iBlock),numel(data.fields{iBlock})) ; %trial num, item to save nume
    end
    
    % Block Type
    switch design.types(iBlock)
        case 1 % Train
            params.width = design.width(1);
            params.index = 1;
            data.block_type{iBlock}     = 'A';
            
        case 2 % Adapt Contrast
            params.width = design.width(1);
            params.index = 1;
            data.block_type{iBlock}     = 'T';

        case 3% High-Narrow
            params.width = design.width(1);
            params.index = 2;
            data.block_type{iBlock}     = 'HN';

        case 4% High-Wide
            params.width = design.width(2);
            params.index = 2;
            data.block_type{iBlock}     = 'HW';

        case 5% Low-Narrow
            params.width = design.width(1);
            params.index = 1;
            data.block_type{iBlock}     = 'LN';

        case 6% Low-Wide
            params.width = design.width(2);
            params.index = 1;
            data.block_type{iBlock}     = 'LW';

    end
    
    % Adaptive block, no cues, keeps going
    if data.block_type{iBlock} == 'A';
        params.stim_type = 'ellipse';
        params.cue_type = 0;
        params.pre_cue = null_cue;
        params.post_cue = null_cue;
        params.iblock = iBlock;
        
        switch design.adapt_type
            case 1
                [data, design, trial] = adapt_byz(screen, params, data, design, ring, outputFile);
            case 2
                [data, design, trial] = adapt_ott(screen, params, data, design, ring, trialStart, outputFile);
        end
        
    else
    % Trials
    for trial = trialStart:design.numtrials(iBlock)
        trial_start = GetSecs;
        params.stim_type   = 'ellipse';
        params.trial_mean = rand(1)*180; % Random Orientation
        
        if data.block_type{iBlock} == 'T'
            params.pre_cue = null_cue;
            params.post_cue = null_cue;
        else
        
             % Cue appearances
             if design.cue_order{iBlock}(trial) == 2 % arc arc
                params.pre_cue = target_cue;
                params.post_cue = target_cue;

             elseif design.cue_order{iBlock}(trial) == 1 % none arc
                params.pre_cue = null_cue; 
                params.post_cue = target_cue;
                
             elseif design.cue_order{iBlock}(trial) == 0 % none none
                params.pre_cue = null_cue;
                params.post_cue = null_cue;
                
             elseif design.cue_order{iBlock}(trial) == 3 % arc none
                params.pre_cue = target_cue;
                params.post_cue = null_cue;
                 
             end
        end

        % Determine what to save
        switch params.stim_type
            case 'ellipse'
                type_save = design.roundness(params.index);
            case 'gabor'
                type_save = design.contrast(params.index);
        end
        
        % Pass info to runtrial
        [point_totes,mouse_start,responseAngle,resp_error,arc_mean,resp_time ] = runtrial(screen,design,params, ring, iBlock,data);
        
        trial_end = GetSecs;
        trial_dur = trial_end-trial_start;

        % save into mat
        data.mat{iBlock}(trial,:) = [ ...
            trial, responseAngle, params.trial_mean, point_totes, resp_error,arc_mean*180/pi, design.cue_order{iBlock}(trial), resp_time   ...
        ];
        
        design.mat{iBlock}(trial,:) = [...
            trial, mouse_start(1), mouse_start(2), params.width, type_save,trial_dur ...
        ];
        
        % Save data at the end of each trial
        save(outputFile, 'data', 'design','trial','iBlock');

     end
    end
    
    % End of block things
    block_end = GetSecs;
    exp_end = GetSecs;
    design.block_dur{iBlock} = block_end-block_start;
    design.exp_dur = exp_end-exp_start;
    
    % If end of train block, set cue widths
    if data.block_type{iBlock} == 'T';
        design.width(1) = design.med2sd*median(abs(data.mat{2}([start_width:end],5)));
        design.width(2) = design.wide_ratio*design.width(1);
    end
    
    % Save data at the end of the block
    save(outputFile, 'data', 'design','trial','iBlock'); 
    
    % Show block feedback
    total = sum(data.mat{iBlock}(:,4),1);                   % Total score
    completion = sum(design.numtrials(1:iBlock))/sum(design.numtrials);   % Completed
    displayscore(total,completion,screen,ring);
    trialStart = 1;    
    trial = Inf;    % Reached end of the block
end 

    % Draw all the text
    text = ['Session ' num2str(sessionNo) ' completed!\n\n\n\nPlease find the experimenter'];
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