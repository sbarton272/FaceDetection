function [features] = calcFeatures(integralImg, integralImgSqr, ix, iy, scale, filters, filterSize)
% Apply the given filters on the given integral image at the 
% specified x,y location (upper left) - NOTE 0 indexed
% filters is a cell array of vectors of filter structs

% Prealloc features
features = zeros(1,length(filters));

% Pad img with zero area
[h w] = size(integralImg);
integralImg = [zeros(1,w+1); zeros(h,1) integralImg];
integralImgSqr = [zeros(1,w+1); zeros(h,1) integralImgSqr];

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

	% Calc corners on img
	x1 = ix + fltr(i,1)*scale;
	x2 = x1 + fltr(i,3)*scale;
	y1 = iy + fltr(i,2)*scale;
	y2 = y1 + fltr(i,4)*scale;

	% Use integral image properties and subtract mean
	area = getArea(iI,x1,x2,y1,y2) - (mu*fltr(i,3)*scale*fltr(i,4)*scale);
	coef = coef + area*fltr(i,5); % factor in weight

end

end

function A = getArea(iI,x1,x2,y1,y2)
	A = iI(y2,x2) - iI(y2,x1) - iI(y1,x2) + iI(y1,x1);
end
