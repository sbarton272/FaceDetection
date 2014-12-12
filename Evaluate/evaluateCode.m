function [score, error] = evaluateCode(data, showBox)
clrGreen = uint8([0 255 0]);
clrBlue = uint8([0 0 255]);
agsf = true; error = '';
score = 0; fs = zeros(length(data),1);
%% load face_detection model
tic;
model = load_model();
for i=1:length(data)
    img = loadImg(data{i}.img_name);
    bboxes = detect_faces(img,model);
    if ~isempty(bboxes)
        fs(i) = score_boxes(bboxes,data{i}.bboxes);
    end

    %% If desired show bounding boxes
    if showBox
        nBoxes = size(data{i}.bboxes,1);
        nFoundBoxes = size(bboxes,1);
        clrs = [repmat(clrBlue, nBoxes,1); repmat(clrGreen, nFoundBoxes,1)];

        [overlapBoxes, noOverlapBoxes] = overlapedBoxes(data{i}.bboxes, bboxes)
        
        boxes = [data{i}.bboxes; overlapBoxes];
        shapeInserter = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', clrs);
        img = step(shapeInserter, double(img), boxes);
        numFound = size(bboxes);
        imshow(uint8(img));
        title([data{i}.img_name, '; ', num2str(numFound(1)), '; ', num2str(fs(i))])
        pause
    end

end
done = toc;
%% check time
if done > 1800 && agsf
    agsf = false;
    error = 'error execution timed out';
end
%% continue
if (agsf)
    %% generate final score
    score = mean(fs);
end
end

function img = loadImg(filePath)
    filePath = ['../', filePath, '.jpg'];
    img = imread(filePath);
    
    % Convert greyscale to rgb to be uniform
    if size(img, 3) == 1
        img = repmat(img,[1 1 3]);
    end
end