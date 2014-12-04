function [F, D, N] = evalCascade(cascade, valP, valN)
    
    nP = size(valP, 1);
    nN = size(valN, 1);

    %% Evaluate at each level of the cascade passing on the detections
    for i = 1:length(cascade)
        yP = predict(cascade{i}, valP);
        valP = valP(yP == 1,:);

        yN = predict(cascade{i}, valN);
        valN = valN(yN == 1,:);
    end
    
    N = valN;
    D = size(valP,1) / nP;
    F = size(valN,1) / nN;
    
end