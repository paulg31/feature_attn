function [ design ] = shuffle_new( design, sessionNo,resultsFolder, subjId)
% session 1 = 4 intor blocks, LNC HNC [LN HN] -- same for everyone
% sessions 2+ = [LN HN] LNC HNC LNC HNC LNC HNC [LN HN] -- balanced

perm_order      = design.types(5:end);
perm            = perm_order;
design.types    = design.types(1:4);
starting_num    = numel(design.types);
b_value         = design.blocked;

if sessionNo == 1
    null_set        = design.session_trials/4;
    design.types    = [design.types perm perm];
    rest_trials     = repmat(design.session_trials-null_set,[1,(numel(design.types)-starting_num-numel(perm))]);
    null_trials     = repmat(null_set,[1,2]);
    design.trial_nums   = [design.intro_trials rest_trials null_trials];
else
    num_repeats = 6;
    num_cues = 4;
    null_set = (design.other_trials -(design.other_trials/4))*num_repeats/(num_cues-1)/num_cues;
    prev_File          = [resultsFolder,'Subj',subjId,'_Session'...
                                num2str(sessionNo-1) '_data.mat'];
    load(prev_File)
    switch b_value
        case 0
            design.types = repmat(perm,[1,5]);
        case 1
            rev_perm        = fliplr(perm);
            design.types    = repmat(rev_perm,[1,5]);
    end
    main_trials = repmat((design.other_trials/4*3),[1,numel(design.types)-4]);
    sand_trials = repmat(null_set,[1,2]);
    design.trial_nums   = [sand_trials main_trials sand_trials];
end

end