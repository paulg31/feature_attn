function showinstructions(type,screen, iBlock)
% Show instructions on screen, wait for keypress to continue
% Need to change these to go along with experiment

switch type
    
    case 0  % Begin the experiment    
        text = 'Welcome to the Visual Perception Experiment';
        ypos = 0.4;
    
    case 1  % Counter-Clockwise
        text = ['Block ' num2str(iBlock) ' starting'];
        ypos = 0.4;
        
    case 2  % Next Block
        text = 'next';
        ypos = 0.1;
        
    case 3
        text = 'back';
        ypos = .25;
    case 4
        text = 'STOP';
        text = [text '\nPlease find the experimenter'];
        text = [text '\nthank you'];
        ypos = .25;
        
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