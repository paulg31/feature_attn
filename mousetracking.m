function mousetracking(screen)% Clear the workspace and the screen
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Here we set the initial position of the mouse to be in the centre of the
% screen
SetMouse(screen.xCenter, screen.yCenter+.01, screen.window);

while ~KbCheck
    % Get the current position of the mouse
    [mx, my, ~] = GetMouse(screen.window);
    currentX = mx-screen.xCenter;
    currentY = my-screen.yCenter;
    shift = atan(currentY/currentX);
    degrees = 180/pi*shift;
    currentAngle = degrees;
    Screen('DrawTexture', screen.window, recttexture, [], [], currentAngle);
    Screen('Flip', screen.window,screen.ifi);
end
end