function ens = train()
%% Viola-Jones Training

% Positive examples
FACE_DATA_FILE = '../LabeledData/devData.mat';
NEG_EX_DIR = '../NegativeExamples/';

FILTER_SIZE = [16 24];

%% Load training faces
try
	load('faces.mat', faces);
catch
	faces = loadFaces(FACE_DATA_FILE, FILTER_SIZE(1), FILTER_SIZE(2));
	save('faces.mat', faces);
end

%% Load non-faces
try
	load('nonFaces.mat', nonFaces);
catch
	nonFaces = loadNonFaces(NEG_EX_DIR, FILTER_SIZE(1), FILTER_SIZE(2));
	save('nonFaces.mat', nonFaces);
end

%% Generate filters
try
	load('filters.mat', filters);
catch
	filters = generateFilters(FILTER_SIZE(1), FILTER_SIZE(2));
	save('filters.mat', filters);
end

%% Apply filters to faces
try
	load('posX.mat', posX);
catch
	posX = applyFilters(faces, filters);
	save('posX.mat', posX);
end
 
%% Apply filters to non-faces
try
	load('negX.mat', negX);
catch
	negX = applyFilters(nonFaces, filters);
	save('negX.mat', negX);
end

%% Create X and Y
X = [posX; negX];
Y = [ones(size(posX,1),1), zeros(size(negX,1),1)];

%% Perform AdaBoost
N = 1; % TODO create cascade
ens = fitensemble(X,Y,'Subspace',N,'Discriminant');
ens

% Apply with predict(ens,Xi)

save('trainedModel.mat', ens);

end