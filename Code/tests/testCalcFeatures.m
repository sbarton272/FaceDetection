
addpath('..')

f1 = struct('x',0,'y',0,'w',1,'h',1,'weight',2);
f2 = struct('x',1,'y',1,'w',1,'h',1,'weight',-1);
filters1 = {};
filters1{1} = [f1; f2];

filters = filters1;
filters{2} = f2;

I = ones(4);
iI = cumsum(cumsum(I),2)

assert(calcFeatures(iI,0,0,1,filters1) == 1)
assert(calcFeatures(iI,0,1,1,filters1) == 1)
assert(calcFeatures(iI,0,0,2,filters1) == 4)

applyFilters({I}, filters)