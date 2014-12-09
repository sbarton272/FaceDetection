function [model] = load_model()
    %load('trainedModel.mat', 'model');

    addpath('../Code/smTraining/');
    load('smTraining/trainedModel.mat', 'model');
end