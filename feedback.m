function [ point_totes,resp_error] = feedback( params, responseAngle, screen, bar,ring,design,data, iBlock)
    
    if data.block_type{iBlock} ==  'A' 
        sigma = design.target_SDerror*design.pointsigma_mult;
    elseif data.block_type{iBlock} ==  'T'
        sigma = design.target_SDerror*design.pointsigma_mult;
    else
        sigma = design.pointsigma_mult*design.width(1);
    end
    
    vals        = [responseAngle-180-params.trial_mean responseAngle-params.trial_mean responseAngle+180-params.trial_mean];
    error       = min(abs(vals));
    expo        = ((error)^2)/(2*sigma^2);
    points_prob = exp(-expo);
    point_totes = round(10*points_prob);
    resp_error  = vals(find(abs(vals)==error));
        
    % Bar Info
    bar.texturerect_true = ones(screen.bar_width,screen.bar_height).*screen.black;
    bar.recttexture_true = Screen('MakeTexture',screen.window,bar.texturerect_true);

    % Grammar
    if point_totes == 1
        form = ' point';
    else
        form = ' points';
    end

    % Display Text
    text = [num2str(point_totes) form];
    Screen('TextSize', screen.window, screen.text_size);
    DrawFormattedText(screen.window,text,...
        'center', screen.Ypixels * 0.3, screen.white);
    Screen('DrawTexture', screen.window, bar.recttexture, [], [], -responseAngle);
    Screen('DrawTexture', screen.window, bar.recttexture_true, [], [], -params.trial_mean);

    %Flip to Screen
    Screen('FillOval', screen.window, ring.color, ring.allRects);
    Screen('Flip', screen.window);
    WaitSecs(screen.feedback_time);
end