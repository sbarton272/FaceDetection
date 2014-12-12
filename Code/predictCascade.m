function y = predictCascade(model, X, iI, iI2, x, y, scale)
	%% X is a single observation

	cascade = model.cascade;

    y = 0;
    for i = 1:length(cascade)

    	% Calc features for this filter
    	X(model.filterInd{i}) = calcFeatures(iI, iI2, x, y, scale, model.filters{i}, model.filterSize);
        
        y = predict(cascade{i}, X);
        if y == 0
            return
        end
    end

end