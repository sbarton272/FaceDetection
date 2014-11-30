function [nonFaces] = loadNonFaces(dirPath, height, width)
%% Generate negative test examples of specified size, grayscale

files = dir(dirPath);
nonFaces = {};

%% Load all images
n = 1;
for i = 1:length(files)
	if ~files(i).isdir

		% Read and simply resize to specified, may not be optimal
		I = imread([dirPath, files(i).name]);
		I = preprocessImg(I);
		I = imresize(I, [height, width]);

		nonFaces{n} = I;
		n = n + 1;
	end

end

end
