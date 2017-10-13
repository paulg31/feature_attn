function feature_exp(subjId,sessionNo,block,reload,debug)

if nargin < 1 || isempty(subjId) || ~ischar(subjId) || numel(subjId) ~= 3
    error('First argument is subject''s 3-letter identifier.');
end
subjId = upper(subjId); % Subject identifier is all uppercase

if nargin < 2 || isempty(sessionNo)
    error('Second argument is session number.'); % Session Number
end

if nargin < 3 || isempty(block)
    if sessionNo == 1
        design.blocked = 0; %LHLHL....
    else
        error('Third argument is block type');
    end
else
    if block == 1 || block == 0
        design.blocked = block; %HLHLH....
    else
        error('Block options are 0 or 1');
    end
end

if nargin < 4 || isempty(reload) 
    reload = 0; % 1 to reload crashed session
end

if nargin < 5 || isempty(debug)
    debug = 0; % 1 to do a short run 
end

% Things that change
% - cue_ratio: .33 for sandwhich, .25 for normal
% - control: 0 for grid, 1 for no grid
% - design.types items 5 and 6: if the same, no blocking

% Exp Design
design.types        = [1 2 8 7 5 3];                      % Blocks, numbers explained later 3!!!
design.contrast    = [.135 .017];       % Used only for Gabor stimulus, Will -- linspace(.004,.135,6)
design.roundness    = [5 15];                          % Larger value, more circular
design.width        = [9 13];                        % distribution width types, narrow, wide
design.arc_dist     = 3.3;                % arc distance from center in dva
design.med2sd       = 1.48;             % conversion for median to sd
design.mean_mult    = 1.25;             % multiplier for median/mean
design.wide_ratio   = 1.5;          % multiplier for wide cue, was sqrt(3)
design.cue_ratio    = 1/3;              % ratio for both the pre+post and post conditions
design.target_lowerbound = .75;         % lower bound for adaptive
design.target_upperbound = 1.25;        % upper bound for adaptive
design.target_SDerror    = [9 9];          % target SD error, includes 1.48 multiplier
design.pointsigma_mult   = [.7 .7];          % sigma for feedback distribution
design.date              = date;        % gets the date
clock_vals               = clock;       % gets the time
design.time_start = clock_vals(4:end);  % saves only hour/min/sec
target_cue               = 1;           % 1 for arc
null_cue                 = 0;           % 0 for circle, 2 for nothing
design.high_rel          = 1; 
design.low_rel           = 2;
design.stim              = 1;           % 1 for ellipse 2 for gabor
design.adapt_type        = 2;           % adaptive type, switch to 1 for longer/older verison(adapt_byz)
design.point_array       = [];          % points for cumulative average
control = 0;

switch debug
    case 0
        design.intro_trials     = [172 120 172 30];  % Trials for the intro blocks
        design.session_trials   = 136;           % Trials for rest of blocks in session 1
        design.other_trials     = 144;           % Trials for the rest of the sessions
        params.highstep_trials  = 100;           % Step of 2 for first 100 trilas in adapt_byz
        params.start_check      = 100;           % Start to check med error in adapt_byz
        params.mod_val          = 10;            % Check error every mod_val trials in adapt_byz
        params.move_wind_size   = 50;            % Moving Window for range to check in adapt_byz
        design.twoStep          = 20;            % Adapt v2, first 20 trials change roundness by 2
        design.oneStep          = 40;            % Adapt v2, next 20 trials change roundness by 1
        start_width             = 1;             % Start setting the width from this trial onwards
        design.discard4round    = design.oneStep+1; % Start with this trial to set roundness
    case 1
        design.intro_trials     = [3 3 3 3];
        design.session_trials   = 8;
        design.other_trials     = 8;     
        params.highstep_trials  = 10;
        params.start_check      = 10;
        params.mod_val          = 5;
        params.move_wind_size   = 10;
        design.twoStep          = 20;            % Adapt v2, first 20 trials change roundness by 2
        design.oneStep          = 40;            % Adapt v2, next 20 trials change roundness by 1
        start_width             = 1;
        design.discard4round    = 1;
end

% cues-roundness combos blocked(1) or not(0)
if design.types(end) == design.types(end-1)
    design.block = 0;           
else
    design.block = 1;
end

% Instruction Block trial division
design.post_start   = 1;    % Start with Post for 1/3
design.pre_start    = ceil((1/3)*design.intro_trials(4));   %Continue with pre
design.pre_end      = ceil((2/3)*design.intro_trials(4));   %End with pre+post

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
        design.point_array = design.point_array;
        design.types = design.types;
        design.rel_type = design.rel_type;
        trialStart = 1;
        blockStart = iBlock + 1;
    else
        design.point_array = design.point_array;
        design.types = design.types; 
        design.rel_type = design.rel_type;
        trialStart = trial+1; % Start from the following trial
        blockStart = iBlock; 
    end
    
else
    % Start from scratch
    trialStart = 1;
    blockStart = 1;
    
    switch design.cue_ratio
        case 1/4
            % Shuffle test blocks
            [design] = shuffle_blocks( design, sessionNo, resultsFolder, subjId);
        case 1/3
            [design] = shuffle_new( design, sessionNo,resultsFolder, subjId);
            
    end
    
    % Empty structs if loading prev session( Session 2+ )
    if sessionNo ~= 1
        design.mat          = [];
        design.numtrials    = [];
        design.fields       = [];
        data.mat            = [];
        data.fields         = [];
        data.block_type     = [];
    end
    
    % Empty data mats for each block and organize trials
    for iBlock = 1:numel(design.types)
            data.mat{iBlock}            = [];
            design.mat{iBlock}          = [];
            design.numtrials(iBlock)    = design.trial_nums(iBlock);
    end
end

%PsychDefaultSetup(2);

% Screen Setup
screenNumber = max(Screen('Screens'));
%screenNumber = 1;
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
screen.jitter        = 0.1;                 % 10% random jitter of durations
screen.gabor_drift   = 0;                   % Gabor drift speed (0=static)     
screen.circle_size   = design.arc_dist;   % Size of circle cue(will be same as arc radius*2)
screen.circle_thickness   = .15;             % Thickness of circle cue in degrees(can be changed)
screen.bar_width     = 4; 
screen.bar_height    = floor(design.arc_dist/7*325); % was 250 when cue distance was 7,180 when 5, now 160 when 4.5
screen.waitfr = 1;
screen.frame_diff = .5;

% Timings
screen.stim_duration = 0.05;    % Stimulus presentation time
screen.cue_duration  = 0.3;     % Cue duration 
screen.fixationdur   = 0.5;     % fixation duration
screen.ISI           = 0.5;     % Inter-stimulus-interval(Unused)
screen.betweentrials = 0.3;     % Time between trials
screen.feedback_time = 0.8;     % Feedback Presentation Time
screen.stim_pre      = 0.2;     % Time between pre cue and stim
screen.stim_post     = 0.3;     % Time between stim and post cue
screen.inst_pause    = 0.2;     % Time between instruct screens

% Correction to stimulus width/period since previously reported dva were off
screen.stimwidthmultiplier = 1.5352;

% Open the screen
[screen.window, screen.windowRect] = PsychImaging('OpenWindow', screenNumber, screen.bgcolor);

% Get the size of the on screen window in pixels
[screen.Xpixels, screen.Ypixels] = Screen('WindowSize', screen.window);

% Centers
[screen.xCenter, screen.yCenter] = RectCenter(screen.windowRect);

% pixels per degree                        
screen.pxPerDeg   = screen.windowRect(3) / screen.angle; 

% IFI and Screen Info
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');
screen = crossinfo(screen);

% Get stim
switch design.stim
    case 1
        design.stim = 'ellipse';
        design.rel_type = 'roundness';
    case 2
        design.stim = 'gabor';
        design.rel_type = 'contrast';
end

% Begin
screen.vbl = Screen('Flip',screen.window);
ring = grid_info( screen, design, control);
HideCursor;
trial = 0;
showinstructions(0,screen,1,design,params,ring,trial);
WaitSecs(screen.inst_pause);

if sessionNo == 1
    instruct_screen1( screen,design );
    WaitSecs(screen.inst_pause);
    instruct_screen2( screen, ring,design);
    WaitSecs(screen.inst_pause);
    instruct_screen3( screen,ring,design)
    WaitSecs(screen.inst_pause);
    instruct_progress(screen,ring,design );
    WaitSecs(screen.inst_pause);
    showinstructions(3,screen,1,design,params,ring,trial);
    WaitSecs(screen.inst_pause);
else 
    showinstructions(11,screen,1,design,params,ring,trial);
    WaitSecs(screen.inst_pause);
end

exp_start = GetSecs;

% Begin Block
for iBlock = blockStart:numel(design.types)
    
    % Starting Instructions
    block_start = GetSecs;
    showinstructions(1, screen, iBlock,design,params,ring,trial)
    params.instruct = 0;
 
    data.fields{iBlock}         = {'trial','response','ellipse orientation','points','error','cue center','cue ID','resp_time'};
    design.fields{iBlock}       = {'trial','mouse start x','mouse start y',' width',design.rel_type,'trial duration'}; 
    
    % Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(design.numtrials(iBlock),numel(data.fields{iBlock})) ; %trial num, item to save nume
    end
    
    % Block Type
    switch design.types(iBlock)
        case 1 % Adapt for low roundness
            params.width = design.width(1);
            params.index = 1;
            data.block_type{iBlock}     = 'LA';
            
        case 2 % Train
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
            
        case 7% Intruct
            params.width = design.width(1);
            params.index = 1;
            data.block_type{iBlock}     = 'I';
            
        case 8 % Adapt for high roundness
            params.width = design.width(1);
            params.index = 2;
            data.block_type{iBlock}     = 'HA';
    end
    
    switch design.cue_ratio
        case 1/4
            % Balance Cues
            design.cue_order{iBlock}    = counterbalance(design,iBlock,data);
        case 1/3
            design.cue_order{iBlock}    = counterbalance_new(design,iBlock,data,sessionNo);
    end
    
   switch data.block_type{iBlock}
       
       case {'I'}; 
            WaitSecs(screen.inst_pause);
            instruct_ellRound(screen,params,design,ring);
            WaitSecs(screen.inst_pause);
            showinstructions(8,screen,1,design,params,ring,trial);
            WaitSecs(screen.inst_pause);
            instruct_useCue( screen,params,design,ring,1);
            WaitSecs(screen.inst_pause);
            instruct_useCue( screen,params,design,ring,3);
            WaitSecs(screen.inst_pause);
            instruct_useCue( screen,params,design,ring,4);
            WaitSecs(screen.inst_pause);
            instruct_useCue( screen,params,design,ring,2);
        
       case {'HA'};
            showinstructions(12,screen,iBlock,design,params,ring,trial);
       
       case {'LN' 'HN'};
           if sessionNo == 1
               switch iBlock
                   case {5 6}
                       showinstructions(14,screen,iBlock,design,params,ring,trial);
                   case {7 8}
                       showinstructions(13,screen,iBlock,design,params,ring,trial);
               end
           else
               switch iBlock
                   case {1 2 9 10}
                       showinstructions(13,screen,iBlock,design,params,ring,trial);
                   case {3 4 5 6 7 8}
                       showinstructions(14,screen,iBlock,design,params,ring,trial);
               end
           end
           
   end
   
    % Adaptive block, no cues
    switch data.block_type{iBlock}
        case {'LA', 'HA'}
    %if data.block_type{iBlock} == 'LA' || data.block_type{iBlock} == 'HA';
        params.stim_type    = design.stim;
        params.cue_type     = 0;
        params.pre_cue      = null_cue;
        params.post_cue     = null_cue;
        params.iblock       = iBlock;
        
        switch design.adapt_type
            case 1
                [data, design, trial] = adapt_byz(screen, params, data, design, ring, outputFile);
            case 2
                [data, design, trial] = adapt_ott(screen, params, data, design, ring, trialStart, outputFile);
        end
        %else
        
        case {'T' 'I' 'HN' 'HW' 'LW' 'LN'}
    % Trials
    for trial = trialStart:design.numtrials(iBlock)
        trial_start         = GetSecs;
        params.stim_type    = design.stim;
        params.cue_instruct = 0;
        params.trial_mean   = rand(1)*180; % Random Orientation
        
        if data.block_type{iBlock} == 'I'
            if trial == design.post_start
                showinstructions(4,screen,iBlock,design,params,ring,trial);
            elseif trial == design.pre_start+1
                showinstructions(5,screen, iBlock,design,params,ring,trial)
            elseif trial == design.pre_end+1
                showinstructions(6,screen, iBlock,design,params,ring,trial)
            end
        end
        
        % Ellipse roundness and Cue appearances
        if design.cue_order{iBlock}(trial) < 4
            params.relType = design.high_rel; %low round
        else
            params.relType = design.low_rel; % high round
        end
        
        switch mod(design.cue_order{iBlock}(trial),4)
            case 0 % Null
                params.pre_cue  = null_cue;
                params.post_cue = null_cue;                
            case 1 % Post
                params.pre_cue  = null_cue; 
                params.post_cue = target_cue;
            case 2 % Pre + Post
                params.pre_cue  = target_cue;
                params.post_cue = target_cue;
            case 3 % Pre
                params.pre_cue  = target_cue;
                params.post_cue = null_cue;
        end

        % Determine what to save
        switch params.stim_type
            case 'ellipse'
                type_save = design.roundness(params.relType);
            case 'gabor'
                type_save = design.contrast(params.relType);
        end
        
        % Pass info to runtrial
        [point_totes,mouse_start,responseAngle,resp_error,arc_mean,resp_time ] = runtrial(screen,design,params, ring, iBlock,data, trial);
        
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
    block_end                = GetSecs;
    end_vals                 = clock;
    design.time_end          = end_vals(4:end);
    exp_end                  = GetSecs;
    design.block_dur{iBlock} = block_end-block_start;
    design.exp_dur           = exp_end-exp_start;
    
    % If end of train block, set cue widths
    if data.block_type{iBlock} == 'T'
        original_target = design.width(1);
        design.width(1) = design.med2sd*median(abs(data.mat{2}(start_width:end,5)));
        design.width(2) = max(design.wide_ratio*design.width(1),original_target*sqrt(design.wide_ratio));
        design.target_SDerror(2) = design.width(2);
    end
    
    % Save data at the end of the block
    save(outputFile, 'data', 'design','trial','iBlock'); 
    
    % Show block feedback
    total       = sum(data.mat{iBlock}(:,4),1);                         % Total score
    completion  = sum(design.numtrials(1:iBlock))/sum(design.numtrials);% Completed
    switch sessionNo
        case 1
            if iBlock == 5
                [avg_points, design] = get_blockAverage(design, data, sessionNo, iBlock, total);
            elseif iBlock == 6
                [avg_points, design] = get_blockAverage(design, data, sessionNo, iBlock, total);
            else
                avg_points = [];
            end
        case {2, 3}
            [avg_points, design] = get_blockAverage(design, data, sessionNo, iBlock, total);
    end
    displayscore(total,completion,screen,data,avg_points);
    trialStart  = 1;    
    trial       = Inf;    % Reached end of the block
    
    switch data.block_type{iBlock}
        case {'HA'};
        showinstructions(7,screen,1,design,params,ring,trial);
        case {'I'};
        showinstructions(10,screen,1,design,params,ring,trial);
    end
    
    % Save data at the end of the block
    save(outputFile, 'data', 'design','trial','iBlock'); 
    
end 

    % Draw all the text
    text = ['Session ' num2str(sessionNo) ' completed!\n\n\n\nPlease find the experimenter'];
    Screen('TextSize', screen.window, screen.text_size);
    DrawFormattedText(screen.window, text, 'center', screen.Ypixels * 0.4, screen.white);
    screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
    
    % Enable only SPACE to continue
    RestrictKeysForKbCheck(32);
    KbWait([],2);
    RestrictKeysForKbCheck([]);

    %Return Cursor
    ShowCursor;
    
    % Check MAD, for screening
    if sessionNo == 1
        [mad_low, mad_high] = getMAD(data);
        fprintf(num2str(mad_low));
        fprintf('\n');
        fprintf(num2str(mad_high));
    end
   
    % Clear screen
    sca;
    Screen('CloseAll');
end