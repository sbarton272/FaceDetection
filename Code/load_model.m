function [model] = load_model()
    %load('trainedModel.mat', 'model');

    addpath('../Code/dev/');
    load('dev/trainedModel.mat', 'model');
end