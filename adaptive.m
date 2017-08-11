function [params,design,adapt,target_end,trial,stop_trial,back_count] = adaptive(resp_error,design,params,trial,data,adapt,target_end,screen,stop_trial,back_count)

wide_ratio = design.wide_ratio;

if trial >= 300 || back_count == 3
        showinstructions(4,screen,1)
end

if adapt == 1
    if trial <= 100
        round_change = 2;
    else
        round_change = 1;
    end

    % Check response to see if it is greater than target_error
    if design.med2sd*abs(resp_error) <= wide_ratio*design.target_error
        % If less error, increase roundness
        design.roundness(1) =  design.roundness(1)+round_change;
    else 
        % If error is high, decrease roundness
        design.roundness(1) = design.roundness(1)-round_change;
    end
    adapt = 1;
    
    if trial > 100 && mod(trial,10) == 0
              
       range_check = [trial - 19:trial];
       recent_error = design.med2sd*median(abs(data.mat{2}(range_check,5)));
       
       if recent_error <= (wide_ratio+0.25) *design.target_error && recent_error >= (wide_ratio-0.25)*design.target_error
            showinstructions(2,screen,1)
            design.roundness(1) = mean(design.mat{2}(range_check,5));
            stop_trial = trial;
            target_end = stop_trial + 30;
            adapt = 2;
            
       end
    end
end
    
if adapt == 2
    adapt = 2;
    if trial == target_end
        width_check = design.med2sd*median(abs(data.mat{2}([end-49:end],5)));
        if width_check <= (wide_ratio+.5)*design.target_error && width_check >= (wide_ratio-.5)*design.target_error
            showinstructions(2,screen,1)
            design.width(1)     = design.target_error;
            design.width(2)     = width_check;
            adapt = 0;
        else
            data.mat{2}([stop_trial:end],:) = [];
            showinstructions(3,screen,1)
            trial = stop_trial;
            adapt = 1;
            back_count = back_count + 1;
        end
    end
end