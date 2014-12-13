function [nonFaces] = loadNonFaces(dirPath, dataFile, height, width)
%% Generate negative test examples of specified size, grayscale

nonFaces = {};
load(dataFile,'data');

%% Load all images
k = 1;
for i = 1:length(data)
    
    name = data{i};
    if strcmp(name, '.') || strcmp(name, '..') || strcmp(name, '/')
        continue
    end

    % Read and simply resize to specified, may not be optimal
	I = imread([dirPath, name]);
	I = preprocessImg(I);
    
    % Split into multiple images
    [m, n] = size(I);
    midN = uint32(n/2);
    midM = uint32(m/2);
    I1 = I(1:midM,1:midN);
    I2 = I(midM:end,1:midN);
    I3 = I(1:midM,midN:end);
    I4 = I(midM:end,midN:end);
    
	I1 = imresize(I1, [height, width]);
    I2 = imresize(I2, [height, width]);
    I3 = imresize(I3, [height, width]);
    I4 = imresize(I4, [height, width]);

    nonFaces{k} = I;
	k = k + 1;
	nonFaces{k} = I1;
	k = k + 1;
    nonFaces{k} = I2;
	k = k + 1;
    nonFaces{k} = I3;
	k = k + 1;
    nonFaces{k} = I4;
	k = k + 1;

    
end

end
