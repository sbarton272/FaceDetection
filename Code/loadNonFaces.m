function [nonFaces] = loadNonFaces(dirPath, width, height)
%% Generate negative test examples of specified size, grayscale

files = dir(dirPath);
nonFaces = {};

%% Load all images
for i = 1:length(files)
	if files(i).isdir
		continue
	end

	% Read and simply resize to specified, may not be optimal
	I = imread([dirPath, files(i).name]);
	I = imresize(I, [height, width]);

	% Convert to greyscale
    if(size(I,3)>1)
        I = rgb2gray(I);
    end

    nonFaces{i} = I;
end

end
