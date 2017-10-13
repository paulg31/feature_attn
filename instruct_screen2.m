function instruct_screen2( screen,ring,design )

text1 = 'After the ellipse disappears, you will be asked to estimate ';
text1 = [text1 '\nthe orientation of its longer axis.'];
text =  '\n\n\n\nMove the mouse left and right to move the white bar.';%match not move, at end: to the desired orientation.'];
text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\nClick the left mouse button to respond.'];
text = [text '\n\nA grid of dots will be present to serve as reference points.'];
text_size = 30;
ypos = 0.15;

params.instruct_mean = 67;
params.stim_type = design.stim;
params.roundness = 2.5;
params.instruct = 1;
RestrictKeysForKbCheck(32);
theta = (180-67)*pi/180;
xy = [screen.bar_height/2*cos(theta) -screen.bar_height/2*cos(theta);...
    screen.bar_height/2*sin(theta) -screen.bar_height/2*sin(theta)];

t_start = tic();
time_step = 0;
stim = stim_info(screen,params);

while 1
    
    t_loop = toc(t_start);
    
    if t_loop > .8
        
        % Draw Stimulus
        switch params.stim_type
            case 'ellipse'
                drawellipse(screen, stim, params,[]);
            case 'gabor'
                drawgabor(screen, stim, params,[]);
        end
       
        % Draw all the text
        Screen('TextSize', screen.window, text_size);
        DrawFormattedText(screen.window, text,...
            'center', screen.Ypixels * ypos, screen.white);
        DrawFormattedText(screen.window, text1,...
            'center', screen.Ypixels * ypos, screen.white,[],[],[],1.5);
        
        % Draw Response Bars
        Screen('BlendFunction',screen.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,[]);
        Screen('DrawLines',screen.window,xy,screen.bar_width,...
            screen.lesswhite,[screen.xCenter screen.yCenter],2);
        
        % Draw Grid
        Screen('FillOval', screen.window, ring.color, ring.allRects);

        % Flip to the screen
        screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
        t_start = tic();
        time_step = 0;
        
    elseif t_loop > .3 && time_step == 0
    
        % Draw text
        Screen('TextSize', screen.window, text_size);
        DrawFormattedText(screen.window, text,...
            'center', screen.Ypixels * ypos, screen.white);
        DrawFormattedText(screen.window, text1,...
            'center', screen.Ypixels * ypos, screen.white,[],[],[],1.5);
        
        % Draw Response Bars
        Screen('BlendFunction',screen.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,[]);
        Screen('DrawLines',screen.window,xy,screen.bar_width,...
            screen.lesswhite,[screen.xCenter screen.yCenter],2);
        
        % Draw Grid
        Screen('FillOval', screen.window, ring.color, ring.allRects);

        % Flip to the screen
        screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
        time_step = 1;
    end
    
    if KbCheck
       break;
    end

    WaitSecs(0.001);
end

screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

% Unrestricts Keys
RestrictKeysForKbCheck([]);
end