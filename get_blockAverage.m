function [avg_points, design] = get_blockAverage(design, data, sessionNo, iBlock,total)

switch sessionNo
    case 1
        switch iBlock
            case 5
                window = 1:1;
            case 6
                window = 1:2;
        end
        val_pos = iBlock - 4;
    case {2 3}
        if isempty(design.point_array) 
            design.point_array = [0 0];
        end
        val_pos = iBlock + 2;
        window = val_pos - 2:val_pos;
        
end
        design.point_array(val_pos) = total;
        avg_points = mean(design.point_array(window));
        
        %        if ~isempty(design.point_array)
%             val_pos = iBlock + 2;
%             window = val_pos - 2:val_pos;
%         else
%             val_pos = iBlock;
%             switch iBlock
%                 case 1
%                     window = 1:1;
%                 case 2
%                     window = 1:2;
%                 case {3, 4, 5, 6}
%                     window = val_pos-2:val_pos;
%             end
%         end