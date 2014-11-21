function evaluate(codeDir, devFlag)
    addpath(codeDir)

    %% run sanity check
    [s,e] = sanityCheck(codeDir);
    if s
        disp('Passed Sanity Check, Evaluating...');

        %% Load appropriate data
        if devFlag
            load('../LabeledData/devData.mat', 'devData');
            data = devData;
        else
            load('../LabeledData/testData.mat', 'testData');
            data = testData;
        end

        try
            %% Evaluate code if sanity check passed
            [score, e] = evaluateCode(data, devFlag);
            disp('Evaluation Completed Successfully');
            disp(['Score: ',  num2str(score), ' on ', num2str(length(data)), ' images'])
        catch ME
            disp(['Evaluation Failed: ' ME.message]);
        end
    else
        disp('Failed Sanity Check');
    end
    disp('DONE.');

end