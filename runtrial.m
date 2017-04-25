function runtrial( screen, trial_mean)
showinstructions(0,screen);
WaitSecs(.5);
[arc] = drawarc( screen,trial_mean );

Screen('FillPoly', screen.window, screen.white, arc.newpolyPoints);
Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2);  
Screen('Flip', screen.window, .5*screen.ifi);

WaitSecs(.5)

gabor = stim_info(screen);
WaitSecs(.5);

stimulus(screen, gabor,trial_mean);
WaitSecs(.5);

showinstructions(1,screen);
WaitSecs(.5); 

mousetracking(screen,trial_mean,arc);
WaitSecs(.5);
end

