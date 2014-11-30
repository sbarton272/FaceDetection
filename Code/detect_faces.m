function [bboxes] = detect_faces(frame,model)
    %% Consts
    MIN_SCALE = 4;

    %% Convert input image
    if(size(frame,3)>1)
        frame = rgb2gray(frame);
    end
    frame = im2double(frame);
    imSize = size(frame);

    %% Calculate windows are varying scales
    bboxes = [];
    scale = 1;
    X = zeros(1,model.numParams);
    while(size(frame,1) > MIN_SCALE*model.filterSize(1) && ...
          size(frame,2) > MIN_SCALE*model.filterSize(2))
        %% Reduce dimensions by half
        scale = scale*.5;
        frame = impyramid(frame, 'reduce');
        size(frame)
      
        integralImg = cumsum(cumsum(frame),2);

        %% TODO really slow - determine how many looked at and where slow
        %% TODO scale bb appropriatly
        maxY = size(frame,1) - model.filterSize(1);
        maxX = size(frame,2) - model.filterSize(2);
        for x = 1:6:maxX
            for y = 1:6:maxY
                X(model.filterInd) = calcFeatures(integralImg, x, y, 1, model.filters);
                if predict(model.ens,X)
                    bb = [x, y, model.filterSize(2), model.filterSize(1)];
                    bboxes = [bboxes; bb/scale];
                    
                    bb
                end
            end
        end
    end
end