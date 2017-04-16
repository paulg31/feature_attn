% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white/2;
% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 100 300];

% Define red
red = [1 0 0];

% Here we set the initial position of the mouse to be in the centre of the
% screen
SetMouse(xCenter, yCenter, window);

% We now set the squares initial position to the centre of the screen
sx = xCenter;
sy = yCenter;
centeredRect = CenterRectOnPointd(baseRect, sx, sy);

% Offset toggle. This determines if the offset between the mouse and centre
% of the square has been set. We use this so that we can move the position
% of the square around the screen without it "snapping" its centre to the
% position of the mouse
offsetSet = 0;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
angles = rand .* 360;
degPerFrame = 1;

% Center the rectangle on its new screen position
%centeredRect = CenterRectOnPointd(baseRect, sx, sy);

% Draw the rect to the screen
Screen('FillRect', window, red, centeredRect);

% Draw a white dot where the mouse cursor is
% Screen('DrawDots', window, [mx my], 10, white, [], 2);

% Flip to the screen
vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

KbWait;
sca;
clearvars;

% 
% % Loop the animation until a key is pressed
% while ~KbCheck
% 
%     % Get the current position of the mouse
%     [mx, my, buttons] = GetMouse(window);
% 
%     % Find the central position of the square
%     [cx, cy] = RectCenter(centeredRect);
% 
%     % See if the mouse cursor is inside the square
%     inside = IsInRect(mx, my, centeredRect);
% 
%     % If the mouse cursor is inside the square and a mouse button is being
%     % pressed and the offset has not been set, set the offset and signal
%     % that it has been set
%     if inside == 1 && sum(buttons) > 0 && offsetSet == 0
%         dx = mx - cx;
%         dy = my - cy;
%         offsetSet = 1;
%     end
%     
%     
%     % If we are clicking on the square allow its position to be modified by
%     % moving the mouse, correcting for the offset between the centre of the
%     % square and the mouse position
%     if inside == 1 && sum(buttons) > 0
%         sx = mx - dx;
%         sy = my - dy;
%         angle = angles;
% 
%         % Translate, rotate, re-tranlate and then draw our square
%         Screen('glPushMatrix', window)
%         Screen('glTranslate', window, sx, sy)
%         Screen('glRotate', window, angle, 0, 0);
%         Screen('glTranslate', window, -sx, -sy)
%         Screen('FillRect', window, red,...
%             CenterRectOnPoint(baseRect, sx, sy));
%         Screen('glPopMatrix', window)    
%         % Increment the rotation angles of the sqaures now that we have drawn
%         % to the screen
%         angles = angles + degPerFrame;
% 
% 
%     % Center the rectangle on its new screen position
%     centeredRect = CenterRectOnPointd(baseRect, sx, sy);
% 
%     % Draw the rect to the screen
%     Screen('FillRect', window, red, centeredRect);
% 
%     % Draw a white dot where the mouse cursor is
%     Screen('DrawDots', window, [mx my], 10, white, [], 2);
% 
%     % Flip to the screen
%     vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%     end
% 
%     
%     % Check to see if the mouse button has been released and if so reset
%     % the offset cue
%     if sum(buttons) <= 0
%         offsetSet = 0;
%     end
% 
% end
% 
% % Clear the screen
% sca;