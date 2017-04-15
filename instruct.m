function instruct(design,wager)
screen = design.screen;

switch wager
    case 0
        text = 'L                      R';
        ypos = 0.47;
        RestrictKeysForKbCheck([76 65]);
    case 1
        text = 'L                      R';
        text = [text '\n\n\n\n SPACE'];
        ypos = 0.47;
        RestrictKeysForKbCheck([76 65 32]);
end

    % Draw fixation cross
    Screen('DrawTexture', screen.window, screen.cross, [], [], 0); 
        
    % Draw all the text
    Screen('TextSize', screen.window, screen.text_size);
    DrawFormattedText(screen.window, text,...
        'center', screen.Ypixels * ypos, screen.white);

    % Flip to the screen
    Screen('Flip', screen.window);
    
end