clearvars;

circr = @(radius,rad_ang)  [radius*cos(rad_ang);  radius*sin(rad_ang)];         % Circle Function For Angles In Radians
circd = @(radius,deg_ang)  [radius*cosd(deg_ang);  radius*sind(deg_ang)];       % Circle Function For Angles In Degrees
N = 25;                                                         % Number Of Points In Complete Circle
%r_angl = linspace(pi/4, 3*pi/4, N);                             % Angle Defining Arc Segment (radians)
start = 1;
radend = N;
anglestart = pi/4;
angleend = 3*pi/4;
% Initiate Drawing
set(gcf,'double','on')
plot(0,0,'r*');
hold on
axis equal
axis([-2  2 -2 2])             % Set Axis Limits
axis manual
hold off

for radius = 1.5:.001:1.8;
    r_angl = linspace(anglestart,angleend,N);% Arc Radius
    xy_r = circr(radius,r_angl);                                    % Matrix (2xN) Of (x,y) Coordinates
    figure(1)
    hold on
    plot(xy_r(1,:), xy_r(2,:), 'b-')                                % Draw An Arc
    hold off
    drawnow
    anglestart = anglestart + pi/1200;
    angleend = angleend - pi/1200;
end