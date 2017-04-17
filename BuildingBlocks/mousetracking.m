% Clear the workspace and the screen
sca;
close all;
clearvars;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
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
posX = xCenter;
posY = yCenter;
centeredRect = CenterRectOnPointd(baseRect, posX, posY);

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
angle = 65;
degPerFrame = 1;

% Here we set the initial position of the mouse to be in the centre of the
% screen
SetMouse(xCenter, yCenter, window);

% Draw the rect to the screen
Screen('FillRect', window, red, centeredRect);

% %Rotate
% while ~KbCheck
%     
%         % Get the current position of the mouse
%         [mx, my, buttons] = GetMouse(window);
%         mouse_theta = atan(my/mx);
%     
%         % Find the central position of the square
%         [posX, posY] = RectCenter(centeredRect);
%     
%         % See if the mouse cursor is inside the square
%         inside = IsInRect(mx, my, centeredRect);
%         
%         if inside == 1 && sum(buttons) > 0 && offsetSet == 0
%             dx = mx - posX;
%             dy = my - posY;
%             angle = angle + mouse_theta;
%             centeredRect = CenterRectOnPointd(baseRect, posX, posY);
%         end
% %     
% %         if inside == 1 && sum(buttons) > 0
% %             PosX = mx - dx;
% %             PosY = my - dy;
% %             
% %         end
%         
% 
%         % Get the current squares position ans rotation angle
%        %angle = angles;
% 
%         % Translate, rotate, re-tranlate and then draw our square
%         Screen('glPushMatrix', window)
%         Screen('glTranslate', window, posX, posY)
%         Screen('glRotate', window, angle, 0, 0);
%         Screen('glTranslate', window, -posX, -posY)
%         Screen('FillRect', window, red,...
%             CenterRectOnPointd(baseRect, posX, posY));
%         Screen('glPopMatrix', window)
%         
        % Flip to the screen
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
%         
%         
%         angle = angle;
% end


KbWait;
sca;
clearvars;