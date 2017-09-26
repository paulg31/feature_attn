function [mad_low, mad_high] = getMAD(data)
blocks = [5 6];
vals_low = [];
vals_high = [];
for block_num = 1:numel(blocks)
    for ii = 1:numel(data.mat{blocks(block_num)}(:,1))
        if data.mat{blocks(block_num)}(ii,7) == 0
            vals_low = [vals_low; data.mat{blocks(block_num)}(ii,5)];
        elseif data.mat{blocks(block_num)}(ii,7) == 4
            vals_high = [vals_high; data.mat{blocks(block_num)}(ii,5)];
        end
    end
end
mad_low = 1.48*median(abs(vals_low));
mad_high = 1.48*median(abs(vals_high));
end