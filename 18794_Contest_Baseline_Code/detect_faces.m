function [bboxes] = detect_faces(frame,model)
    if(size(frame,3)>1)
        frame = rgb2gray(frame);
    end
    frame = double(frame);
    im_size = size(frame);
    resize_scale = .5;
    bbox_size = size(model.avg_face);
    bboxes = [];
    ind = 0;
    while(size(frame,1)>4*size(model.avg_face,1) && size(frame,2)>4*size(model.avg_face,2))
        ind = ind+1;
        frame = imresize(frame,resize_scale);    
        bbox_size = bbox_size/resize_scale;
        face_output = imfilter(frame,model.avg_face,'replicate');
        output = face_output;
        [y,x] = anms(abs(output),10^6);
        y = y/(resize_scale^ind);
        x = x/(resize_scale^ind);
        for i=1:length(y)
            x1 = floor(x(i)-bbox_size(2)/2);
            y1 = floor(y(i)-bbox_size(1)/2);
            x2 = x1+bbox_size(2)-1;
            y2 = y1+bbox_size(1)-1;
            x1 = max(x1,1);
            y1 = max(y1,1);
            x2 = min(x2,im_size(2));
            y2 = min(y2,im_size(1));
            bboxes = [bboxes; x1 y1 x2-x1+1 y2-y1+1];
        end
    end
end