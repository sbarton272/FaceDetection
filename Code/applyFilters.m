function X = applyFilters(data, filters, height, width)
%% Apply filters to all input data, results are row-wise

X = zeros(length(data), length(filters));
for i = 1:length(data)

	img = data{i};
	integralImg = cumsum(cumsum(img),2);
	integralImgSqr = cumsum(cumsum(img.^2),2);
	X(i,:) = calcFeatures(integralImg, integralImgSqr, 0, 0, 1, filters, [height, width]);

end
end