function [ design ] = adaptive_v2( trial, params, design, data)
    resp_error = data.mat{params.iblock}(trial,5);
    if trial <= 10
        round_change = 2;
    elseif trial > 10 && trial < 21
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
    
end