function cue_order = counterbalance(design,iBlock,data)
trials      = design.trial_nums(iBlock);
cue_ratio   = design.cue_ratio;

if data.block_type{iBlock} == 'T'
    cue_order = zeros(trials,1);
    
elseif data.block_type{iBlock} == 'I'
    cue_order = ones(trials,1);

    for ii = 1:trials
        if ii <= design.pre_start
            cue_order(ii) = 1;
        elseif ii > design.pre_start  && ii <= design.pre_end
            cue_order(ii) = 3;
        else
            cue_order(ii) = 2;
        end
    end
    
else
    cues = ones(trials,1);
    cues(1:round(trials*cue_ratio)) = 2; % Pre and Post
    cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = 1; % Just Post
    cues(2*round(trials*cue_ratio)+1:3*round(trials*cue_ratio)) = 3; % Just Pre
    cues(3*round(trials*cue_ratio)+1:end) = 0; % Null
    order = randperm(trials);
    cue_order = cues(order);
    
end