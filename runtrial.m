function [point_totes] = runtrial( screen, trial_mean)
[arc] = drawarc( screen,trial_mean );

Screen('FillPoly', screen.window, screen.white, arc.newpolyPoints);
Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2);
Screen('FillPoly', screen.window, screen.white, arc.newpolyPointsop);
Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2op);
Screen('Flip', screen.window, .5*screen.ifi);
WaitSecs(.5)

gabor = stim_info(screen);
WaitSecs(.5);

stimulus(screen, gabor,trial_mean);
WaitSecs(.5);

[responseAngle, mouse_start] = mousetracking(screen,arc);
WaitSecs(.5);

[ point_totes ] = feedback( trial_mean,responseAngle);
WaitSecs(.5);
point_totes

end

