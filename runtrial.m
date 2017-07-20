function [point_totes,mouse_start,responseAngle,resp_error,arc_mean] = runtrial( screen, design,iBlock,params)

% Draw fixation cross
Screen('DrawTexture', screen.window, screen.cross, [], [], 0); 

% Flip to the screen
Screen('Flip', screen.window);

% Wait
fixDuration = screen.fixationdur*(1+screen.jitter*(2*rand()-1));
WaitSecs(fixDuration);

% Get arc info
[arc,arc_mean] = drawarc( screen,design,params );

% Draw the cues: main arc, gray cover, main arc on opp side, cover on opp
% side
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.polyopp.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.coveropp.pre);

% Cross and flip
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);
Screen('Flip', screen.window);
WaitSecs(screen.pre_stim);

switch params.stim_type
    case 'gabor'
        
        % Get gabor params
        params.contast  = design.contrasts(params.index);    
        stim            = stim_info(screen,params);
        drawgabor(screen,stim,params);
        
    case 'ellipse'
        
        % Get gabor params
        params.roundness = design.roundness(params.index);
        stim = stim_info(screen,params);
        drawellipse(screen,stim,params);
end

% KbWait;
WaitSecs(screen.stim_duration);

% Dot as same color as background, wait screen 
Screen('DrawDots',screen.window,[screen.xCenter screen.yCenter],2,screen.bgcolor,[],2)
Screen('Flip', screen.window);
WaitSecs(screen.stim_post);

% Begin response
[responseAngle, mouse_start,bar] = mousetracking(screen,arc);

% Get points from response, show feedback during train
[ point_totes,resp_error] = feedback( params, responseAngle, screen, bar);

WaitSecs(screen.betweentrials);
end