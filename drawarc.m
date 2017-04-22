function drawarc( screen )
waitframes = 1;
radius = 340;

% Draw some filled and framed polygons:
count = 1;
xval = zeros(1,37);
yval = zeros(1,37);
for angle  = pi/4:pi/72:3*pi/4
    xval(count) = cos(angle)*radius +screen.xCenter;
    yval(count) = sin(angle)*radius +screen.yCenter;
    count = count +1;
end
polyPoints2 = [xval',yval'];
sigma = pi/15;
cent = pi/2;
newx = zeros(1,37);
newy = zeros(1,37);
count = 1;
for val = pi/4:pi/72:3*pi/4
    newy(count) = 10*normpdf(val,cent,sigma)+yval(count);
    newx(count) = xval(count);
    count = count+1;
end

newxval = [xval newx];
newyval = [yval newy];
newpolyPoints = [newxval',newyval'];
% Draw a filled polygon:

Screen('FillPoly', screen.window, screen.white, newpolyPoints);
Screen('FillPoly', screen.window, screen.bgcolor, polyPoints2);  

% Draw a white dot where the mouse cursor is
Screen('DrawDots', screen.window, [screen.xCenter screen.yCenter], 10, screen.white, [], 2);

% Flip to the screen
Screen('Flip', screen.window, (waitframes - 0.5) * screen.ifi);
KbWait;

end

