function [score, error] = evaluateCode(data, showBox)
shapeInserterBlue = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', uint8([0 0 255]));
shapeInserterGreen = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', uint8([0 255 0]));
agsf = true; error = '';
score = 0; fs = zeros(length(data),1);
%% load face_detection model
tic;
model = load_model();
for i=1:length(data)
	img = loadImg(data{i}.img_name);
    bboxes = detect_faces(img,model);
    fs(i) = score_boxes(bboxes,data{i}.bboxes);

    %% If desired show bounding boxes
    if showBox
    	if bboxes ~= []
            img = step(shapeInserterGreen, img, bboxes);
        end
        img = step(shapeInserterBlue, img, data{i}.bboxes);
        numFound = size(bboxes)
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
	img = double(imread(filePath));
end