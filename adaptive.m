function [params,design,adapt] = adaptive(resp_error,design,params,trial,data)

    % Check response to see if it is greater than target_error
    if abs(resp_error) <= 2*design.adapt.target_error
        % If less error, increase roundness
        design.roundness(1) =  design.roundness(1)+5;
    else 
        % If error is high, decrease roundness
        design.roundness(1) = design.roundness(1)-5;
    end
    
    adapt = 1;
    
    % Check if error is in desired range after the 150th trial every 10
    % trials, end adapt block
   if trial >= 100 && mod(trial,10) == 0
       range_check = [trial - 5:trial];
        if design.med2sd*median(abs(data.mat{2}(range_check,5))) <= 2.25*design.adapt.target_error && design.med2sd*median(abs(data.mat{2}(range_check,5))) >= 1.75*design.adapt.target_error
            idx = diff(diff(design.mat{2}(:,5)) > 0) > 0;
            change = design.mat{2}(logical([0;0;idx]),5);
            design.roundness(1) = mean(change(numel(change)-5:numel(change)));
            
            c_errors = data.mat{2}(logical([0;0;idx]),5);   % errors at change points
            err_search = c_errors(end-5);                   % error corresponding to first change point
            err_start = find(data.mat{2}(:,5)==err_search); % trial number to start computing median error at
            
            design.width(1)     = design.adapt.target_error;
            design.width(2)     = design.med2sd*median(abs(data.mat{2}([err_start:end],5))); % compute median error, convert, set to wide cue width
            adapt = 0;
        end
   end

end