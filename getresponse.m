function [RT, responsenumber] = getresponse(block_type, design,stimnum, wager)
% Restricts keys to only use the ones necessary and outputs reaction time

switch block_type
 case {'train', 'test', 'category_test'}
     %90 = Z for Left
     %77 = M for Right
     RestrictKeysForKbCheck([90 77]);

 case {'leftright_test', 'leftright_train'}
    %76 = L for Right of Vert
    %65 = A for Left of Vert
    %66 = B for Opt out
    switch stimnum
        case 1
            RestrictKeysForKbCheck([76 65]);
        case 2
            instruct(design, wager)
    end
     
 case {'rel_train', 'rel_test'}
     %81 = Q for 1st interval higher
     %80 = P for 2nd interval higher
     RestrictKeysForKbCheck([81 80]);
     
end

% Collect keyboard response
secs0 = GetSecs;
KbWait; 
[~, secs, pressedKey, ~] = KbCheck;
responseKey              = find(pressedKey,1);
RT                       = secs-secs0;

% Unrestrict Keys
RestrictKeysForKbCheck([]);

% Convert key numbers to Category or L/R responses
switch block_type
    case {'train', 'test', 'category_test'}

         switch responseKey
             case 90 %Z Presssed for Left
                 responsenumber = -1;
             case 77 %M Pressed for Right
                 responsenumber = 1;
         end

    case {'leftright_train', 'leftright_test'}

         switch responseKey
             case 76 %L (right of vert)
                 responsenumber = 1;
             case 65 %A (left of vert)
                 responsenumber = -1;
             case 32 %SPACE (opt out)
                 responsenumber = 2;
         end
         
   case {'rel_train', 'rel_test'}
         switch responseKey
             case 81 % 1st interval higher reliability
                 responsenumber = 1;
             case 80 % 2nd interval higher reliability
                 responsenumber = 2;
         end
         
end

end