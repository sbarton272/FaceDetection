function [s,e] = sanityCheck(sdir)
    % extract zip file
    try
         unzip([sdir '18794_contest.zip'], sdir);
    catch ME
        s = false;
        e = 'error invalid zip file';
        return;
    end
    % check for load_model.m file
    if ~exist([sdir 'load_model.m'],'file')
        s = false; 
        e = 'error load_model.m file missing';
        return;
    end
    % check for detect_faces.m file
    if ~exist([sdir 'detect_faces.m'],'file')
        s = false; 
        e = 'error detect_faces.m file missing';
        return;
    end
    % check for algorithm.txt
    if ~exist([sdir 'algorithm.txt'],'file')
        s = false; 
        e = 'error algorithm.txt file missing';
        return;
    end
    s = true;
    e = '';
    return;
end