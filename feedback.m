function [ point_totes ] = feedback( trial_mean,response_angle)
    sigma       = 10;%some value?
    expo        = ((response_angle-trial_mean)^2)/(2*sigma^2);
    points_prob = exp(-expo);
    point_totes = round(10*points_prob);
end

