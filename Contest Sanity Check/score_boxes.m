function score = score_boxes(candidate_bboxes, gt_bboxes)
    if(size(gt_bboxes,1)==0)
        if(size(candidate_bboxes,1)==0)
            score = 1;
            return;
        else
            score = 0;
            return;
        end
    elseif(size(candidate_bboxes,1)==0)
        score = 0;
        return;
    end    
    candidate_centers = zeros(size(candidate_bboxes,1),2);
    for i=1:size(candidate_bboxes,1)
        candidate_centers(i,:) = [(candidate_bboxes(i,1)+candidate_bboxes(i,3)/2) ...
                                  (candidate_bboxes(i,2)+candidate_bboxes(i,4)/2)];
    end
    gt_centers = zeros(size(gt_bboxes,1),2);
    for i=1:size(gt_bboxes,1)
        gt_centers(i,:) = [(gt_bboxes(i,1)+gt_bboxes(i,3)/2) ...
                           (gt_bboxes(i,2)+gt_bboxes(i,4)/2)];
    end
    dist_mat = pdist2(candidate_centers,gt_centers);
    [~,assigned_face] = min(dist_mat,[],2);
    if(min(candidate_bboxes(:,1))<1)
        x_offset = min(candidate_bboxes(:,1))+1;
        candidate_bboxes(:,1) = candidate_bboxes(:,1)+x_offset;
        gt_bboxes(:,1) = gt_bboxes(:,1)+x_offset;
    end
    if(min(candidate_bboxes(:,2))<1)
        y_offset = min(candidate_bboxes(:,2))+1;
        candidate_bboxes(:,2) = candidate_bboxes(:,2)+y_offset;
        gt_bboxes(:,2) = gt_bboxes(:,2)+y_offset;
    end
    width = ceil(max([candidate_bboxes(:,1)+candidate_bboxes(:,3); gt_bboxes(:,1)+gt_bboxes(:,3)]));
    height = ceil(max([candidate_bboxes(:,2)+candidate_bboxes(:,4); gt_bboxes(:,2)+gt_bboxes(:,4)]));
    [x_grid,y_grid] = meshgrid(1:width,1:height);
    F_scores = zeros(size(gt_bboxes,1),1);
    for i=1:size(gt_bboxes,1)
        candidates = find(assigned_face==i);
        gtbox = gt_bboxes(i,:);
        gtbox_verts = [gtbox(1) gtbox(2);
                          gtbox(1)+gtbox(3) gtbox(2);
                          gtbox(1)+gtbox(3) gtbox(2)+gtbox(4);
                          gtbox(1) gtbox(2)+ gtbox(4)];
        gtpoly = inpolygon(x_grid,y_grid,gtbox_verts(:,1), gtbox_verts(:,2));
        face_score = 0;
        for j=1:length(candidates)
            cbox = candidate_bboxes(candidates(j),:);
            cbox_verts = [cbox(1) cbox(2);
                          cbox(1)+cbox(3) cbox(2);
                          cbox(1)+cbox(3) cbox(2)+cbox(4);
                          cbox(1) cbox(2)+ cbox(4)];
            cpoly = inpolygon(x_grid,y_grid,cbox_verts(:,1), cbox_verts(:,2));
            po = sum(cpoly(:)&gtpoly(:));
            pb = sum(cpoly(:))-po;
            pg = sum(gtpoly(:))-po;
            P = po/(po+pb);
            R = po/(po+pg);
            if(P==0 && R==0)
                continue;
            else
                face_score = face_score+((2*P*R)/((P+R)*length(candidates)));
            end
        end
        F_scores(i) = face_score;
    end
    score = mean(F_scores);
end