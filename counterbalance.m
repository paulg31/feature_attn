function cue_order = counterbalance(design,iBlock)

trials = design.trial_nums(iBlock);
cue_ratio = design.cue_ratio;

cues = ones(trials,1);
cues(1:round(trials*cue_ratio)) = 2; % Pre and Post
cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = 1; % Just Post
cues(2*round(trials*cue_ratio)+1:3*round(trials*cue_ratio)) = 3; % Just Pre
cues(3*round(trials*cue_ratio)+1:end) = 0; % Null
order = randperm(trials);
cue_order = cues(order);
end