function [ design ] = adaptive_v2( trial, params, design, data)
    resp_error = data.mat{params.iblock}(trial,5);
    switch params.stim_type
        case 'ellipse'
            if trial <= design.twoStep
                round_change = 2;
            elseif trial > design.twoStep && trial <= design.oneStep
                round_change = 1;
            else
                round_change = .5;
            end

            % Check response to see if it is greater than target_error
            if design.med2sd*abs(resp_error) <= design.target_SDerror% will be set to 10 in feat_exp. really, it is 1.48*~6.whatevere
                % If less error, increase roundness
                design.roundness(1) =  design.roundness(1)+round_change;
            else 
                % If error is high, decrease roundness
                design.roundness(1) = design.roundness(1)-round_change;
            end

            design.roundness(1) = max(design.roundness(1),1);
            
        case 'gabor'
            
            if design.med2sd*abs(resp_error) <= design.target_SDerror
                design.contrast(1) =  design.contrast(1)*.9 ;
            else 
                design.contrast(1) = design.contrast(1)* 1.1;
            end
            
    end
    
end