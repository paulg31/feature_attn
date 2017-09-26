function progress_bar( screen, design,trial,iBlock)

progress = (trial-1)/design.numtrials(iBlock);
p_W = 3;
px_bot = 10;
p_S = [0 screen.windowRect(4)-px_bot]; % x start and y strat for progress bar
p_E = [progress*screen.windowRect(3) p_S(2)];
Screen('DrawLine',screen.window,screen.white,p_S(1),p_S(2),p_E(1),p_E(2),p_W);
end