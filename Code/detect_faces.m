function [bboxes] = detect_faces(frame,model)
    %% Consts
    MIN_SCALE = 4;

    %% Convert input image
    I = frame;
    frame = preprocessImg(frame);

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
        % Testing
        %scale = scale*.5;
        %frame = impyramid(frame, 'reduce');
        imshow(frame)
        pause

        %% Integral images
        integralImg = cumsum(cumsum(frame),2);
        integralImgSqr = cumsum(cumsum(img.^2),2);

        %% TODO really slow - determine how many looked at and where slow
        maxY = size(frame,1) - model.filterSize(1);
        maxX = size(frame,2) - model.filterSize(2);
        %for x = 23:2:(48 - model.filterSize(2))
        %    for y = 5:2:(35 - model.filterSize(1))
        for x = 1:10:maxX
            for y = 1:10:maxY
                %r = [y,y+model.filterSize(1),x,x+model.filterSize(2)] / scale;
                %imshow( I(r(1):r(2),r(3):r(4)) );
                %pause
                X(model.filterInd) = calcFeatures(integralImg, integralImgSqr, x, y, 1, model.filters, model.filterSize);
                if predict(model.ens,X)
                    bb = [x, y, model.filterSize(2), model.filterSize(1)] / scale
                    bboxes = [bboxes; bb];
                end
            end
        end
    end
end