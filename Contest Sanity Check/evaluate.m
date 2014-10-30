%% run sanity check
[s,e] = sanityCheck('Submission\');
if s
    disp('Passed Sanity Check, Evaluating...');
    curdir = cd;
    load('ExampleData.mat');
    try
        %% Evaluate code if sanity check passed
        [score, e] = evaluateCode('Submission\', ExampleData);
        disp('Evaluation Completed Successfully');
    catch ME
        chdir(curdir);
        disp(['Evaluation Failed: ' ME.message]);
    end
else
    disp('Failed Sanity Check');
end
disp('DONE.');