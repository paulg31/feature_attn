function [responseAngle, mouse_start, bar, resp_time] = mousetracking(screen,arc,ring)
% Bar Info
bar.texturerect = ones(screen.bar_width,screen.bar_height).*screen.lesswhite;
bar.recttexture = Screen('MakeTexture',screen.window,bar.texturerect);

% Set mouse at random position
xstart      = rand*screen.windowRect(3);
ystart      = rand*screen.windowRect(4);
mouse_start = [xstart,ystart];
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response, arbitrary, can be changed

exitLoop = 0; 
tic
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

    % Draw postcue
    Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.poly.post);
    Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.cover.post);
    Screen(arc.type2draw.post, screen.window, screen.lesswhite, arc.polyopp.post);
    Screen(arc.type2draw.post, screen.window, screen.bgcolor, arc.coveropp.post);
    
    Screen('DrawTexture', screen.window, bar.recttexture, [], [], theta*180/pi);
    Screen('FillOval', screen.window, ring.color, ring.allRects);
    Screen('Flip', screen.window,screen.ifi);
    
    % Response, separate fucntion
    if KbCheck
        responseAngle = actual*180/pi;
        exitLoop = 1;
        resp_time = toc;
    end
    
end
RestrictKeysForKbCheck([])
end