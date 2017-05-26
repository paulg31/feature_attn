function [point_totes,mouse_start,responseAngle] = runtrial( screen, design,iBlock,params)

% Draw fixation cross
Screen('DrawTexture', screen.window, screen.cross, [], [], 0); 

% Flip to the screen
Screen('Flip', screen.window);

% Wait
fixDuration = screen.fixationdur*(1+screen.jitter*(2*rand()-1));
WaitSecs(fixDuration);

% Get arc info
arc = drawarc( screen,design,params );

% Draw the cues: main arc, gray cover, main arc on opp side, cover on opp
% side
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.polyopp.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.coveropp.pre);

% Cross and flip
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);
Screen('Flip', screen.window);
WaitSecs(fixDuration);

% Get gabor params
gabor = stim_info(screen);

% Draw Gabors
stimulus(screen, gabor,design,params);

% KbWait;
WaitSecs(screen.stim_duration);

% Begin response
[responseAngle, mouse_start,bar] = mousetracking(screen,arc);

% Get points from response, show feedback during train
[ point_totes ] = feedback( params, responseAngle,iBlock,screen,bar);

WaitSecs(screen.betweentrials);
end

