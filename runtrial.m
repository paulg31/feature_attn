function [point_totes,mouse_start,responseAngle] = runtrial( screen, trial_mean)

% Draw fixation cross
Screen('DrawTexture', screen.window, screen.cross, [], [], 0); 

% Flip to the screen
Screen('Flip', screen.window);

% Wait
fixDuration = screen.fixationdur*(1+screen.jitter*(2*rand()-1));
WaitSecs(fixDuration);

arc = drawarc( screen,trial_mean );

Screen(arc.type2draw, screen.window, screen.white, arc.poly);
Screen(arc.type2draw, screen.window, screen.bgcolor, arc.cover);
Screen(arc.type2draw, screen.window, screen.white, arc.polyopp);
Screen(arc.type2draw, screen.window, screen.bgcolor, arc.coveropp);
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);
Screen('Flip', screen.window);

WaitSecs(.5)

gabor = stim_info(screen);
WaitSecs(.5);

stimulus(screen, gabor,trial_mean);
WaitSecs(1);

[responseAngle, mouse_start] = mousetracking(screen,arc);
WaitSecs(.5);

[ point_totes ] = feedback( trial_mean,responseAngle);
WaitSecs(.5);

end

