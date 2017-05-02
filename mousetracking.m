function [responseAngle, mouse_start] = mousetracking(screen,arc)
texturerect = ones(10,300).*screen.white;
recttexture = Screen('MakeTexture',screen.window,texturerect);

% Set mouse
xstart      = rand(1)*screen.windowRect(3);
ystart      = rand(1)*screen.windowRect(4);
mouse_start = [xstart,ystart];
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response

while ~KbCheck
    % Get the current position of the mouse
    [mx, ~, ~] = GetMouse(screen.window);
    
    if mx < 2
        SetMouse(1598,screen.yCenter,screen.window);
    elseif mx > 1598
        SetMouse(2,screen.yCenter,screen.window);
    end
    
    Xdiff   = mx-screen.xCenter;
    L       = screen.xCenter/2;
    theta   = mod(Xdiff/L,1)*pi;
    actual  = pi-theta;

    Screen(arc.type2draw, screen.window, screen.white, arc.poly);
    Screen(arc.type2draw, screen.window, screen.bgcolor, arc.cover);
    Screen(arc.type2draw, screen.window, screen.white, arc.polyopp);
    Screen(arc.type2draw, screen.window, screen.bgcolor, arc.coveropp);
    Screen('DrawTexture', screen.window, recttexture, [], [], theta*180/pi);
    Screen('Flip', screen.window,screen.ifi);
    
    % Response, separate fucntion
    if KbCheck
        responseAngle = actual*180/pi;
    end
end

RestrictKeysForKbCheck([])
end