function [ point_totes ] = feedback( design, responseAngle)
    sigma       = 10;%some value?
    expo        = ((responseAngle-design.trial_mean)^2)/(2*sigma^2);
    points_prob = exp(-expo);
    point_totes = round(10*points_prob);
end

