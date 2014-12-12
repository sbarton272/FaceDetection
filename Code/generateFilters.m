function filters = generateFilters(height, width)

filters = {};
n = 1;

SCAN_X = 2;
SCAN_Y = 4;

%% Horizontal bars
MIN_WIDTH = 4;
MIN_HEIGHT = 4;
Y_STEP = 2;
for x1 = 0:SCAN_X:width
	for y1 = 0:SCAN_Y:height
		for x2 = (x1+MIN_WIDTH):width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				h = int32((y2-y1)/2);
				f1 = [x1,y1,x2-x1,h,1];
				f2 = [x1,y1+h,x2-x1,h,-1];
				filters{n} = [f1; f2];
				n = n + 1;
			end
		end
	end
end

%% Vertical bars
MIN_WIDTH = 4;
MIN_HEIGHT = 4;
X_STEP = 2;
for x1 = 0:SCAN_X:width
	for y1 = 0:SCAN_Y:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):height
				w = int32((x2-x1)/2);
				f1 = [x1,y1,w,y2-y1,1];
				f2 = [x1+w,y1,w,y2-y1,-1];
				filters{n} = [f1; f2];
				n = n + 1;
			end
		end
	end
end

%% Horizontal 3 bars
MIN_WIDTH = 4;
MIN_HEIGHT = 6;
Y_STEP = 3;
for x1 = 0:SCAN_X:width
	for y1 = 0:SCAN_Y:height
		for x2 = (x1+MIN_WIDTH):width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				h = int32((y2-y1)/3);
				f1 = [x1,y1,    x2-x1,3*h,1];
				f2 = [x1,y1+h,  x2-x1,h,-2];
				filters{n} = [f1; f2];
				n = n + 1;
			end
		end
	end
end

%% Vertical 3 bars
MIN_WIDTH = 6;
MIN_HEIGHT = 4;
X_STEP = 3;
for x1 = 0:SCAN_X:width
	for y1 = 0:SCAN_Y:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):height
				w = int32((x2-x1)/3);
				f1 = [x1,    y1,3*w,y2-y1,1];
				f2 = [x1+w,  y1,w,y2-y1,-2];
				filters{n} = [f1; f2];
				n = n + 1;
			end
		end
	end
end

%% XOR Squares
MIN_WIDTH = 8;
MIN_HEIGHT = 8;
X_STEP = 2;
Y_STEP = 2;
for x1 = 0:SCAN_X:width
	for y1 = 0:SCAN_Y:height
		for x2 = (x1+MIN_WIDTH):X_STEP:width
			for y2 = (y1+MIN_HEIGHT):Y_STEP:height
				w = int32((x2-x1)/2);
				h = int32((y2-y1)/2);
				filters{n} = [x1,   y1,   2*w, 2*h, 1; ...
							  x1+w, y1,   w,   h,  -2; ...
							  x1,   y1+h, w,   h,  -2];
				n = n + 1;
			end
		end
	end
end

end