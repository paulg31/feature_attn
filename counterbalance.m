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
                    cue_order(ii) = 1;
                else
                    cue_order(ii) = 5;
                end
            end
        elseif ii > design.pre_start  && ii <= design.pre_end
            for jj = 1:numel(design.pre_end - design.pre_start)
                if rand < .5 % Post cues
                    cue_order(ii) = 3;
                else
                    cue_order(ii) = 7;
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
        switch design.block
            case 0 
                cues = ones(trials,1);
                cues(1:round(trials*cue_ratio)) = 2; % Pre and Post, Low
                cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = 1; % Just Post, Low
                cues(2*round(trials*cue_ratio)+1:3*round(trials*cue_ratio)) = 3; % Just Pre, Low
                cues(3*round(trials*cue_ratio)+1:4*round(trials*cue_ratio)) = 0; % Null, Low
                cues(4*round(trials*cue_ratio)+1:5*round(trials*cue_ratio)) = 4; % null, High
                cues(5*round(trials*cue_ratio)+1:6*round(trials*cue_ratio)) = 5; %  Post, High
                cues(6*round(trials*cue_ratio)+1:7*round(trials*cue_ratio)) = 6; % Pre and Post, High
                cues(7*round(trials*cue_ratio)+1:end) = 7; % Pre, High
                order = randperm(trials);
                cue_order = cues(order);
            case 1
                cue_ratio = cue_ratio*2;
                switch data.block_type{iBlock}
                    case {'LN'}
                        prepost = 2;
                        jpost = 1;
                        jpre = 3;
                        null = 0;
                    case {'HN'}
                        prepost = 6;
                        jpost = 5;
                        jpre = 7;
                        null = 4;
                end
                cues = ones(trials,1);
                cues(1:round(trials*cue_ratio)) = prepost; % Pre and Post, Low
                cues(round(trials*cue_ratio)+1:2*round(trials*cue_ratio)) = jpost; % Just Post, Low
                cues(2*round(trials*cue_ratio)+1:3*round(trials*cue_ratio)) = jpre; % Just Pre, Low
                cues(3*round(trials*cue_ratio)+1:4*round(trials*cue_ratio)) = null; % Null, Low
                order = randperm(trials);
                cue_order = cues(order);
        end
    
end