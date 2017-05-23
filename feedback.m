function [ point_totes ] = feedback( design, responseAngle,iBlock,screen)
    sigma       = 10;%some value?
    expo        = ((responseAngle-design.trial_mean)^2)/(2*sigma^2);
    points_prob = exp(-expo);
    point_totes = round(10*points_prob);
    
    % Display feedback for train block
    if iBlock == 1
        
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
            'center', screen.Ypixels * 0.4, screen.white);

        %Flip to Screen
        Screen('Flip', screen.window);

        WaitSecs(screen.feedback_time);
    end
end

