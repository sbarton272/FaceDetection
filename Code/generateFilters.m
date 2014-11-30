function filters = generateFilters(height, width)

filters = {};
n = 1;

%% Horizontal bars
MIN_WIDTH = 4;
MIN_HEIGHT = 2;
Y_STEP = 2;
for x1 = 0:width
	for y1 = 0:height
		for x2 = (x1+MIN_WIDTH):width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				h = uint32((y2-y1)/2);
				f1 = newFilter(x1,y1,x2-x1,h,1);
				f2 = newFilter(x1,y1+h,x2-x1,h,-1);
				filters{n} = [f1 f2];
				n = n + 1;
			end
		end
	end
end

%% Vertical bars
MIN_WIDTH = 2;
MIN_HEIGHT = 4;
X_STEP = 2;
for x1 = 0:width
	for y1 = 0:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):height
				w = uint32((x2-x1)/2);
				f1 = newFilter(x1,y1,w,y2-y1,1);
				f2 = newFilter(x1+w,y1,w,y2-y1,-1);
				filters{n} = [f1 f2];
				n = n + 1;
			end
		end
	end
end

%% Horizontal 3 bars
MIN_WIDTH = 4;
MIN_HEIGHT = 3;
Y_STEP = 3;
for x1 = 0:width
	for y1 = 0:height
		for x2 = (x1+MIN_WIDTH):width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				h = uint32((y2-y1)/3);
				f1 = newFilter(x1,y1,    x2-x1,h,1);
				f2 = newFilter(x1,y1+h,  x2-x1,h,-1);
				f3 = newFilter(x1,y1+2*h,x2-x1,h,1);
				filters{n} = [f1 f2 f3];
				n = n + 1;
			end
		end
	end
end

%% Vertical 3 bars
MIN_WIDTH = 3;
MIN_HEIGHT = 4;
X_STEP = 3;
for x1 = 0:width
	for y1 = 0:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):height
				w = uint32((x2-x1)/3);
				f1 = newFilter(x1,    y1,w,y2-y1,1);
				f2 = newFilter(x1+w,  y1,w,y2-y1,-1);
				f3 = newFilter(x1+2*w,y1,w,y2-y1,1);
				filters{n} = [f1 f2 f3];
				n = n + 1;
			end
		end
	end
end

%% XOR Squares
MIN_WIDTH = 2;
MIN_HEIGHT = 2;
X_STEP = 2;
Y_STEP = 2;
for x1 = 0:width
	for y1 = 0:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				w = uint32((x2-x1)/2);
				h = uint32((y2-y1)/2);
				f1 = newFilter(x1,   y1,   w,h, 1);
				f2 = newFilter(x1+w, y1,   w,h,-1);
				f3 = newFilter(x1,   y1+h, w,h,-1);
				f4 = newFilter(x1+w, y1+h, w,h, 1);
				filters{n} = [f1 f2 f3 f4];
				n = n + 1;
			end
		end
	end
end

end

function f = newFilter(x,y,w,h,weight)
	f = struct('x',x,'y',y,'w',w,'h',h,'weight',weight);
end