function  [data, design, trial] = adapt_ott(screen, params, data, design,ring, trialStart, outputFile)

for trial = trialStart:design.numtrials(params.iblock)
        trial_start = GetSecs;
        params.trial_mean = rand(1)*180; % Random Orientation

        % determine what to save
        switch params.stim_type
            case 'ellipse'
                type_save = design.roundness(params.index);
            case 'gabor'
                type_save = design.contrast(params.index);
        end
        
        % Pass info to runtrial
        [point_totes,mouse_start,responseAngle,resp_error,arc_mean,resp_time ] = runtrial(screen,design,params, ring, params.iblock,data);
        
        trial_end = GetSecs;
        trial_dur = trial_end-trial_start;

        % save into mat
        data.mat{params.iblock}(trial,:) = [ ...
            trial, responseAngle, params.trial_mean, point_totes, resp_error,arc_mean*180/pi, params.cue_type, resp_time   ...
        ];
        
        design.mat{params.iblock}(trial,:) = [...
            trial, mouse_start(1), mouse_start(2), params.width, type_save,trial_dur ...
        ];
        
        block_save = params.iblock;
        % Save data at the end of each trial
        save(outputFile, 'data', 'design','trial','block_save');
        
        design = adaptive_v2(trial, params, design, data);
end

design = set_roundness(design, data,params);
end