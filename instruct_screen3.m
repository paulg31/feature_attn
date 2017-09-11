function instruct_screen3( screen,ring,design )

text = 'At the end of each trial, a black bar will appear with the actual orientation.';
text = [text '\n\nYou will receive points based on the accuracy of your response.'];
text = [text '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nTry to maximize your score during the experiment!'];
ypos = 0.15;
text_size = 30;

params.stim_type = design.stim;
params.roundness = 2.5;
params.instruct_mean    = 67;
params.instruct         = 1;

stim    = stim_info(screen,params);
theta   = (180-67)*pi/180;
theta_2 = (180-74)*pi/180;
xy_2 = [screen.bar_height/2*cos(theta) -screen.bar_height/2*cos(theta);...
    screen.bar_height/2*sin(theta) -screen.bar_height/2*sin(theta)];
xy = [screen.bar_height/2*cos(theta_2) -screen.bar_height/2*cos(theta_2);...
    screen.bar_height/2*sin(theta_2) -screen.bar_height/2*sin(theta_2)];

% Draw all the text
Screen('TextSize', screen.window, text_size);
DrawFormattedText(screen.window, text,...
'center', screen.Ypixels * ypos, screen.white);

switch params.stim_type
    case 'ellipse'
        drawellipse(screen, stim, params,[]);
    case 'gabor'
        drawgabor(screen, stim, params,[]);
end

% Draw feedback screen
Screen('BlendFunction',screen.window,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA,[]);
Screen('DrawLines',screen.window,xy,screen.bar_width,screen.lesswhite,...
    [screen.xCenter screen.yCenter],2);
Screen('DrawLines',screen.window,xy_2,screen.bar_width,screen.black,...
    [screen.xCenter screen.yCenter],2);
text = ['8 points'];
Screen('TextSize', screen.window, text_size-6);
DrawFormattedText(screen.window,text,'center', screen.Ypixels * 0.3, screen.white);
Screen('FillOval', screen.window, ring.color, ring.allRects);

% Flip to the screen
Screen('Flip', screen.window);

% Enable only SPACE to continue
RestrictKeysForKbCheck(32);

% Wait for key press to move on
KbWait([],2);
Screen('Flip', screen.window);

% Unrestricts Keys
RestrictKeysForKbCheck([]);

end