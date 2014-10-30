function [i,j] = anms(surface,thresh)
    shifts = zeros(size(surface,1),size(surface,2),9);
    shifts(:,:,1) = surface;
    shifts(2:end,2:end,2) = surface(1:end-1,1:end-1);
    shifts(2:end,:,3) = surface(1:end-1,:);
    shifts(2:end,1:end-1,4) = surface(1:end-1,2:end);
    shifts(:,2:end,5) = surface(:,1:end-1);
    shifts(:,1:end-1,6) = surface(:,2:end);
    shifts(1:end-1,2:end,7) = surface(2:end,1:end-1);
    shifts(1:end-1,:,8) = surface(2:end,:);
    shifts(1:end-1,1:end-1,9) = surface(2:end,2:end);
    [maxes,inds] = max(shifts,[],3);
    maxes = maxes.*(inds==1);
    maxes = maxes>thresh;
    [i,j] = find(maxes~=0);
end