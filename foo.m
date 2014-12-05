function foo(f)
files = dir('.');

a = {};
n = 1;
for i = 1:length(files)
   name = files(i).name;
   if strcmp(name,'.') == 0 && strcmp(name,'..') == 0
     a{n} =  name;
     n = n + 1;
   end
end

data = a;
save(f,'data');
end