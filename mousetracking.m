function [responseAngle, mouse_start, bar] = mousetracking(screen,arc)
% Bar Info
bar.texturerect = ones(5,300).*screen.lesswhite;
bar.recttexture = Screen('MakeTexture',screen.window,bar.texturerect);

% Set mouse
xstart      = rand(1)*screen.windowRect(3);
ystart      = rand(1)*screen.windowRect(4);
mouse_start = [xstart,ystart];
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response, arbitrary

exitLoop = 0; 

while ~exitLoop
    % Get the current position of the mouse
    [mx, ~, ~] = GetMouse(screen.window);
    
    % Flip Mouse to other side if reaches 2nd closest pixel
    if mx < 2
        SetMouse(screen.Xpixels-2,screen.yCenter,screen.window);
    elseif mx > screen.Xpixels-2
        SetMouse(2,screen.yCenter,screen.window);
    end
    
    % Bar position depends only on X, conversions 
    Xdiff   = mx-screen.xCenter;
    L       = screen.xCenter/2;
    theta   = mod(Xdiff/L,1)*pi;
    actual  = pi-theta;

    % Draw postcue only sometimes

        Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.poly.post);
        Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.cover.post);
        Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
        Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
    
    Screen('DrawTexture', screen.window, bar.recttexture, [], [], theta*180/pi);
    Screen('Flip', screen.window,screen.ifi);
    
    % Response, separate fucntion
    if KbCheck
        responseAngle = actual*180/pi;
        exitLoop = 1;
    end
    
end

RestrictKeysForKbCheck([])
end