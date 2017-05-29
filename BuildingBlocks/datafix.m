% Gets the errors for the first dataset since this was not done correclty
% in the first run. For the high contrast, blocks are [4 5], for low we
% have [2 3]. Line 18 needs to be changed to diffow so that the errors for
% the low contrat blocks are saved.

blocks = [4 5];
count = 1;
sigma = 10;
for iblock = 1:numel(blocks)
    for trial = 1:150
        responseAngle = data.mat{blocks(iblock)}(trial,2);
        params.trial_mean = data.mat{blocks(iblock)}(trial,4);
        vals = [responseAngle-180-params.trial_mean responseAngle-params.trial_mean responseAngle+180-params.trial_mean];
        error = min(abs(vals));
        expo        = ((error)^2)/(2*sigma^2);
        points_prob = exp(-expo);
        point_totes = round(10*points_prob);
        diffhigh(count) = vals(find(abs(vals)==error));% Chnage this to difflow
        count = count +1;
    end
end