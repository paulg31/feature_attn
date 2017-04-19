clc;
clearvars;

circr = @(radius,rad_ang)  [radius*cos(rad_ang);  radius*sin(rad_ang)];         % Circle Function For Angles In Radians
circd = @(radius,deg_ang)  [radius*cosd(deg_ang);  radius*sind(deg_ang)];       % Circle Function For Angles In Degrees
N = 25;                                                         % Number Of Points In Complete Circle

arcb = pi/4;
arcend = -pi/4;
for ii = 1.5:.01:1.8
    radius = ii;
    r_angl = linspace(arcb,arcend,N);
    xy_r = circr(radius,r_angl);    
    arcb = arcb - pi/72;
    arcend = arcend - pi/72;
end
figure(1)
plot(xy_r(1,:), xy_r(2,:), 'b-')                                % Draw An Arc
axis([-1.25*radius  1.25*radius    0  1.25*radius])             % Set Axis Limits
axis equal                                                      % No Distortion With ‘axis equal’