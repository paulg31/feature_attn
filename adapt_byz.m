function [data, design, trial_save] = adapt_byz(screen, params, data, design, ring, outputFile)
        adapt.go = 1;
        adapt.trial = 1;
        adapt.target_end = 5;
        adapt.back_count = 0;
        adapt.stop_trial = 5;
        adapt.cue_type = 0;
        while adapt.go == 1 || adapt.go == 2
            params.trial_mean = rand(1)*180;
            trial_start = GetSecs;
            
            switch params.stim_type
                case 'ellipse'
                    type_save = design.roundness(params.index);
                case 'gabor'
                    type_save = design.contrast(params.index);
            end
        
        % Pass info to runtrial
        [point_totes,mouse_start,responseAngle,resp_error,arc_mean,resp_time] = runtrial(screen,design,params,ring, params.iblock,data);

        trial_end = GetSecs;
        trial_dur = trial_end-trial_start;

        % save into mat
        data.mat{params.iblock}(adapt.trial,:) = [ ...
            adapt.trial, responseAngle, params.trial_mean, point_totes, resp_error,arc_mean*180/pi, params.cue_type, resp_time   ...
        ];
        
        design.mat{params.iblock}(adapt.trial,:) = [...
            adapt.trial, mouse_start(1), mouse_start(2), params.width, type_save, trial_dur ...
        ];
        
        trial_save = adapt.trial;
        block_save = params.iblock;
        % Save data at the end of each trial
        save(outputFile, 'data', 'design','trial_save','block_save');
        
        % Go through adaptive, update roundness
        [params, design, adapt] = adaptive(design,params,adapt,screen,data);
        
        adapt.trial = adapt.trial + 1;            
        end
end