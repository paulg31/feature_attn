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
        val_pos = iBlock + 2;
        window = val_pos - 2:val_pos;
end
        design.point_array(val_pos) = total;
        avg_points = mean(design.point_array(window));