function [design] = shuffle_blocks( design, sessionNo, resultsFolder, subjId)
% Block Order
    perm_order = design.types(3:numel(design.types));
    design.types = [1 2];

        % Shuffle test blocks
            redo = 1;
            while redo == 1
                perm = perm_order(randperm(numel(perm_order)));
                perm2 = perm_order(randperm(numel(perm_order)));
                if perm(2) == perm2(1) % add in a ~ if blocks are added that are not just HN
                    redo = 0;
                end
            end
            
            if sessionNo == 1
                design.types = [design.types perm perm2];
                design.trial_nums   = design.s1_trials;
            else
                prev_File          = [resultsFolder,'Subj',subjId,'_Session'...
                                num2str(sessionNo-1) '_data.mat'];
                load(prev_File)
                design.types = [perm perm2];
                design.trial_nums   = design.other_trials;
            end
          
end

