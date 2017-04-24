function runtrial( screen, trial_mean)
showinstructions(0,screen);
WaitSecs(.5);
gabor = stim_info(screen);
stimulus(screen, gabor,trial_mean);
WaitSecs(.5);
drawarc( screen,trial_mean );
WaitSecs(.5);
showinstructions(1,screen);
WaitSecs(.5); 
mousetracking(screen) ;
WaitSecs(.5);
end

