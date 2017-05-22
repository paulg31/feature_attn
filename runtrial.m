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
if design.pre_cue == 1
    Screen(arc.type2draw, screen.window, screen.white, arc.poly);
    Screen(arc.type2draw, screen.window, screen.bgcolor, arc.cover);
    Screen(arc.type2draw, screen.window, screen.white, arc.polyopp);
    Screen(arc.type2draw, screen.window, screen.bgcolor, arc.coveropp);
end


% Cross and flip
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);
Screen('Flip', screen.window);
WaitSecs(fixDuration);

% Get gabor params
gabor = stim_info(screen);
WaitSecs(fixDuration);

% Draw Gabors
stimulus(screen, gabor,design,params);
%KbWait;
WaitSecs(fixDuration);

[responseAngle, mouse_start] = mousetracking(screen,arc,design);
WaitSecs(.5);

[ point_totes ] = feedback( design, responseAngle);
WaitSecs(.5);

end

