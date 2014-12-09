function [features] = calcFeatures(integralImg, integralImgSqr, ix, iy, scale, filters, filterSize)
% Apply the given filters on the given integral image at the 
% specified x,y location (upper left) - NOTE 0 indexed
% filters is a cell array of vectors of filter structs

% Prealloc features
features = zeros(1,length(filters));

% Make zero indexed
ix = ix - 1;
iy = iy - 1;

% Calc window mean and variance
N = scale*filterSize(1) * scale*filterSize(2);
mu = getArea(integralImg, ix, ix + scale*filterSize(2), iy, iy + scale*filterSize(1));
mu = mu / N;
mu2 = getArea(integralImgSqr, ix, ix + scale*filterSize(2), iy, iy + scale*filterSize(1));
mu2 = mu2 / N;
sigma = sqrt(mu2 - mu^2);

% Iterate through all filters and apply each
for i = 1:length(filters)
    
    % Calculate filter coef, mean normalized
	coef = applyFilter(integralImg, ix, iy, scale, mu, filters{i});

	% Normalize variance
    if sigma ~= 0
        features(i) = coef / sigma;
    else
        features(i) = coef;
    end

end

end

function coef = applyFilter(iI, ix, iy, scale, mu, fltr)
% Apply the given filter on the image

coef = 0.0;

% Calculate regions
for i = 1:size(fltr,1)
	region = fltr(i);
    x = double(region.x);
    y = double(region.y);
    w = double(region.w);
    h = double(region.h);
    weight = double(region.weight);

	% Calc corners on img
	x1 = ix + x*scale;
	x2 = x1 + w*scale;
	y1 = iy + y*scale;
	y2 = y1 + h*scale;

	% Use integral image properties
	area = getArea(iI,x1,x2,y1,y2);
    areaAvg = mu * h*scale * w*scale;
    area = area - areaAvg;
	coef = coef + area*weight;

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