function I = preprocessImg(I)
    % Convert to greyscale if necessary
    if(size(I,3)>1)
        I = rgb2gray(I);
    end
    I = im2double(I);
end