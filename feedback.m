function [ point_totes,resp_error] = feedback( params, responseAngle, screen, ring,design,data, iBlock,trial)
    
    if design.cue_order{iBlock}(trial) < 4
            idx_val = 1;
    else
            idx_val = 2;
    end
    
    sigma = design.pointsigma_mult(idx_val)*design.width(idx_val);
    vals        = [responseAngle-180-params.trial_mean responseAngle-params.trial_mean responseAngle+180-params.trial_mean];
    error       = min(abs(vals));
    expo        = ((error)^2)/(2*sigma^2);
    points_prob = exp(-expo);
    point_totes = round(10*points_prob);
    resp_error  = vals(find(abs(vals)==error));

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
    true_angle = params.trial_mean*pi/180;
    response_angle = responseAngle *pi/180;
    xy_true = [screen.bar_height/2*cos(-true_angle) -screen.bar_height/2*cos(-true_angle);screen.bar_height/2*sin(-true_angle) -screen.bar_height/2*sin(-true_angle)];
    xy_resp = [screen.bar_height/2*cos(-response_angle) -screen.bar_height/2*cos(-response_angle);screen.bar_height/2*sin(-response_angle) -screen.bar_height/2*sin(-response_angle)];
    Screen('BlendFunction',screen.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,[]);
    Screen('DrawLines',screen.window,xy_resp,screen.bar_width,screen.lesswhite,[screen.xCenter screen.yCenter],1);
    Screen('DrawLines',screen.window,xy_true,screen.bar_width,screen.black,[screen.xCenter screen.yCenter],1);
    
%     Screen('DrawTexture', screen.window, bar.recttexture, [], [], -responseAngle);
%     Screen('DrawTexture', screen.window, bar.recttexture_true, [], [], -params.trial_mean);

    %Flip to Screen
    progress_bar( screen, design,trial,iBlock )
    Screen('FillOval', screen.window, ring.color, ring.allRects);
    Screen('Flip', screen.window);
    WaitSecs(screen.feedback_time);
end