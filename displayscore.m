function displayscore(total,completion,screen,data, avg_points)

%First Part of Message
text = ['Score in this block: ' num2str(total)];
if ~isempty(avg_points)
    text = [text '\n\n\n Average points per block: ' num2str(round(avg_points))];
end
text = [text '\n\n\nExperiment completed: ' num2str(round(completion*100)) '%'];
text = [text '\n\n\n\n Press SPACE to continue'];

% Draw text
Screen('TextSize', screen.window, screen.text_size);
DrawFormattedText(screen.window,text,...
    'center', screen.Ypixels * 0.4, screen.white);

% Flip to Screen
screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);
KbWait([],2);
screen.vbl = Screen('Flip', screen.window, screen.vbl + (screen.waitfr - screen.frame_diff) * screen.ifi);
RestrictKeysForKbCheck([]);