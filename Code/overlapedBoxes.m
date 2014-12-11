function [overlapBoxes, noOverlapBoxes] = overlapedBoxes(boxes1, boxes2)

overlapBoxes = [];
noOverlapBoxes = [];
% [x y w h]
for i = 1:size(boxes1,1)
    b1 = boxes1(i);
    x1 = b1(1);
    x2 = x1 + b1(3);
    y1 = b1(2);
    y2 = y1 + b1(4);
    
    for j = 1:size(boxes2,1)
        b2 = boxes2(j);
        
        % Check if x and y within box
        if (((b2(1) > x1) && (b2(1) < x2)) || ...
            ((b2(1)+b2(3) > x1) && (b2(1)+b2(3) < x2))) ...
           && (((b2(2) > y1) && (b2(2) < y2)) || ...
            ((b2(2)+b2(4) > y1) && (b2(2)+b2(4) < y2)))
            overlapBoxes = [overlapBoxes; b2];
        else
            noOverlapBoxes = [noOverlapBoxes; b2];
        end
    end
    
end

end