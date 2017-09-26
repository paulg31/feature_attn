function [point_totes,mouse_start,responseAngle,resp_error,arc_mean,resp_time ] = runtrial( screen, design,params,ring, iBlock,data,trial)
% fixation for ~300ms
% cue right after for 300ms
% blank screen between pre cue and stim for 150ms
% stim for 50ms
% blank screen between stim and post cue for 300ms
% post cue and response bar until response
% feedback time for 1100ms
% iti 300 ms
params.cue_instruct = 0;

% Draw fixation cross
Screen('DrawTexture', screen.window, screen.cross, [], [], 0);
progress_bar( screen, design,trial,iBlock )
Screen('FillOval', screen.window, ring.color, ring.allRects);

% Flip to the screen
Screen('Flip', screen.window);

% Wait
fixDuration = screen.fixationdur*(1+screen.jitter*(2*rand()-1));
WaitSecs(fixDuration); %500 ms

% Get arc info
[arc,arc_mean] = drawarc( screen,design,params );

% Draw the cues: main arc, gray cover, main arc on opp side, cover on opp
% side
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.polyopp.pre);
Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.coveropp.pre);

% Cross and flip
progress_bar( screen, design,trial,iBlock )
Screen('FillOval', screen.window, ring.color, ring.allRects);
Screen('Flip', screen.window);
WaitSecs(screen.cue_duration); %300 ms

% Wait Screen
progress_bar( screen, design,trial,iBlock )
Screen('FillOval', screen.window, ring.color, ring.allRects);
Screen('Flip', screen.window);
WaitSecs(screen.stim_pre); %200 ms

switch params.stim_type
    case 'gabor'
        
        % Get gabor params
        params.contrast  = design.contrast(params.relType);    
        stim            = stim_info(screen,params);
        drawgabor(screen,stim,params,ring,trial,iBlock);
        
    case 'ellipse'
        
        % Get gabor params
        params.roundness = design.roundness(params.relType);
        stim = stim_info(screen,params);
        drawellipse(screen,stim,params,ring,trial,design,iBlock);
end

% KbWait;
WaitSecs(screen.stim_duration); % 50 ms

% Wait Screen
progress_bar( screen, design,trial,iBlock )
Screen('FillOval', screen.window, ring.color, ring.allRects);
Screen('Flip', screen.window);
WaitSecs(screen.stim_post);% 300 ms

% Begin response
[responseAngle, mouse_start,resp_time ] = mousetracking(screen,arc,ring,trial,design,iBlock);

% Get points from response, show feedback during train
[ point_totes,resp_error] = feedback( params, responseAngle, screen,ring,design,data, iBlock,trial);
%Screen('Close',bar.recttexture);
WaitSecs(screen.betweentrials); % 300 ms
end