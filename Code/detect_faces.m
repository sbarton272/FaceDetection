function [bboxes] = detect_faces(frame,model)
    %% Consts
    MIN_SCALE = 1;
    SCALE_FACTOR = .5;
    X_STEP_SIZE = model.filterSize(2);
    Y_STEP_SIZE = model.filterSize(1);

    %% Convert input image
    I = frame;
    frame = preprocessImg(frame);

    %% Calculate windows at varying scales
    bboxes = [];
    scale = 1;
    X = zeros(1,model.numParams);
    
    % Prescale down until 1/20the scale
    minSize = model.filterSize * 20;
    sz = size(frame);
    scale = scale * minSize(2) / sz(2);
    frame = imresize(frame, [NaN minSize(2)]);
    
    X_STEP_SIZE = X_STEP_SIZE / scale;
    Y_STEP_SIZE = Y_STEP_SIZE / scale;

    while(size(frame,1) > MIN_SCALE*model.filterSize(1) && ...
          size(frame,2) > MIN_SCALE*model.filterSize(2))
        
        %% Integral images
        integralImg = cumsum(cumsum(frame),2);
        integralImgSqr = cumsum(cumsum(frame.^2),2);

        %% Iterate over all possible faces
        maxY = size(frame,1) - model.filterSize(1) + 1;
        maxX = size(frame,2) - model.filterSize(2) + 1;
        xStep = max(uint32(round(X_STEP_SIZE * scale)), 1);
        yStep = max(uint32(round(Y_STEP_SIZE * scale)), 1);
        for x = 1:xStep:maxX
            for y = 1:yStep:maxY
                %% Detect face
                if predictCascade(model, X, integralImg, integralImgSqr, x, y, 1)
                    bb = [double(x), double(y), ...
                            double(model.filterSize(2)), double(model.filterSize(1))];
                    bb = bb / scale;
                    bboxes = [bboxes; bb];
                end
            end
        end

        %% Reduce dimensions
        scale = scale*SCALE_FACTOR
        frame = imresize(frame, SCALE_FACTOR);

    end
    
    bboxes = combineBb(bboxes);
end