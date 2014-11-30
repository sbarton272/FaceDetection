function [features] = calcFeatures(integralImg, integralImgSqr, ix, iy, scale, filters, filterSize)
% Apply the given filters on the given integral image at the 
% specified x,y location (upper left) - NOTE 0 indexed
% filters is a cell array of vectors of filter structs

% Prealloc features
features = zeros(1,length(filters));

% Iterate through all filters and apply each
for i = 1:length(filters)
	coef = applyFilter(integralImg, ix, iy, scale, filters{i});

	% Normalize variance
	mu = getArea(integralImg, ix, iy, ix + scale*filterSize(2), iy + scale*filterSize(1));
	mu2 = getArea(integralImgSqr, ix, iy, ix + scale*filterSize(2), iy + scale*filterSize(1));
	sigma = sqrt(mu^2 - mu2);
	features(i) = coef / sigma;

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
	area = getArea(iI,x1,x2,y1,y2);
	coef = coef + area*region.weight;

end

end

function A = getArea(iI,x1,x2,y1,y2)
	A = get(iI,x2,y2) - get(iI,x1,y2) - get(iI,x2,y1) + get(iI,x1,y1);
end

function x = get(X, ix, iy)
    if ix <= 0
        x = 0;
    elseif iy <= 0
        x = 0;
    else
        x = X(iy,ix);
    end
end