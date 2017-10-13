function instruct_screen1( screen,design )

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

text = 'During the experiment, please keep your eyes on the fixation cross.';
text = [text '\n\n\n\n\n\n\nOn each trial, you will be presented with a randomly oriented ellipse.'];
text = [text '\n\n\n\n\n\n\nAll orientations along the circle have the same probability.'];
text = [text '\n\n\n\n\n\n\n Press SPACE to continue'];
ypos        = 0.15;
text_size   = 30;

base_rect   = [0 0 38 38];
dest_rect   = CenterRectOnPointd(base_rect,screen.xCenter,screen.yCenter-200);
params.add  = 0;
params.instruct_mean = 45;
params.stim_type = design.stim;
params.roundness = 2.5;
stim = stim_info(screen,params);
t_start = tic();
time_step = 0;

while 1
    t_loop = toc(t_start);
    
    if t_loop > .25 % Hold constant
        params.add = params.add;
        t_start = tic();
        time_step = 0;
    elseif t_loop > .1 && time_step == 0 % Shift orientation?
        params.add = 180*rand;
        time_step = 1;
    end

    Screen('DrawTexture', screen.window, screen.cross, [], dest_rect, 0);
    
    switch params.stim_type
        case 'ellipse'
            params.instruct = 1;
            drawellipse(screen, stim, params,[]);
            params.instruct = 2;
            drawellipse(screen, stim, params,[]);   
        case 'gabor'
            params.instruct = 1;
            drawgabor(screen, stim, params,[]);
            params.instruct = 2;
            drawgabor(screen, stim, params,[]);
            
    end
    
    % Draw all the text
    Screen('TextSize', screen.window, text_size);
    DrawFormattedText(screen.window, text,...
        'center', screen.Ypixels * ypos, screen.white);
    
    % Flip to the screen
    screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
    
    if KbCheck
        break;
    end

    WaitSecs(0.001);
end

% Flip Screen
screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

% Unrestricts Keys
RestrictKeysForKbCheck([]);

end