function [nonFaces] = loadNonFaces(dirPath, height, width)
%% Generate negative test examples of specified size, grayscale

files = dir(dirPath);
nonFaces = {};

%% Load all images
n = 1;
for i = 1:length(files)
	if ~files(i).isdir

		% Read and simply resize to specified, may not be optimal
		I = im2double(imread([dirPath, files(i).name]));
		I = imresize(I, [height, width]);

		% Convert to greyscale
		if(size(I,3)>1)
		    I = rgb2gray(I);
		end

		nonFaces{n} = I;
		n = n + 1;
	end

end

end
