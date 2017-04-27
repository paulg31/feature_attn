function mousetracking(screen,trial_mean,arc)% Clear the workspace and the screen
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Set mouse
xstart = rand(1)*screen.windowRect(3);
ystart = rand(1)*screen.windowRect(4);
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response
secs0 = GetSecs;
while ~KbCheck
    drawarc( screen,trial_mean );
    % Get the current position of the mouse
    [mx, ~, ~] = GetMouse(screen.window);
    
    if mx < 2
        SetMouse(1598,screen.yCenter,screen.window);
    elseif mx > 1598
        SetMouse(2,screen.yCenter,screen.window);
    end
    
    Xdiff = mx-screen.xCenter;
    L = screen.xCenter/2;
    theta = mod(Xdiff/L,1)*pi;
    actual = pi-theta;

    Screen('FillPoly', screen.window, screen.white, arc.newpolyPoints);
    Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2);
    Screen('FillPoly', screen.window, screen.white, arc.newpolyPointsop);
    Screen('FillPoly', screen.window, screen.bgcolor, arc.polyPoints2op);
    Screen('DrawTexture', screen.window, recttexture, [], [], theta*180/pi);
    Screen('Flip', screen.window,screen.ifi);
    % Response, separate fucntion
    if KbCheck
        [~, secs, pressedKey, ~] = KbCheck;
%         responseKey              = find(pressedKey,1);
%         RT                       = secs-secs0;
        responseAngle            = actual*180/pi
    end
end

RestrictKeysForKbCheck([])
end