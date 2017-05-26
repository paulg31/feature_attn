function [ point_totes ] = feedback( params, responseAngle,iBlock,screen,bar)

    sigma       = 10;%some value?
    trials = [0 180 -180];
    for x = 1:numel(trials)
        expo        = ((responseAngle-trials(x)-params.trial_mean)^2)/(2*sigma^2);
        points_prob = exp(-expo);
        point_poss(x) = round(10*points_prob);
    end
    
    point_totes = max(point_poss);
    
    % Display feedback for train block
    if iBlock == 1
        
        % Bar Info
        bar.texturerect_true = ones(5,300).*screen.black;
        bar.recttexture_true = Screen('MakeTexture',screen.window,bar.texturerect_true);
        
        % Grammar
        if point_totes == 1
            form = ' point';
        else
            form = ' points';
        end
        
        % Display Text
        text = ['You recieved: ' num2str(point_totes) form];
        Screen('TextSize', screen.window, screen.text_size);
        DrawFormattedText(screen.window,text,...
            'center', screen.Ypixels * 0.3, screen.white);
        Screen('DrawTexture', screen.window, bar.recttexture, [], [], -responseAngle);
        Screen('DrawTexture', screen.window, bar.recttexture_true, [], [], -params.trial_mean);

        %Flip to Screen
        Screen('Flip', screen.window);

        WaitSecs(screen.feedback_time);
    end
end

