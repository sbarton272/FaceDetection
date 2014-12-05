function [nonFaces] = loadNonFaces(dirPath, dataFile, height, width)
%% Generate negative test examples of specified size, grayscale

nonFaces = {};
load(dataFile,'data');

%% Load all images
n = 1;
for i = 1:length(data)
    
    name = data{i};
    if strcmp(name, '.') || strcmp(name, '..') || strcmp(name, '/')
        continue
    end

    % Read and simply resize to specified, may not be optimal
	I = imread([dirPath, name]);
	I = preprocessImg(I);
	I = imresize(I, [height, width]);

	nonFaces{n} = I;
	n = n + 1;

end

end
