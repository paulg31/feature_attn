clearvars;
% Screen Params
screenid = max(Screen('Screens'));
scr.bg = 127.5;
color.bg = scr.bg;
[scr.win, scr.rect] = Screen('OpenWindow', screenid, color.bg);
scr.w = scr.rect(3); % screen width in pixels
scr.h = scr.rect(4); % screen height in pixels
scr.cx = mean(scr.rect([1 3])); % screen center x
scr.cy = mean(scr.rect([2 4])); % screen center y
screen_resolution = [scr.w scr.h];  
screen_distance = 50;   
screen_width = 19.7042;
screen_angle = 2*(180/pi)*(atan((screen_width/2) / screen_distance)) ; % total visual angle of screen in degrees
P.pxPerDeg = screen_resolution(1) / screen_angle;  % pixels per degree
t.pres = 80;
% Ellipse parameters
P.ellipseAreaDegSq = 2; % ellipse area in degrees squared
P.ellipseAreaPx = P.pxPerDeg^2 * P.ellipseAreaDegSq; % ellipse area in number of pixels
P.ellipseColor = 0;
P.attention_stim_spacing = 5; % ran as 7 in pilot 1 % for multiple stimuli, distance from center (ie radius), in degrees
P.stim_dist = round(P.attention_stim_spacing * P.pxPerDeg); % distance from center in pixels


stim.cur_sigma = 1; %linspace(.15,.8,6)ROUNDNESS

for ii = 1:10
stim.ort = rand(1)*180 
rot = stim.ort+90;
cur_sigma = stim.cur_sigma;
im = drawEllipse(P.ellipseAreaPx, cur_sigma, rot, P.ellipseColor, scr.bg); %cur_sigma = eccentrcity
%% show it
% some shortcuts
centerX = scr.cx;
centerY = scr.cy;
textureW = size(im,2);
textureH = size(im,1); 
texture = Screen('MakeTexture',scr.win,im);
destRect = ceil([centerX centerY centerX centerY] + [-textureW -textureH textureW textureH] / 2);
Screen('DrawTexture', scr.win, texture, [], destRect);
Screen('Flip', scr.win);
Screen('Close', texture);
WaitSecs(2);
end
sca;
clearvars;