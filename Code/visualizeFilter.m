function visualizeFilter(filters, sz)

viz = zeros(sz);

for i = 1:size(filters,1)
   f = filters(i,:);
   x = f(1);
   y = f(2);
   w = f(3);
   h = f(4);
   weight = f(5);
   
   % Filters zero indexed
   x = x+1;
   y = y+1;
   
   viz(y:y+h-1,x:x+w-1) = weight;
end

mn = min(min(viz));
mx = max(max(viz));
viz = (viz - mn) / (mx - mn);
imshow(viz);

end