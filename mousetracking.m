function mousetracking(screen,trial_mean,arc)% Clear the workspace and the screen
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Here we set the initial position of the mouse to be in the centre of the
% screen
xstart = rand(1)*screen.xCenter;
ystart = rand(1)*screen.yCenter;
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response
secs0 = GetSecs;
while ~KbCheck
    drawarc( screen,trial_mean );
    % Get the current position of the mouse
    [mx, ~, ~] = GetMouse(screen.window);
    Xdiff = mx-screen.xCenter;
    L = screen.xCenter/2;
    theta = mod(Xdiff/L,1)*pi
    actual = theta*2 - pi

    Screen('FillPoly', screen.window, screen.white, arc.newpolyPoints);
    Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2);  
    Screen('DrawTexture', screen.window, recttexture, [], [], theta*180/pi);
    Screen('Flip', screen.window,screen.ifi);
    % Response, separate fucntion
    if KbCheck
        [~, secs, pressedKey, ~] = KbCheck;
        responseKey              = find(pressedKey,1);
        RT                       = secs-secs0;
        responseAngle            = theta*180/pi
    end
end

RestrictKeysForKbCheck([])
end