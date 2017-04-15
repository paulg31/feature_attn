function showinstructions(type,screen)
% Show instructions on screen, wait for keypress to continue

switch type
    
    case 0  % Begin the experiment    
        text = 'Welcome to the Visual Perception Experiment';
        ypos = 0.4;
    
    case 1  % Counter-Clockwise
        text = 'Which target is closest to the vertical orientation?';
        % text = [text '\n\n\n Which target is farther counter-clockwise?'];
        text = [text '\n\n\n\n\n Press A if Left Target'];
        text = [text '        Press L if Right Target'];
        text = [text '\n\n\n\n\n Press SPACE for Wager'];
        ypos = 0.25;
        
    case 2  % Left/right
        text = 'Left/Right Task';
        text = [text '\n\n\n Press Z if Left'];
        text = [text '\n\n\n Press M if Right'];
        ypos = 0.25;
        
    case 3  % Reliability discrimination
        switch screen.stimulusType
            case 'gabor'
                text = 'Contrast Task';
                text = [text '\n\n\n Press Q if 1st target has higher contrast'];
                text = [text '\n\n\n Press P if 2nd target has higher contrast'];
                ypos = 0.25;                
        end
    case 4 %Break Time
        text = 'Break time';
        ypos = .4;
        
    otherwise
        text = [];
    
end

if ~isempty(text)
    text = [text '\n\n\n\n Press SPACE to continue'];
    
    % Draw all the text
    Screen('TextSize', screen.window, screen.text_size);
    DrawFormattedText(screen.window, text,...
        'center', screen.Ypixels * ypos, screen.white);

    % Flip to the screen
    Screen('Flip', screen.window);

    % Enable only SPACE to continue
    RestrictKeysForKbCheck(32);

    % Wait for key press to move on
    KbWait([],2);
    Screen('Flip', screen.window);

    % Unrestricts Keys
    RestrictKeysForKbCheck([]);
end