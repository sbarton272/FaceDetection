function [score, error] = evaluateCode(sdir, data)
agsf = true; error = '';
score = 0; fs = zeros(length(data),1);
%% store current directory
curDir = cd;
%% change to submission directory
chdir(sdir);
%% load face_detection model
tic;
model = load_model();
chdir(curDir);
for i=1:length(data)
    chdir(sdir);
    bboxes = detect_faces(data{i}.img,model);
    chdir(curDir);
    fs(i) = score_boxes(bboxes,data{i}.bboxes);
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