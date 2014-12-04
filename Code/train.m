function model = train(devFlag, testFlag)
%% Viola-Jones Training
%rng('default'); % For consistency

%% Consts
CASCADE_VERBOSE = true;

fRate = .3;
dRate = .99;
FRate = .001;

N = 1;
NPredToSample = 10;
eTemp = templateDiscriminant('DiscrimType','linear');
% Quadratic better, N can get too big

% Cascade specific
MAX_N = 10;
MAX_ENS = 20;
cTemp = templateDiscriminant('DiscrimType','linear','SaveMemory','on');

%% Load data or compute if not already computed
if devFlag
    FILTER_SIZE = [12 8];
    SAVE_DIR = 'dev/';
    FACE_DATA_FILE = '../LabeledData/devData.mat';
    NEG_EX_DIR = '../NegativeExamples/valNegExamples/';
	[posX, negX, filters] = loadExamples(SAVE_DIR, FACE_DATA_FILE, NEG_EX_DIR, FILTER_SIZE);
else
    FILTER_SIZE = [24 16];
    SAVE_DIR = 'training/';
    FACE_DATA_FILE = '../LabeledData/trainData.mat';
    NEG_EX_DIR = '../NegativeExamples/';
	[posX, negX, filters] = loadExamples(SAVE_DIR, FACE_DATA_FILE, NEG_EX_DIR, FILTER_SIZE);
end

SAVE_DIR = 'validation/';
FACE_DATA_FILE = '../LabeledData/valData.mat';
NEG_EX_DIR = '../NegativeExamples/valNegExamples/';
[valPX, valNX, ~] = loadExamples(SAVE_DIR, FACE_DATA_FILE, NEG_EX_DIR, FILTER_SIZE);

disp(['Num pos: ', num2str(size(posX,1)), ' Num  neg: ', num2str(size(negX,1))]);

%% Create X and Y
X = [posX; negX];
Y = [ones(size(posX,1),1); zeros(size(negX,1),1)];

%% Perform AdaBoost
ens = fitensemble(X,Y,'Subspace',N,eTemp,'NPredToSample',NPredToSample);

%% Determine utilized features for cascade
eFilterInd = find(sum(ens.UsePredForLearner,2) ~= 0);
eFiltersUsed = filters(eFilterInd);
disp('======================');
disp(['Num of filters used: ', num2str(length(eFilterInd))]);

%% Test how good the model is on training data
if testFlag
    x = [valPX; valNX];
    x(:,sum(ens.UsePredForLearner,2) == 0) = 0;
    y = predict(ens,x);
    Y = [ones(size(valPX,1),1); zeros(size(valNX,1),1)];
    posTrue = sum((y+Y) == 2);
    posFalse = sum((y-Y) == 1);
    disp(['Ens     D: ', num2str(posTrue / size(valPX,1)), ...
                 ' F: ', num2str(posFalse / size(valNX,1))]);
    disp('======================');
end

%% Perform cascade
cascade = generateCascade(posX,negX,fRate,dRate,FRate,cTemp,MAX_N,MAX_ENS,NPredToSample,CASCADE_VERBOSE);

%% Determine utilized features for cascade
used = zeros(size(X,2),1);
for i = 1:length(cascade)
    used = used + sum(cascade{i}.UsePredForLearner,2);
end
cFilterInd = find(used ~= 0);
cFiltersUsed = filters(cFilterInd);

disp('======================');
disp(['Num of filters used: ', num2str(length(cFilterInd))]);

%% Test how good the model is on training data
if testFlag
    pX = valPX;
    %pX(:,used == 0) = 0;
    nX = valNX;
    %nX(:,used == 0) = 0;
    [F, D, ~] = evalCascade(cascade, pX, nX);
    disp(['Cascade D :', num2str(D), ' F: ', num2str(F)]);
    disp('======================');
end

%% Creat model and save
model = struct('ens', ens, 'filterSize', FILTER_SIZE);
model.filters = eFiltersUsed;
model.numParams = length(filters);
model.filterInd = eFilterInd;
model.cascade = cascade;

if devFlag
    save('dev/trainedModel.mat', 'model');
else
    save('training/trainedModel.mat', 'model');
end

disp('Training complete');

end

%============================================

function [posX, negX, filters] = loadExamples(SAVE_DIR, FACE_DATA_FILE, ...
    NEG_EX_DIR, FILTER_SIZE)

%% Load training faces
try
	load([SAVE_DIR, 'faces.mat'], 'faces');
catch
	disp('Loading faces');
	faces = loadFaces(FACE_DATA_FILE, FILTER_SIZE(1), FILTER_SIZE(2));
	save([SAVE_DIR, 'faces.mat'], 'faces');
end

%% Load non-faces
try
	load([SAVE_DIR, 'nonFaces.mat'], 'nonFaces');
catch
	disp('Loading non-faces');
	nonFaces = loadNonFaces(NEG_EX_DIR, FILTER_SIZE(1), FILTER_SIZE(2));
	save([SAVE_DIR, 'nonFaces.mat'], 'nonFaces');
end

%% Generate filters
try
	load([SAVE_DIR, 'filters.mat'], 'filters');
catch
	disp('Generating filters');
	filters = generateFilters(FILTER_SIZE(1), FILTER_SIZE(2));
	save([SAVE_DIR, 'filters.mat'], 'filters');
end

%% Apply filters to faces
try
	load([SAVE_DIR, 'posX.mat'], 'posX');
catch
	disp('Generating positive example features');
	posX = applyFilters(faces, filters, FILTER_SIZE(1), FILTER_SIZE(2));
	save([SAVE_DIR, 'posX.mat'], 'posX');
end
 
%% Apply filters to non-faces
try
	load([SAVE_DIR, 'negX.mat'], 'negX');
catch
	disp('Generating negative example features');
	negX = applyFilters(nonFaces, filters, FILTER_SIZE(1), FILTER_SIZE(2));
	save([SAVE_DIR, 'negX.mat'], 'negX');
end

end
