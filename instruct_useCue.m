function instruct_useCue( screen,params,design,ring)

text = 'The cue hints at the likely orientation of the ellipse in the trial.';
text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nThe thicker parts at the center of the cue suggest the most likely orientation'];
text = [text '\n\nAs the cue gets thinner, the corresponding orientations become less likely.'];
%text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Press SPACE to continue'];
ypos = .25;

params.stim_type = design.stim;
params.roundness = 2.5;
stim = stim_info(screen,params);

params.cue_instruct = 2;
params.trial_mean   = 67;
params.pre_cue      = 1;
params.post_cue     = 1;
params.width        = design.width(1);
params.instruct     = 1;
params.instruct_mean = 67;
text_size = 30;

[arc, arc_mean]     = drawarc(screen,design,params);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

t_start = tic();
time_step = 0;
while 1
    
    t_loop = toc(t_start);
    
    if t_loop > .25 
        params.instruct_mean = params.instruct_mean;
        time_step = 0;
    elseif t_loop >.1 || time_step == 0
        new_val = randn*params.width + arc_mean*180/pi;
        params.instruct_mean = new_val;
        t_start = tic(); 
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