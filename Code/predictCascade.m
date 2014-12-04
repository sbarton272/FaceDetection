function y = predictCascade(cascade, X)

    y = 0;
    for i = 1:length(cascade)
        y = predict(cascade{i}, X);
        if y == 0
            return
        end
    end

end