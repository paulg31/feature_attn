function mousetracking(screen)% Clear the workspace and the screen
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Here we set the initial position of the mouse to be in the centre of the
% screen
xstart = rand(1)*screen.xCenter;
ystart = rand(1)*screen.yCenter;
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T
secs0 = GetSecs;
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
    % Response, separate fucntion
    if KbCheck
        [~, secs, pressedKey, ~] = KbCheck;
        responseKey              = find(pressedKey,1);
        RT                       = secs-secs0;
        responseAngle            = currentAngle
    end
end

RestrictKeysForKbCheck([])
end