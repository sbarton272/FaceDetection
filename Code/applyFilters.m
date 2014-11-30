function X = applyFilters(data, filters)
%% Apply filters to all input data, results are row-wise

X = zeros(length(data), length(filters));
for i = 1:length(data)

	img = data{i};
	integralImg = cumsum(cumsum(img),2);
	X(i,:) = calcFeatures(integralImg, 0, 0, 1, filters);

end
end