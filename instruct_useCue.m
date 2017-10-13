function instruct_useCue( screen,params,design,ring,instructNo)

switch instructNo
    case 1
        text = 'The cue hints at the likely orientation of the ellipse in the trial.';
        text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe thicker parts at the center of the cue suggest the most likely orientation.'];
        text = [text '\n\nAs the cue gets thinner, the corresponding orientations become less likely.'];
        ypos = .25;
        time_hold = .25;
        time_switch = 0.;
    case 2
        text = 'The ellipse orientation will be within the cue range across all trials.';
        text = [text '\n\nThe following animation shows example ellipse orientations across trials.'];
        text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nAs you can see, the ellipse is oriented more often towards the thicker center,'];
        text = [text '\n\nand less often towards the thinner portions of the cue.'];
        ypos = .20;
        time_hold = .25;
        time_switch = 0.;
    case 3
        text = 'This means that, on most trials, the ellipse will be oriented';
        text = [text '\n\nnot far from the center of the cue.'];
        text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nRemember, the above ellipse can be either narrower or rounder.'];
        ypos = .20;
    case 4
        text = 'However, the ellipse can occasionally point towards the ends of the cue.';
        text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nRemember, the above ellipse can be either narrower or rounder.'];
        ypos = .25;
end

stan_ori = 67;

switch instructNo
    case {1 2}
        params.cue_instruct = 1;
        params.instruct     = 1;
        params.instruct_mean = stan_ori;
        params.trial_mean   = stan_ori;
    case 3
        params.cue_instruct = 2;
        params.instruct = 1;
        params.instruct_mean = stan_ori;
        params.trial_mean = stan_ori;
    case 4
        params.cue_instruct = 3;
        params.instruct =1;
        params.instruct_mean = stan_ori;
        params.trial_mean = stan_ori;
end

params.stim_type = design.stim;

params.pre_cue      = 1;
params.post_cue     = 1;
text_size = 30;
params.width        = design.width(1);
[arc, arc_mean]     = drawarc(screen,design,params);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

t_start = tic();
time_step = 0;
switch instructNo
    case {1 2}
        while 1

            t_loop = toc(t_start);

            if t_loop > time_hold 
                params.instruct_mean = params.instruct_mean;
                time_step = 0;
                t_start = tic(); 
            elseif t_loop > time_switch && time_step == 0
                if rand < .5
                    params.roundness = design.roundness(1);
                else
                    params.roundness = design.roundness(2);
                end
                new_val = randn*params.width + arc_mean*180/pi;
                params.instruct_mean = new_val;
                time_step = 1;
            end
            stim = stim_info(screen,params);

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

            % Draw all the text
            Screen('TextSize', screen.window,text_size);
            DrawFormattedText(screen.window, text,...
                'center', screen.Ypixels * ypos, screen.white);

            % Flip to the screen
            screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

            if KbCheck
                break;
            end
            WaitSecs(.001);
        end
    case {3 4}
        while 1
%             if rand < .5
                params.roundness = design.roundness(1);
%             else
%                 params.roundness = design.roundness(2);
%             end
            stim = stim_info(screen,params);
            Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
            Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
            Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
            Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
            switch params.stim_type
                case 'ellipse'
                    drawellipse(screen, stim, params,[],[],design,[]);
                case 'gabor'
                    drawgabor(screen, stim, params,[],[],design,[]);
            end
            Screen('FillOval', screen.window, ring.color, ring.allRects);

            % Draw all the text
            Screen('TextSize', screen.window,text_size);
            DrawFormattedText(screen.window, text,...
                'center', screen.Ypixels * ypos, screen.white);

            % Flip to the screen
            screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

            if KbCheck
                break;
            end
            WaitSecs(.001);
        end
end
screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

% Unrestricts Keys
RestrictKeysForKbCheck([]);
end