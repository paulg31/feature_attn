function unc2exp(subjId,sessionNo,familyId,reload,debug)
%UNC2EXP Uncertainty squared experiment.

if nargin < 1 || isempty(subjId) || ~ischar(subjId) || numel(subjId) ~= 3
    error('First argument is subject''s 3-letter identifier.');
end
subjId = upper(subjId); % Subject identifier is all uppercase

if nargin < 2 || isempty(sessionNo)
    error('Second argument is session number.');
end

if nargin < 3 || isempty(familyId) || ~any(strcmpi(familyId,{'A','B','M'}))
    error('Third argument is session family (''A'', ''B'', or ''M'').');
end
familyId = upper(familyId);
if strcmp(familyId,'M'); measurementSession = 1; else measurementSession = 0; end

if nargin < 4 || isempty(reload)
    reload = 0;
end

if nargin < 5 || isempty(debug)
    debug = 0;
end

% Experiment parameters
[~,design.hostname]= system('hostname');
Room758PCname = 'marr';     % Hostname for main experimental PC desktop
design.hostname = design.hostname(1:min(end,numel(Room758PCname)));

% hashcoin = mod(sum(subjId),2)+1;    % Choose 1 or 2 based on subject ID
if measurementSession
    switch debug
        case 0
            design.numTrials       = [16,200,200,6,100,16,200,200,6,100];
            design.blockTypeVec    = [4,   5,  5,6,  7, 4,  5,  5,6,  7];
            design.blockIntro      = [1,   1,  1,3,  3, 1,  1,  1,3,  3];
            suffix          = '';
        case 1      % Short debug run
            design.numTrials       = [32,32,4,2,4];
            design.blockTypeVec    = [4,   5,  5,6,  7];
            design.blockIntro      = [1,   1,  1,3,  3];
            suffix          = '_debugs';
        case 2      % Medium debug run, allow to check for statistics
            design.numTrials       = [8,24,16,4,12,8,24,16,4,12];
            design.blockTypeVec    = [4,   5,  5,6,  7, 4,  5,  5,6,  7];
            design.blockIntro      = [1,   1,  1,3,  3, 1,  1,  1,3,  3];
            suffix          = '_debugm';
    end
else
    switch debug
        case 0
            design.numTrials       = [16,126,  [96 198 32],repmat([72 198 32],[1,3]),  16,126, 6, 80];
            design.blockTypeVec    = [4,   5,  repmat([1 2 3],[1,4]),       4,  5, 6, 7];
            design.blockIntro      = [1,   1,  2*ones(1,12)                 1,  1, 3, 3];
            suffix          = '';
        case 1      % Short debug run
            design.numTrials       = [4,4];%, repmat([2 2 2],[1,2]), 2,2];
            design.blockTypeVec    = [4,5];%, repmat([1 2 3],[1,2]), 6,7];
            design.blockIntro      = [1,1];%   2*ones(1,6),            1,1];%, 3,3];
            suffix          = '_debugs';
        case 2      % Medium debug run, allow to check for statistics
            design.numTrials       = [8,18,  repmat([12 36 12],[1,2]),  8,18, 4,18];
            design.blockTypeVec    = [4,5,  repmat([1 2 3],[1,2]),  4,5, 6,7];
            design.blockIntro      = [1,1,  2*ones(1,6),            1,1, 3,3];
            suffix          = '_debugm';
        case 3      % Debug reliability discrimination task
            design.numTrials       = [6,200];
            design.blockTypeVec    = [6,7];
            design.blockIntro      = [3,3];
            suffix          = '_debugr';
    end
end
numBlocks       = numel(design.blockTypeVec);

design.stimnumber       = 2*ones(size(design.numTrials));   % For now we assume two stimuli for all blocks
design.gamblecorrect    = .75;              % Fixed value of wager
design.deviations       = 2.5;             % This might later change by block
design.orientations     = [30 -30];
design.visualangle      = 15;
design.deviationsJitter = 0.1;  % Fractional jitter for delta theta

if ~measurementSession
    [thispath,~,~] = fileparts(mfilename('fullpath'));
    filename = [thispath filesep 'designs' filesep 'optdesign_' subjId '.mat'];
    try
        temp = load(filename);
        
        % Minimum and maximum contrast for main task
        c_min = temp.opt_design_vector(1);
        c_max = temp.opt_design_vector(2);
        
        % Standard deviations of category distributions for main task
        design.sigmaCat = temp.opt_design_vector(3:4);
    catch
        text = ['Cannot find measurement session design for subject ' subjId ' in ./designs folder.'];
        if ~debug; error(text); else fprintf('%s\nDEBUG running mode: Press a key to continue.\n',text); pause; end
        c_min = 0.0118;
        c_max = 0.0445;
        design.sigmaCat = [3,12];
    end    
        
    clear temp;
end


for iBlock = 1:numel(design.blockTypeVec)
    design.mat{iBlock}  = [];
    data.mat{iBlock}    = [];
end

% MultiPSI structures
mpsiLR                  = [];       % Left/Right task
mpsiRel                 = [];       % Reliability discrimination task 

% Setup PTB with default values
PsychDefaultSetup(2);

% Set the screen number to the secondary monitor if possible
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

%All stimulus reliabilities (contrast, ellipse eccentricity)
screen.stimulusType        = 'gabor';

% Define all reliability information in RELINFO struct

switch screen.stimulusType 
    case 'gabor'
        if measurementSession
            relInfo.all             = exp(linspace(log(0.01),log(0.135),4));  % All test reliabilities
            relInfo.max             = 1;    % Maximum is 100% contrast
            relInfo.testRef         = 0.067; % Reference reliability for test discrimination
            relInfo.practiceRef     = 0.223; % Pedestal reliability for practice discrimination

        else
            relInfo.all             = exp(linspace(log(c_min),log(c_max),15));
            relInfo.max             = 1;    % Maximum is 100% contrast
            relInfo.testRef         = relInfo.all((end+1)/2);  % Reference is mid-reliability
            relInfo.practiceRef     = 0.223; % Pedestal reliability for practice discrimination
        end
    case 'ellipse'
        % ...
end

% Session families (subjects are NOT told of any difference)
switch familyId
    case 'A'
        relInfo.testMain        = relInfo.all(1:9);
        relInfo.groupsLR        = {1:3,4:6,7:9};
    case 'B'
        relInfo.testMain        = relInfo.all(7:15);
        relInfo.groupsLR        = {1:3,4:6,7:9};
    case 'M'
        relInfo.testMain        = relInfo.all;
        relInfo.groupsLR        = num2cell(1:numel(relInfo.testMain));
end
relInfo.testLR                  = relInfo.testMain;

% Optimal stimulus selection
relInfo.groupsLR{end+1} = numel(relInfo.testLR)+1; % This is going to be max reliability
Ncnd = numel(relInfo.groupsLR);
theta_opt = NaN(1,Ncnd);
deltalnr_opt = NaN;

%Folders
[currentPath,~,~]   = fileparts(which(mfilename()));
resultsFolder       = [currentPath filesep() 'results' filesep()];
outputFile          = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) familyId '_data' suffix,'.mat'];
mpsiFile            = [resultsFolder,'Subj',subjId,'_Session'...
                            num2str(sessionNo) familyId '_mpsi' suffix,'.mat'];
                        
                        
% Load measurement information from previous session or priors from
% measurement session
if sessionNo > 1
    prevmpsiFileLR      = [resultsFolder, 'Subj', subjId,'_Session'...
                                num2str(sessionNo-1) familyId '_mpsi.mat'];
    prevmpsiFileRel     = [resultsFolder, 'Subj', subjId,'_Session'...
                                num2str(sessionNo-1) familyId '_mpsi.mat'];
    priorFilename       = [];
else
    prevmpsiFileLR      = [];
    prevmpsiFileRel     = [];
    if measurementSession
        priorFilename   = [];
    else
        priorFilename   = [currentPath filesep 'designs' filesep 'optdesign_' subjId '.mat'];
    end
end
addpath([currentPath filesep() 'multipsi']);        % Add multiPSI folder

%Create results folder if it does not exist already
if ~exist([currentPath filesep() 'results'],'dir')
    mkdir(currentPath,'results');
end

%Check if Outputfile already exists
if exist(outputFile,'file')
    if ~reload
        error(['File ''' outputFile ''' already exists in Results directory.']);
    end
    fprintf('Recovering from interrupted session.\n');
    error('Recovery not supported yet.');
    
    % Recover from interrupted session
    load(outputFile);
    if isinf(trial)           % Crashed at the end of the block, start from next block
        trialStart = 1;
        blockStart = iBlock + 1;
    else
        trialStart = trial+1; % Start from the following trial
        blockStart = iBlock; 
    end
    
    % Load and restore multiPSI struct
    if exist(mpsiFile,'file'); load(mpsiFile); end
    [mpsiLR,mpsiRel] = initMPSI(mpsiLR,mpsiRel,prevmpsiFileLR,prevmpsiFileRel,priorFilename);
    
    if ~isinf(trial)
        if design.blockTypeVec(blockStart) == 4 || design.blockTypeVec(blockStart) == 5        
            % Reconstruct data in the last block since multiPSI was not saved
            for trial = 1:trialStart-1
                rel         = design.mat{iBlock}(trial,2);
                theta       = design.mat{iBlock}(trial,4);
                response    = data.mat{iBlock}(trial,2);
                c           = find(rel == relInfo.testLR,1);
                [~,mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],theta,response,c);
            end        
        end
        if design.blockTypeVec(blockStart) == 7  
            % Reconstruct data in the last block since multiPSI was not saved
            for trial = 1:trialStart-1
                deltalnRel    = log(design.mat{iBlock}(trial,3)) - log(design.mat{iBlock}(trial,2));
                response    = data.mat{iBlock}(trial,2);
                [~,mpsiRel] = multipsi(mpsiRel,'ent',[1 1 0],deltalnRel,response,1);
            end
        end
    end
else
    % Start from scratch
    trialStart = 1;
    blockStart = 1;
    data.blockDuration = NaN(1,numBlocks);
    
    % Initialize multiPSI structure
    [mpsiLR,mpsiRel] = initMPSI(mpsiLR,mpsiRel,prevmpsiFileLR,prevmpsiFileRel,priorFilename);
end

% Skip sync tests on other computers
if strncmpi(design.hostname, Room758PCname, 4)
    Screen('Preference', 'SkipSyncTests', 0);
    fprintf('Executing screen sync test.\n');
else
    Screen('Preference', 'SkipSyncTests', 2);
    fprintf('Skipping screen sync test.\n');
end

% % Load gamma table (assumes iPad screen)
switch lower(design.hostname)
    case lower(Room758PCname)
        fprintf('Loading Gamma correction table.\n');
        screen.calib = load('iPadGammaTable.mat');
    otherwise
        fprintf('Skipping Gamma correction.\n');
        screen.calib = [];
end

% Pause before proceeding
fprintf('Press a key to start the experiment.\n');
pause;

% Open the screen
[screen.window, screen.windowRect] = PsychImaging('OpenWindow', screenNumber, screen.bgcolor,...
                            [], 32, 2,[], [],  kPsychNeed32BPCFloat);

% pixels per degree                        
screen.pxPerDeg     = screen.windowRect(4) / screen.angle;  

% Get the size of the on screen window in pixels
[~, screen.Ypixels] = Screen('WindowSize', screen.window);

% Centers
[screen.xCenter, screen.yCenter] = RectCenter(screen.windowRect);

% IFI and Screen Info
screen.ifi = Screen('GetFlipInterval', screen.window);
Screen('TextFont', screen.window, 'Times New Roman');

% Apply gamma table if present
if ~isempty(screen.calib)
    Screen('LoadNormalizedGammaTable', screen.window, screen.calib.gammaTable*[1 1 1]);
end

% switch lower(design.hostname)
%     case lower(Room758PCname)
%         screen.calib = load('iPadGammaTable.mat');
%         Screen('LoadNormalizedGammaTable', screen.window, screen.calib.gammaTable*[1 1 1]);
%     otherwise
%         fprintf('Skipping Gamma correction.\n');
% end

%% Experiment design

% Define fixation cross and stimuli
screen = crossinfo(screen);
switch screen.stimulusType
    case 'gabor'
        design.gabor = gaborinfo(screen);
    case 'ellipse'
        % ...
end

% Store a copy of reliability info and screen info in DESIGN struct
design.relInfo = relInfo;
design.screen = screen;

HideCursor;

% Show initial instructions
showinstructions(0,screen);


%%
for iBlock = blockStart:numBlocks
    
    startBlockTime = GetSecs();
    
    % Show block instructions
    showinstructions(design.blockIntro(iBlock),screen);
    
    % Initialize block information
    switch design.blockTypeVec(iBlock)
            case 1  % Training (main task)
                blockType       = 'train';
                relVec          = relInfo.max;
                feedbackType    = 'audio';
                
            case 2  % Test (main task)
                blockType       = 'test';
                relVec          = relInfo.testMain;
                feedbackType    = 'none';
                
            case 3  % Category test (main task)
                blockType       = 'category_test';
                relVec          = relInfo.max;
                feedbackType    = 'none';
                
            case 4  % Train (left/right task)
                blockType       = 'leftright_train';
                relVec          = relInfo.max;
                feedbackType    = 'audio';
                
            case 5  % Test (left/right task)
                blockType       = 'leftright_test';
                relVec          = relInfo.testLR;
                if measurementSession
                    feedbackType    = 'audio';
                else
                    feedbackType    = 'none';
                end
                
            case 6  % Train (reliability discrimination task)
                blockType       = 'rel_train';
                relVec          = 1;
                feedbackType    = 'audio';

            case 7  % Test (reliability discrimination task)
                blockType       = 'rel_test';
                relVec          = 1;
                feedbackType    = 'audio';
                
    end

    design.block_type{iBlock}   = blockType;
    if design.blockTypeVec(iBlock) <= 5    % Left/Right and main task blocks
        design.fields{iBlock}       = {'trial','reliability','visual angle','orientation1', 'orientation2','opt_out'};
    else                            % Reliability discrimination task blocks
        design.fields{iBlock}       = {'trial','rel1','rel2','orientation1','orientation2'};        
    end

    data.block_type{iBlock}     = blockType;
    data.fields{iBlock}         = {'trial','response','RT','correct'};    

    % Prepare design matrix
    if isempty(design.mat{iBlock})
        design.mat{iBlock} = NaN(design.numTrials(iBlock),numel(design.fields{iBlock}));
        design.mat{iBlock}(:,1) = 1:design.numTrials(iBlock);          % Trial number
    end
    
    % Counterbalance Wager (together with reliability)
    cb_mat = 1:design.numTrials(iBlock);
    trial_type = repmat(1:length(cb_mat),[1,ceil(design.numTrials(iBlock)/length(cb_mat))]);
    trial_type = trial_type(randperm(numel(trial_type)));
    trial_type = trial_type(1:design.numTrials(iBlock))';
    for trial = 1: design.numTrials(iBlock)
        if mod(floor((trial_type(trial)-1)/numel(relVec)),2) == 0
            opt_out = 1;
        else
            opt_out = 0;
        end
        design.mat{iBlock}(trial,6) = opt_out;
    end
    
    % Counterbalance Reliability
    rel_idx = mod(trial_type-1, numel(relVec)) + 1;
    design.mat{iBlock}(:,2) = relVec(rel_idx);
        
    % Visual Angle
    design.mat{iBlock}(:,3) = design.visualangle;

    % Create orientations for each trial
    for trial = 1:design.numTrials(iBlock)
        mean    = design.orientations(randi(length(design.orientations)));
        deviation = normrnd(design.deviations,design.deviations*design.deviationsJitter);
        chance = .5;

        switch design.stimnumber(iBlock)
        case 1
            orientation = mean + deviation;
            design.mat{iBlock}(trial,[4 5]) = [orientation,NaN];
        case 2
            if rand <= chance
                orientation1 = mean + deviation/2;
                orientation2 = mean - deviation/2;
            else
                orientation1 = mean - deviation/2;
                orientation2 = mean + deviation/2;
            end
            design.mat{iBlock}(trial,[4 5]) = [orientation1,orientation2];
        end
    end
    
    %Prepare empty data matrix
    if isempty(data.mat{iBlock})
        data.mat{iBlock} =  NaN(design.numTrials(iBlock),numel(data.fields{iBlock}));
    end
    
    % Loop over trials
    for trial = trialStart:design.numTrials(iBlock)
        
        switch design.blockTypeVec(iBlock)
    
            case {1, 3}  % Training (main task) or category test. 1 stim
                
                params = [
                    design.stimnumber(iBlock), design.mat{iBlock}(trial,2)...
                    design.mat{iBlock}(trial,3), design.mat{iBlock}(trial,[4 5])...
                    design.mat{iBlock}(trial,6)
                    ];
                
                if design.blockTypeVec(iBlock) == 4
                    c = Ncnd; % Maximum reliability psychometric curve
                else
                    % Find reliability group of psychometric curve
                    c_idx = find(params(2)== relVec,1);
                    c = find(cellfun(@(x) any(x == c_idx), relInfo.groupsLR),1);
                end
                
                if isnan(theta_opt(c))
                    % Get optimal stimulus and perform initialization
                    [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],[],[],c);
                end
                
                 [response, RT] = ...
                     runtrial(design,blockType,params); %block type is left right
                 correct = feedback(theta_opt(c),response,screen,blockType,feedbackType,design,params);

                endTrialTime = GetSecs();
                
                % Get next recommended point that minimizes predicted entropy 
                % given the current posterior and response at theta
                tic
                [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],theta_opt(c),response,c);
                toc
                
                % Break at middle
                if trial == ceil(design.numTrials(iBlock)/2)
                    showinstructions(4,screen)
                end

            case 2  % Test (main task) 1 stim.
                               
                % [stimnum contrast visual_angle orientation(1:2) wager]
                params = [
                    design.stimnumber(iBlock), design.mat{iBlock}(trial,2)...
                    design.mat{iBlock}(trial,3), design.mat{iBlock}(trial,[4 5])...
                    design.mat{iBlock}(trial,6)
                    ];
                
                if design.blockTypeVec(iBlock) == 4
                    c = Ncnd; % Maximum reliability psychometric curve
                else
                    % Find reliability group of psychometric curve
                    c_idx = find(params(2) == relVec,1);
                    c = find(cellfun(@(x) any(x == c_idx), relInfo.groupsLR),1);
                end
                
                if isnan(theta_opt(c))
                    % Get optimal stimulus and perform initialization
                    [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],[],[],c);
                end
                
                 [response, RT] = ...
                     runtrial(design,blockType,params); %block type is left right
                 correct = feedback(theta_opt(c),response,screen,blockType,feedbackType,design,params);

                endTrialTime = GetSecs();
                
                % Get next recommended point that minimizes predicted entropy 
                % given the current posterior and response at theta
                tic
                [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],theta_opt(c),response,c);
                toc
                
                % Break at middle
                if trial == ceil(design.numTrials(iBlock)/2)
                    showinstructions(4,screen)
                end

            case {4,5}  % Training and test for left/right task (optimal stimulus selection) 2 stim.
                
                % [stimnum contrast visual_angle orientation(1:2) wager]
                params = [
                    design.stimnumber(iBlock), design.mat{iBlock}(trial,2)...
                    design.mat{iBlock}(trial,3), design.mat{iBlock}(trial,[4 5])...
                    design.mat{iBlock}(trial,6)
                    ];
                
                if design.blockTypeVec(iBlock) == 4
                    c = Ncnd; % Maximum reliability psychometric curve
                else
                    % Find reliability group of psychometric curve
                    c_idx = find(params(2) == relVec,1);
                    c = find(cellfun(@(x) any(x == c_idx), relInfo.groupsLR),1);
                end
                
                if isnan(theta_opt(c))
                    % Get optimal stimulus and perform initialization
                    [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],[],[],c);
                end
                
                 [response, RT] = ...
                     runtrial(design,blockType,params); %block type is left right
                 correct = feedback(theta_opt(c),response,screen,blockType,feedbackType,design,params);

                endTrialTime = GetSecs();
                
                % Get next recommended point that minimizes predicted entropy 
                % given the current posterior and response at theta
                tic
                [theta_opt(c),mpsiLR] = multipsi(mpsiLR,'ent',[1 1 0],theta_opt(c),response,c);
                toc
                
                % Break at middle
                if trial == ceil(design.numTrials(iBlock)/2)
                    showinstructions(4,screen)
                end
                
             case 6  % Train for reliability discrimination task
                rels    = design.mat{iBlock}(trial,[2,3]);
                thetas  = design.mat{iBlock}(trial,[4,5]);
                
                [response, RT] = ...
                    runtrial(design,rels,thetas,blockType); %block type is left right
                correct = feedback([],rels,response,screen,blockType,feedbackType,design);
                endTrialTime = GetSecs();

                
            case 7  % Test for reliability discrimination task (optimal stimulus selection)
                if isnan(deltalnr_opt)
                    % Get optimal stimulus and perform initialization
                    [deltalnr_opt,mpsiRel] = multipsi(mpsiRel,'ent',[1 1 0],[],[],1);
                end
                if isnan(design.mat{iBlock}(trial,2))
                    design.mat{iBlock}(trial,2) = exp(log(relInfo.testRef) + deltalnr_opt);
                    testpos = 1;
                else
                    design.mat{iBlock}(trial,3) = exp(log(relInfo.testRef) + deltalnr_opt);
                    testpos = 2;
                end
                rels    = design.mat{iBlock}(trial,[2,3]);
                thetas  = design.mat{iBlock}(trial,[4,5]);
                
                [response, RT] = ...
                    runtrial(design,rels,thetas,blockType); %block type is left right
                correct = feedback([],rels,response,screen,blockType,feedbackType,design);
                endTrialTime = GetSecs();
                
                % Get next recommended point that minimizes predicted entropy 
                % given the current posterior and response at test reliability
                tic
                [deltalnr_opt,mpsiRel] = multipsi(mpsiRel,'ent',[1 1 0],deltalnr_opt,response==testpos,1);
                toc
         end
        
        data.mat{iBlock}(trial,:) = [ ...
            trial, response, RT, correct ...
        ];
        
        % Save data at the end of each trial
        save(outputFile, 'data', 'design', 'trial', 'iBlock');
        
        % Wait before start of new trial, remove time spent in computation
        passedTime = GetSecs() - endTrialTime;
        
        % Small jitter of inter-trial duration
        waitTime = screen.betweentrials*(1+screen.jitter*(2*rand()-1));
        
        WaitSecs(max(0,waitTime - passedTime));
        
    end

    % Clean multiPSI struct before saving it at the end of each block
    if design.blockTypeVec(iBlock) == 4 || design.blockTypeVec(iBlock) == 5
        % Compute parameter estimates
        for c = 1:Ncnd; [~,~,mpsiLR{c}.output] = multipsi(mpsiLR,'ent',[1 1 0],[],[],c); end
        [~,mpsiLR] = multipsi(mpsiLR);
        save(mpsiFile, 'mpsiLR','mpsiRel');
    end
    
    if design.blockTypeVec(iBlock) == 7
        % Compute parameter estimates
        [~,~,mpsiRel{1}.output] = multipsi(mpsiRel,'ent',[1 1 0],[],[],1);
        [~,mpsiRel] = multipsi(mpsiRel);
        save(mpsiFile, 'mpsiLR','mpsiRel');
    end
    
    % Show block feedback
    total = sum(data.mat{iBlock}(:,4),1);                   % Total score
    completion = sum(design.numTrials(1:iBlock))/sum(design.numTrials);   % Completed
    displayscore(total,completion,screen);
    trialStart = 1;    
    trial = Inf;    % Reached end of the block
    
    data.blockDuration(iBlock) = GetSecs() - startBlockTime;
    
    % Save data at the end of the block
    save(outputFile, 'data', 'design', 'trial', 'iBlock');    
    
end
%%
% Flip to the screen
Screen('Flip',screen.window);
    
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

    function [mpsiLR,mpsiRel] = initMPSI(mpsiLR,mpsiRel,prevmpsiFileLR,prevmpsiFileRel,priorFilename)
        
        % Initialize MPSI struct for Left/Right task
        if isempty(mpsiLR)
            prevmpsiFileLR
            if isempty(prevmpsiFileLR)  % First session, initialize from scratch
                fprintf('Generating left/right MPSI struct from scratch.\n');
                mpsiLR = getmultipsi('LR',[relInfo.testLR,relInfo.max],relInfo.groupsLR,priorFilename);
            elseif ~exist(prevmpsiFileLR,'file')
                    error('Cannot find multiPSI data file from previous session.');
            else    % Next session, load MPSI from last session
                load(prevmpsiFileLR,'mpsiLR');
                fprintf('Loading left/right measurement data from previous session.\n');
            end
        end
        
        % Initialize MPSI struct for reliability discrimination task
        if isempty(mpsiRel)
            if isempty(prevmpsiFileRel) % First session, initialize from scratch
                fprintf('Generating reliability MPSI struct from scratch.\n');
                mpsiRel = getmultipsi('rel',[],[],priorFilename);
            elseif ~exist(prevmpsiFileRel,'file')
                error('Cannot find multiPSI data file from previous session.');
            else    % Next session, load MPSI from last session
                load(prevmpsiFileRel,'mpsiRel');
                fprintf('Loading reliability measurement data from previous session.\n');
            end
        end
        
    end

end