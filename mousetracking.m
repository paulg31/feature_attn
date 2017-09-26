function [responseAngle, mouse_start, resp_time] = mousetracking(screen,arc,ring,trial,design,iBlock)

% Set mouse at random position
xstart      = rand*screen.windowRect(3);
ystart      = rand*screen.windowRect(4);
mouse_start = [xstart,ystart];
SetMouse(xstart,ystart,screen.window);

RestrictKeysForKbCheck(84); %T for response, arbitrary, can be changed NOW IS JUST MOUSE
Screen('BlendFunction',screen.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,[]);
exitLoop = 0; 
tic
while ~exitLoop
    % Get the current position of the mouse
    [mx, ~, buttons] = GetMouse(screen.window);
    
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
   
    xy = [screen.bar_height/2*cos(theta) -screen.bar_height/2*cos(theta);screen.bar_height/2*sin(theta) -screen.bar_height/2*sin(theta)];
    Screen('DrawLines',screen.window,xy,screen.bar_width,screen.lesswhite,[screen.xCenter screen.yCenter],1);
    progress_bar( screen, design,trial,iBlock )
    Screen('FillOval', screen.window, ring.color, ring.allRects);
    Screen('Flip', screen.window,screen.ifi);
    
    % Response, separate fucntions
    if buttons(1) == 1
        responseAngle = actual*180/pi;
        exitLoop = 1;
        resp_time = toc;
    end
    
end
RestrictKeysForKbCheck([]);
end