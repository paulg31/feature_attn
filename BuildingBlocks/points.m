dist_sigma = 5;
trial_mean = 98.43;
response_angle = 90;
sigma = dist_sigma;
%const = 1/sqrt(2*pi*sigma^2);
expo = ((response_angle-trial_mean)^2)/(2*sigma^2);
points_prob = exp(-expo);
point_totes = round(10*points_prob)