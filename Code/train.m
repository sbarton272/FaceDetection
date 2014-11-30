function model = train(devFlag)
%% Viola-Jones Training

if devFlag
	[posX negX] = loadDevExamples();
else
	[posX negX] = loadExamples();
end

%% Create X and Y
X = [posX; negX];
Y = [ones(size(posX,1),1); zeros(size(negX,1),1)];

%% Perform AdaBoost
% TODO create cascade
N = 100;
model = fitensemble(X,Y,'Subspace',N,'Discriminant');

% Apply with predict(ens,Xi)
if devFlag
    save('dev/trainedModel.mat', 'model');    
else
    save('training/trainedModel.mat', 'model');
end

end

%============================================

function [posX negX] = loadExamples();

% Constants
FACE_DATA_FILE = '../LabeledData/trainData.mat';
NEG_EX_DIR = '../NegativeExamples/';

FILTER_SIZE = [16 24];

%% Load training faces
try
	load('training/faces.mat', 'faces');
catch
	disp('Loading faces');
	faces = loadFaces(FACE_DATA_FILE, FILTER_SIZE(1), FILTER_SIZE(2));
	save('training/faces.mat', 'faces');
end

%% Load non-faces
try
	load('training/nonFaces.mat', 'nonFaces');
catch
	disp('Loading non-faces');
	nonFaces = loadNonFaces(NEG_EX_DIR, FILTER_SIZE(1), FILTER_SIZE(2));
	save('training/nonFaces.mat', 'nonFaces');
end

%% Generate filters
try
	load('training/filters.mat', 'filters');
catch
	disp('Generating filters');
	filters = generateFilters(FILTER_SIZE(1), FILTER_SIZE(2));
	save('training/filters.mat', 'filters');
end

%% Apply filters to faces
try
	load('training/posX.mat', 'posX');
catch
	disp('Generating positive example features');
	posX = applyFilters(faces, filters);
	save('training/posX.mat', 'posX');
end
 
%% Apply filters to non-faces
try
	load('training/negX.mat', 'negX');
catch
	disp('Generating negative example features');
	negX = applyFilters(nonFaces, filters);
	save('training/negX.mat', 'negX');
end

end

%============================================

function [posX negX] = loadDevExamples();

% Constants
FACE_DATA_FILE = '../LabeledData/devData.mat';
NEG_EX_DIR = '../NegativeExamples/devNegExamples/';

FILTER_SIZE = [3 6];

%% Load dev faces
try
	load('dev/faces.mat', 'faces');
catch
	disp('Loading faces');
	faces = loadFaces(FACE_DATA_FILE, FILTER_SIZE(1), FILTER_SIZE(2));
	save('dev/faces.mat', 'faces');
end

%% Load non-faces
try
	load('dev/nonFaces.mat', 'nonFaces');
catch
	disp('Loading non-faces');
	nonFaces = loadNonFaces(NEG_EX_DIR, FILTER_SIZE(1), FILTER_SIZE(2));
	save('dev/nonFaces.mat', 'nonFaces');
end

%% Generate filters
try
	load('dev/filters.mat', 'filters');
catch
	disp('Generating filters');
	filters = generateFilters(FILTER_SIZE(1), FILTER_SIZE(2));
	save('dev/filters.mat', 'filters');
end

%% Apply filters to faces
try
	load('dev/posX.mat', 'posX');
catch
	disp('Generating positive example features');
	posX = applyFilters(faces, filters);
	save('dev/posX.mat', 'posX');
end
 
%% Apply filters to non-faces
try
	load('dev/negX.mat', 'negX');
catch
	disp('Generating negative example features');
	negX = applyFilters(nonFaces, filters);
	save('dev/negX.mat', 'negX');
end

end