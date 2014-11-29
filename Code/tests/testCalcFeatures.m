
addpath('..')

f1 = struct('x',0,'y',0,'w',1,'h',1,'weight',2);
f2 = struct('x',1,'y',1,'w',1,'h',1,'weight',-1);
filters = {};
filters{1} = [f1; f2];

I = ones(4);
iI = cumsum(cumsum(I),2)

assert(calcFeatures(iI,1,1,1,filters) == 1)
assert(calcFeatures(iI,1,2,1,filters) == 1)
assert(calcFeatures(iI,1,1,2,filters) == 4)