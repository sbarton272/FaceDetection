function centroids = combineBb(bb)

N = size(bb,1);

centroids = combine(bb,2);
while N ~= size(centroids,1);
    N = size(centroids,1);
    centroids = combine(centroids,1);
end

end

function centroids = combine(bb,k)

N = size(bb,1);
centroids = [];
for i = 1:N
    [O,~] = overlapedBoxes(bb(i,:), bb);
    numO = size(O,1);
    if numO >= k
       centers = [O(:,1) + O(:,3)/2, O(:,2) + O(:,4)/2];
       m = mean(centers,1);
       d = mean(O,1);
       C = [m(1) - d(3)/2, m(2) - d(4)/2, d(3), d(4)];
       centroids = [centroids; C];
    end
end

centroids = unique(centroids,'rows');

end