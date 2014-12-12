
addpath('..')

f1 = [0,0,1,1,2];
f2 = [1,1,1,1,-1];
filters1 = {};
filters1{1} = [f1; f2];

filters = filters1;
filters{2} = f2;

I = ones(4);
iI = cumsum(cumsum(I),2)
iI2 = cumsum(cumsum(I.^2),2)

assert(calcFeatures(iI,iI2,1,1,1,filters1,[2 2]) == 0)
assert(calcFeatures(iI,iI2,1,2,1,filters1,[2 2]) == 0)
assert(calcFeatures(iI,iI2,1,1,2,filters1,[2 2]) == 0)

applyFilters({I}, filters, [2 2])

filters = generateFilters(4, 4);
for i = 1:length(filters)
   visualizeFilter(filters{i}, [4 4]);
   pause;
end