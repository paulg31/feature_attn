function instruct_progress(screen,ring,design )
text = 'A progress bar will be present at he bottom of the screen during each block.';
text = [text '\n\nThe bar begins on the left side of the screen and ends on the right.'];
text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nIt will depict how close you are to the end of the block.'];
text_size = 30;
ypos = 0.15;
time_hold = .5;
time_switch = 0.;
stan_ori = 67;
params.cue_instruct = 1;
params.instruct     = 1;
params.instruct_mean = stan_ori;
params.trial_mean   = stan_ori;
params.stim_type = design.stim;
params.roundness = 2.5;
params.pre_cue      = 0;
params.post_cue     = 0;
params.width        = design.width(1);
[arc, arc_mean]     = drawarc(screen,design,params);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

params.instruct_mean = 67;
params.stim_type = design.stim;
params.roundness = 2.5;
params.instruct = 1;

t_start = tic();
time_step = 0;
stim = stim_info(screen,params);
iBlock = 5;
trial = 0;
while 1

            t_loop = toc(t_start);

            if t_loop > time_hold 
                trial = trial;
                time_step = 0;
                t_start = tic();
            elseif t_loop > time_switch && time_step == 0
                new_val = trial+8;
                trial = new_val;
                if trial > 136
                    trial = 0;
                end
                time_step = 1;
            end

            Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
            Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
            Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
            Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
            switch params.stim_type
                case 'ellipse'
                    drawellipse(screen, stim, params,[]);
                case 'gabor'
                    drawgabor(screen, stim, params,[]);
            end
            Screen('FillOval', screen.window, ring.color, ring.allRects);
            
            progress_bar( screen, design,trial,iBlock)
            
            % Draw all the text
            Screen('TextSize', screen.window,text_size);
            DrawFormattedText(screen.window, text,...
                'center', screen.Ypixels * ypos, screen.white);
            
            % Flip to the screen
            Screen('Flip', screen.window);

            if KbCheck
                break;
            end
            WaitSecs(.001);
end