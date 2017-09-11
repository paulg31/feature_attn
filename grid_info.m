function ring = grid_info(screen, design,control)

% Make a base Rect
baseRect = [0 0 5 5];
radius = (design.arc_dist-.375)*screen.pxPerDeg;
range = pi/12:pi/12:2*pi;
count = 1;
for ii = range
    xpos(count) = radius*cos(ii);
    ypos(count) = radius*sin(ii);
    count = count + 1;
end

% Make our coordinates
for i = 1:numel(xpos)
    ring.allRects(:, i) = CenterRectOnPointd(baseRect, xpos(i)+screen.xCenter, ypos(i)+screen.yCenter);
end

% Changes default color to either display the grid or not
if control == 1
    ring.color = screen.bgcolor;
else
    ring.color = screen.lesswhite;
end

end