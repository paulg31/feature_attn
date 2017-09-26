function instruct_ellRound(screen,params,design,ring)

text = 'You have now seen both types of ellipses that will be present.';
text = [text '\n\nOn each trial, either a narrow or circular ellipse will appear.'];
text = [text '\n\nThis may make things harder, but try your best!'];

ypos = .15;
time_hold = .35;
time_switch = 0.;

stan_ori = 67;
params.cue_instruct = 1;
params.instruct     = 1;
params.instruct_mean = stan_ori;
params.trial_mean   = stan_ori;
params.stim_type = design.stim;

params.pre_cue      = 0;
params.post_cue     = 0;
text_size = 30;
params.width        = design.width(1);
[arc, arc_mean]     = drawarc(screen,design,params);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

t_start = tic();
time_step = 0;

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
            Screen('Flip', screen.window);

            if KbCheck
                break;
            end
            WaitSecs(.001);
        end
        
        
Screen('Flip', screen.window);
% Unrestricts Keys
RestrictKeysForKbCheck([]);
end