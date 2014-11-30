function [faces] = loadFaces(dataFile, height, width)
%% Generate positive test examples of specified size, grayscale

%% Load
load(dataFile, 'devData');
data = devData;

%% Save all found faces as seperate images size width X height
faces = {};
n = 1;
for i = 1:length(data)

	img = loadImg(data{i}.img_name);
    img = preprocessImg(img);
    
	%% Get X,Y regions to extract
	for j = 1:size(data{i}.bboxes,1)
		bb = data{i}.bboxes(j,:);
		face = loadFace(img,bb(1),bb(2),bb(3),bb(4),height,width);
		faces{n} = face;
        n = n+1;
	end

end

end

function face = loadFace(img,x,y,w,h,height,width)

	% Sanity check as some bboxes go off image
	if x < 1
		x = 1;
	end
	if x+w > size(img,2)
		w = size(img,2) - x;
	end
	if y < 1
		y = 1;
	end
	if y+h > size(img,1)
		h = size(img,1) - y;
	end

	ratio = height / width;

	% Resize to the smaller dimension
	if w < (h/ratio)
		% Width smaller
		newH = w*ratio;
		cY = y + h/2;
		y = cY - newH/2;
		h = newH;
	elseif (h/ratio) < w
		% Height smaller
		newW = h/ratio;
		cX = x + w/2;
		x = cX - newW/2;
		w = newW;
	end

	% Extract face
	face = img(uint16(y):uint16(y+h), uint16(x):uint16(x+w));
	face = imresize(face, [height, width]);

end


function img = loadImg(filePath)
    filePath = ['../', filePath, '.jpg'];
    img = imread(filePath);
end