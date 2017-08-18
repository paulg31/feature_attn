function [params, design, adapt] = adaptive(design,params,adapt,screen,data)
resp_error = data.mat{params.iblock}(adapt.trial,5);
wide_ratio = 1;%design.wide_ratio;

if adapt.trial >= 300 %|| back_count == 3
        showinstructions(4,screen,1)
end

if adapt.go == 1
    if adapt.trial <= params.highstep_trials
        round_change = 2;
    else
        round_change = 1;
    end

    % Check response to see if it is greater than target_error
    if design.med2sd*abs(resp_error) <= wide_ratio*design.target_SDerror
        % If less error, increase roundness
        design.roundness(1) =  design.roundness(1)+round_change;
    else 
        % If error is high, decrease roundness
        design.roundness(1) = design.roundness(1)-round_change;
    end
    adapt.go = 1;
    
    if adapt.trial > params.start_check && mod(adapt.trial,params.mod_val) == 0 %trial > 100, mod 10 not 5
              
       range_check = [adapt.trial - (params.move_wind_size-1) : adapt.trial];%minus 49(or 19) not 9
       recent_error = design.med2sd*median(abs(data.mat{params.iblock}(range_check,5)));
       
       if recent_error <= design.target_upperbound*design.target_SDerror && recent_error >= design.target_lowerbound*design.target_SDerror
            showinstructions(2,screen,1)
            design.roundness(1) = mean(design.mat{params.iblock}(range_check,5));% Sets roundness
%             adapt.stop_trial = adapt.trial;
%             adapt.target_end = adapt.stop_trial + 3; % 30 not 3
            adapt.go = 0;
       end
    end
end
    
% if adapt.go == 2
%     adapt.go = 2;
%     if adapt.trial == adapt.target_end
%         width_check = design.med2sd*median(abs(data.mat{params.iblock}([end-9:end],5)));% 49 not 9
%         if width_check <= (wide_ratio+.5)*design.target_SDerror && width_check >= (wide_ratio-.5)*design.target_SDerror
%             showinstructions(2,screen,1)
%             design.width(1)     = design.target_SDerror;
%             design.width(2)     = width_check;
%             adapt.go = 0;
%         else
%             data.mat{params.iblock}([adapt.stop_trial:end],:) = [];
%             showinstructions(3,screen,1)
%             adapt.trial = adapt.stop_trial;
%             adapt.go = 1;
%             adapt.back_count = adapt.back_count + 1;
%         end
%     end
end