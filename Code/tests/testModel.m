function testModel()
addpath('..\dev\');
addpath('..\');


model = load_model();
load('dev/faces.mat', 'faces');
load('dev/nonFaces.mat', 'nonFaces');
data = [faces, nonFaces];
label = [ones(1,length(faces)), zeros(1,length(nonFaces))];

err = [0 0 0 0]; % Pos, False Pos, Neg, False Neg

for i=1:length(data)
    img = data{i};
    img = imresize(img, 4);
    bboxes = detect_faces(img,model);
        
    %% If desired show bounding boxes
    nFoundBoxes = size(bboxes,1);
    if nFoundBoxes > 0
        boxes = bboxes;
        shapeInserter = vision.ShapeInserter();
        img = step(shapeInserter, double(img), boxes);
    end
    imshow(img);
    title(num2str(nFoundBoxes));
    pause
    
    %% Record results
    if nFoundBoxes > 0
        if label(i) == 1
            err(1) = err(1) + 1;
        else
            err(2) = err(2) + 1;
        end
    else
        if label(i) == 0
            err(3) = err(3) + 1;
        else
            err(4) = err(4) + 1;
        end
    end
end

disp('Pos, False Pos, Neg, False Neg');
results = err / sum(err)

end