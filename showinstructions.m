function showinstructions(type,screen, iBlock,design,params,ring,trial)
% Show instructions on screen, wait for keypress to continue

params.cue_instruct = 1;
params.trial_mean = 67;
params.pre_cue = 1;
params.post_cue = 1;
params.width = design.width(1);
[arc, arc_mean] = drawarc(screen,design,params);

switch type
    
    case 0  % Begin the experiment    
        text = 'Welcome to the Visual Perception Experiment';
        ypos = 0.4;
        text_size = screen.text_size;
        V_spacing = 1;
    
    case 1  % Counter-Clockwise
        text = ['Block ' num2str(iBlock) ' starting'];
        ypos = 0.4;
        text_size = screen.text_size;
        V_spacing = 1;
        
    case 2  % Next Block
        % Diff file
        
    case 3
        text = 'The experiment is composed of 6 blocks, about 150 trials each.'; %check for text length
        text = [text '\n\n\n\nYour total score for the block will appear at the end of that block.'];
        text = [text '\n\n\n\nThe percent completed of the whole experiment will show as well.'];
        text = [text '\n\n\n\nPlease ask the experimenter if you have questions.'];
        ypos = .15;
        text_size = 30;
        V_spacing = 1;
        
    case 4
        text = 'In the following practice trials, the cue will appear after the ellipse.';
        text = [text '\n\n\nPay attention to the cue!'];
        text = [text '\n\n\nThe cue will help you estimate the ellipse orientation, improving your score.'];
        ypos = .25;
        text_size = 30;
        V_spacing = 1;
        progress_bar( screen, design,trial,iBlock )
        
    case 5 
        text = 'In the following practice trials, the cue will appear briefly before the ellipse.';
        text = [text '\n\n\nPay attention to the cue!'];
        text = [text '\n\n\nThe cue will help you estimate the ellipse orientation, improving your score.'];
        ypos = .25;
        text_size = 30;
        V_spacing = 1;
        progress_bar( screen, design,trial,iBlock )
        
    case 6
        text = 'In the following practice trials, the same cue will appear both '; 
        text = [text '\nbefore and after the ellipse.'];
        text = [text '\n\nPay attention to the cue!'];
        text = [text '\n\nThe cue will help you estimate the ellipse orientation, improving your score.'];
        ypos = .25;
        text_size = 30;        
        V_spacing = 1.5;
        progress_bar( screen, design,trial,iBlock )
        
    case 7
        text = 'Congratulations, you completed the first three blocks!';
        text = [text '\n\n\n\nPlease call the experimenter to explain the rest of the experiment.'];
        ypos = .25;
        text_size = screen.text_size;
        V_spacing = 1;
        
    case 8
        text = 'In the rest of the experiment, you will still be asked to judge the orientation ';
        text = [text '\nof the ellipse, as you have done so far.'];
        text = [text '\n\n\n\n\n\n\n\n\n\nTrials now may also provide a visual cue, pictured above,'];
        text = [text '\nabout the ellipse orientation.\n\n\n\n\n\n'];
        ypos = .2;
        Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
        Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
        Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
        Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
        Screen('FillOval', screen.window, ring.color, ring.allRects);
        text_size = 30;
        V_spacing = 1.5;
        
    case 9 %UNUSED
        text = 'The cue hints at the likely orientation of the ellipse in the trial.';
        text = [text '\nThe thicker parts at the center of the arc suggest which way the ellipse was most likely oriented.'];
        text = [text '\nAs the arc gets thinner, the corresponding orientations become less likely.\n\n\n\n'];
        text_size = screen.text_size;
        ypos = .15;
        V_spacing = 1;
        
    case 10
        text = 'Now you have seen all types of trials in the experiment.';
        text = [text '\n\nDuring the experiment, the cue may appear (1) before, (2) after,'];
        text = [text '\n(3) both before and after, or (4) neither (like the first two blocks).'];
        text = [text '\n\n\n\n\n\n\n\nWhen the cue is absent, you will see a circle instead, which provides no'];
        text = [text '\nadditional information about the likely orientation of the ellipse.'];
        text = [text '\n\nPlease ask the experimenter if you have questions.'];
        ypos = .15;
        text_size = 30;
        params.cue_instruct = 1;
        params.trial_mean = 67;
        params.pre_cue = 0;
        params.post_cue = 0;
        params.width = design.width(1);
        [arc, arc_mean] = drawarc(screen,design,params);
        Screen(arc.type2draw.pre, screen.window, screen.lesswhite, arc.poly.pre);
        Screen(arc.type2draw.pre, screen.window, screen.bgcolor, arc.cover.pre);
        Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
        Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
        Screen('FillOval', screen.window, ring.color, ring.allRects);
        V_spacing = 1.5;
        
    case 11
        text = 'Welcome back!';
        text = [text '\n\nThe task remains the same as in the previous session.'];
        text = [text '\n\n\n\n\n\nRemember to pay attention to the cue!'];
        text = [text '\n\nThe cue will help you estimate the ellipse orientation, improving your score.'];
        text = [text '\n\n\n\n\n\n\nPlease ask now if you have any questions.'];
        ypos = .15;
        text_size = 30;
        V_spacing = 1;
        
    case 12
        text = 'You will now be presented with rounder ellipses.';
        text = [text '\n\nThe task remains the same, but may seem a bit harder.'];
        text = [text '\n\nDo your best!'];
        ypos = .3;
        text_size = 30;
        V_spacing = 1;
        
    case 13
        text = 'In this block, there will be no cues.';
        text = [text '\n\n\nThis might feel harder, but try to do you your best!'];
        ypos = .3;
        text_size = 30;
        V_spacing = 1;
        
    case 14
        
        text = 'In this block, cues will suggest the likely orientation of the ellipse.';
        text = [text '\n\n\nRemember to pay attention to the cue!'];
        text = [text '\n\n\nThe cue will help you estimate the ellipse orientation, improving your score.'];
        ypos = .3;
        text_size = 30;
        V_spacing = 1;
        
        
    otherwise
        text = [];
        
end

if ~isempty(text)
    
    if type == 0 || type == 1
        text = [text '\n\n\n\nPress SPACE to continue'];
%     else
%         text = [text '\n\n\n\n Press SPACE to continue'];
    end

    % Draw all the text
    Screen('TextSize', screen.window, text_size);
    DrawFormattedText(screen.window, text,...
        'center', screen.Ypixels * ypos, screen.white,[],[],[],V_spacing);
    
    % Flip to the screen
    screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

    % Enable only SPACE to continue
    RestrictKeysForKbCheck(32);
    
    if type == 7
        WaitSecs(1);
    end

    % Wait for key press to move on
    KbWait([],2);
    
    screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

    % Unrestricts Keys
    RestrictKeysForKbCheck([]);
end