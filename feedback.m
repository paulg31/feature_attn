function [ point_totes,resp_error] = feedback( params, responseAngle,iBlock,screen,bar,design)

    sigma       = 10;%some value?
    %trials = [0 180 -180];
    %for x = 1:numel(trials)
        vals = [responseAngle-180-params.trial_mean responseAngle-params.trial_mean responseAngle+180-params.trial_mean];
        error = min(abs(vals));
        expo        = ((error)^2)/(2*sigma^2);
        points_prob = exp(-expo);
        point_totes = round(10*points_prob);
        resp_error = vals(find(abs(vals)==error));
    %end
    %point_totes = max(point_poss);
    %responseAngle = responseAngle - trials(find(point_poss==point_totes));
    
    % Display feedback for train block
    if design.types(iBlock) == 1 || design.types(iBlock) == 3
        
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

