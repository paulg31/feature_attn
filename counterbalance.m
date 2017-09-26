function cue_order = counterbalance(design,iBlock,data)
trials      = design.trial_nums(iBlock);
cue_ratio   = design.cue_ratio/2;

switch data.block_type{iBlock}
    case {'T' 'HA' 'LA'}
    cue_order = zeros(trials,1);
    
    case {'I'}
    cue_order = ones(trials,1);

    for ii = 1:trials
        if ii <= design.pre_start
            for jj = 1:numel(design.pre_start)
                if rand < .5 % Pre cues
                    cue_order(ii) = 3;
                else
                    cue_order(ii) = 7;
                end
            end
        elseif ii > design.pre_start  && ii <= design.pre_end
            for jj = 1:numel(design.pre_end - design.pre_start)
                if rand < .5 % Post cues
                    cue_order(ii) = 1;
                else
                    cue_order(ii) = 5;
                end
            end
        else
                if rand < .5 % Pre and Post cues
                    cue_order(ii) = 2;
                else
                    cue_order(ii) = 6;
                end
        end
    end
    
    case {'HN' 'HW' 'LW' 'LN'}
    cues = ones(trials,1);
    cues(1:round(trials*cue_ratio)) = 2; % Pre and Post, Low
    cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = 1; % Just Post, Low
    cues(2*round(trials*cue_ratio)+1:3*round(trials*cue_ratio)) = 3; % Just Pre, Low
    cues(3*round(trials*cue_ratio)+1:4*round(trials*cue_ratio)) = 0; % Null, Low
    cues(4*round(trials*cue_ratio)+1:5*round(trials*cue_ratio)) = 4; % Pre and Post, High
    cues(5*round(trials*cue_ratio)+1:6*round(trials*cue_ratio)) = 5; % Pre and Post, High
    cues(6*round(trials*cue_ratio)+1:7*round(trials*cue_ratio)) = 6; % Pre and Post, High
    cues(7*round(trials*cue_ratio)+1:end) = 7; % Pre and Post, High
    order = randperm(trials);
    cue_order = cues(order);
    
end