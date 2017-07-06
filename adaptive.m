function [params,design,adapt] = adaptive(resp_error,design,params,trial,data)

    % Check response to see if it is greater than target_error
    if abs(resp_error) <= 2*design.adapt.target_error
        % If less error, increase roundness
        design.roundness(1) =  design.roundness(1)+.5;
    else 
        % If error is high, decrease roundness
        design.roundness(1) = design.roundness(1)-.5;
    end
    
    
    adapt = 1;
    % Check if error is in desired range after the 150th trial every 10
    % trials, end adapt block
   if trial >= 150 && mod(trial,10) == 0
       range_check = [trial - 5:trial];
        if median(abs(data.mat{2}(range_check,5))) <= 3*design.adapt.target_error && median(abs(data.mat{2}(range_check,5))) >= 2*design.adapt.target_error
            idx = diff(diff(design.mat{2}(:,5)) > 0) > 0;
            change = design.mat{2}(logical([0;0;idx]),5);
            design.roundness(1) = mean(change(numel(change)-5:numel(change)));
            adapt = 0;
        end
   end

end