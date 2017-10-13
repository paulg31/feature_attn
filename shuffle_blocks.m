function [design] = shuffle_blocks( design, sessionNo, resultsFolder, subjId)
% Shuffles the block order. Works better when all blocks to be shuffled are
% not the same.

% Block Order
    perm_order = design.types(5:numel(design.types)); % Blocks to permute
    perm = perm_order;
    design.types = [1 2 8 7]; % Starting blocks(training and intructions)
    starting_num = numel(design.types);
    b_value = design.blocked;
        % Shuffle test blocks
%             redo = 1;
%             while redo == 1
%                 perm = perm_order(randperm(numel(perm_order)));
%                 perm2 = perm_order(randperm(numel(perm_order)));
%                 if perm(2) == perm2(1) % add in a ~ if blocks are added that are not just LN
%                     redo = 0;
%                 end
%             end
            
            if sessionNo == 1
                design.types        = [design.types perm];% perm2];
                rest_trials         = repmat(design.session_trials,[1,numel(design.types)-starting_num]);
                design.trial_nums   = [design.intro_trials rest_trials];
                
            else
                prev_File          = [resultsFolder,'Subj',subjId,'_Session'...
                                num2str(sessionNo-1) '_data.mat'];
                load(prev_File)
                switch b_value
                    case 0
                        design.types = repmat(perm,[1,3]);%[perm perm perm];
                    case 1
                        rev_perm        = fliplr(perm);
                        design.types    = repmat(rev_perm,[1,3]);%rev_perm rev_perm rev_perm];
                end
                design.trial_nums   = [repmat(design.other_trials,[1,numel(design.types)])];
            end
          
end