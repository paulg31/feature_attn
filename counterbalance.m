function cue_order = counterbalance(design,iBlock)

trials = design.numtrials(iBlock);
cue_ratio = design.cue_ratio;

cues = ones(trials,1);
cues(1:round(trials*cue_ratio)) = 2; % Pre and Post
cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = 1; % Just Post
cues(2*round(trials*cue_ratio)+1:end) = 0; % Null
order = randperm(trials);
cue_order = cues(order);
end

