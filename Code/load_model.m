function [model] = load_model()
    %load('trainedModel.mat', 'model');

    addpath('../Code/training/');
    load('training/trainedModel.mat', 'model');
end