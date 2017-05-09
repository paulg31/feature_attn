function [arc] = drawarc(screen,design)
%CIRCLE SIZE%

switch design.type_draw
    case 1
        radius      = design.radii(3)*screen.pxPerDeg;
        arc_sigma   = design.sigmas(1);
        dev_draw    = 3;
        
        arc_mean    = (randn*arc_sigma + design.trial_mean)*pi/180;
        arc_step    = pi/180;
        arc_start   = arc_mean - (dev_draw*arc_sigma*pi/180);
        arc_end     = arc_mean + (dev_draw*arc_sigma*pi/180);
        sigma       = arc_sigma*pi/180;     %sigma in rads for normpdf

        % Draw arc cover
        count     = 1;
        spans     = arc_start:arc_step:arc_end;
        xval      = zeros(1,numel(spans));
        yval      = zeros(1,numel(spans));
        newx      = zeros(1,numel(spans));
        newy      = zeros(1,numel(spans));
        xvalop    = zeros(1,numel(spans));
        yvalop    = zeros(1,numel(spans));
        newxop    = zeros(1,numel(spans));
        newyop    = zeros(1,numel(spans));

        for angle  = spans
            dist_height   = 10*normpdf(angle,arc_mean,sigma)+radius;

            % Arc cover points
            xval(count)   = cos(angle)*radius +screen.xCenter;
            yval(count)   = -sin(angle)*radius +screen.yCenter;
            xvalop(count) = -cos(angle)*radius +screen.xCenter;
            yvalop(count) = sin(angle)*radius +screen.yCenter;

            % Arc points
            newy(count)   = -sin(angle)*(dist_height) + screen.yCenter;
            newx(count)   = cos(angle)*(dist_height) + screen.xCenter;
            newyop(count) = sin(angle)*(dist_height) + screen.yCenter;
            newxop(count) = -cos(angle)*(dist_height) + screen.xCenter;

            count = count +1;
        end

        arc.type2draw = 'FillPoly';        
        % Arc Cover
        arc.cover     = [xval',yval'];
        arc.coveropp   = [xvalop',yvalop'];

        % Arc
        arc.poly   = [newx',newy'];
        arc.polyopp = [newxop',newyop'];
        
    case 2
        baseRect = [0 0 500 500];
        baseRect2 = [0 0 490 490];
        arc.poly = CenterRectOnPointd(baseRect, screen.xCenter, screen.yCenter);
        arc.cover = CenterRectOnPointd(baseRect2,screen.xCenter, screen.yCenter);
        arc.polyopp = [0 0 0 0];
        arc.coveropp = [0 0 0 0];
        arc.type2draw = 'FillOval';
        
    case 3
        arc.poly = [0 0 0 0];
        arc.cover = [0 0 0 0];
        arc.polyopp = [0 0 0 0];
        arc.coveropp = [0 0 0 0];
        arc.type2draw = 'FillOval';
        
end
end

