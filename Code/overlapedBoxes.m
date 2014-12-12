function [overlapBoxes, noOverlapBoxes] = overlapedBoxes(boxes1, boxes2)

NO_OVERLAP = [1 1 0 0]';

overlapBoxes = [];
noOverlapBoxes = [];
% [x y w h]
for i = 1:size(boxes2,1)
    b2 = boxes2(i,:);
    x1 = b2(1);
    x2 = x1 + b2(3);
    y1 = b2(2);
    y2 = y1 + b2(4);
    
    % Iter over given boxes
    overlapped = false;
    for j = 1:size(boxes1,1)
        b1 = boxes1(j,:);
        x3 = b1(1);
        x4 = x3 + b1(3);
        y3 = b1(2);
        y4 = y3 + b1(4);
        
        % Need overlap in both x and y
        X = [x1 1; x2 1; x3 0; x4 0];
        Y = [y1 1; y2 1; y3 0; y4 0];
        
        Ix = sortrows(X,1);
        Ix = Ix(:,2);
        Iy = sortrows(Y,1);
        Iy = Iy(:,2);
        
        if (~(all(Ix == NO_OVERLAP) || all(Ix == ~NO_OVERLAP) || ...
                all(Iy == NO_OVERLAP) || all(Iy == ~NO_OVERLAP)))
            overlapBoxes = [overlapBoxes; b2];
            overlapped = true;
            break;
        end
        
    end
    
    if ~overlapped
        noOverlapBoxes = [noOverlapBoxes; b2];
    end
    
end

end