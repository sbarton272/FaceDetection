function [features] = calcFeatures(integralImg, ix, iy, scale, filters)
% Apply the given filters on the given integral image at the 
% specified x,y location (upper left)
% filters is a cell array of vectors of filter structs

% Prealloc features
features = zeros(1,size(filters,1));

% Iterate through all filters and apply each
for i = 1:size(filters,1)
	features(i) = applyFilter(integralImg, ix, iy, scale, filters{i});
end

end

function coef = applyFilter(iI, ix, iy, scale, fltr)
% Apply the given filter on the image

coef = 0;

% Calculate regions
for i = 1:size(fltr,1)
	region = fltr(i);

	% Calc corners on img
	x1 = ix + region.x*scale;
	x2 = x1 + region.w*scale;
	y1 = iy + region.y*scale;
	y2 = y1 + region.h*scale;

	% Use integral image properties
	area = iI(x2,y2) - iI(x1,y2) - iI(x2,y1) + iI(x1,y1);
	coef = coef + area*region.weight;

end

end