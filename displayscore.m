function displayscore(total,completion,screen,ring)

%First Part of Message
text = ['Score in this block: ' num2str(total)];
text = [text '\n\n\nExperiment completed: ' num2str(completion*100,'%.1f') '%'];
text = [text '\n\n\n\n Press SPACE to continue'];

% Draw text
Screen('TextSize', screen.window, screen.text_size);
DrawFormattedText(screen.window,text,...
    'center', screen.Ypixels * 0.4, screen.white);

% Flip to Screen
Screen('Flip', screen.window);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);
KbWait([],2);
Screen('Flip', screen.window);
RestrictKeysForKbCheck([]);