function cascade = generateCascade(P,N,f,d,Ftarget,temp,NPredToSample,verbose)

disp(['Training cascade f:', num2str(f), ' d:', num2str(d),...
      ' Ftarget:', num2str(Ftarget)]);

MAX_N = 1;
MAX_ENS = 4;
  
F = 1;
D = 1;
cascade = {};
Npass = N;

%% Generate cascades until false detect rate is below target
i = 0;
while F > Ftarget
    i = i + 1;
    
    %% Train new ensamble with false detects from prior ensamble
    X = [P; Npass];
    Y = [ones(size(P,1),1); zeros(size(Npass,1),1)];
    n = 0; % Number of features in ensamble
    Fi = F;
    
    %% Add weak learners to learner until it meets cascade false detect req
    while Fi > f*F
        n = n + 1;
    
        % Train until high enough detect rate
        for costNotDetect = 1:.1:2
            C = [0 (2 - costNotDetect); costNotDetect 0];
            cascade{i} = fitensemble(X,Y,'Subspace',n,temp,...
                            'NPredToSample',NPredToSample,'Cost',C);
            [Fi, Di, ~] = evalCascade(cascade, P, Npass);
            % Increase cost of not detecting until enough detected
            if Di > d*D
                break
            end
        end
        if verbose
            disp(['Chose cost:', num2str(costNotDetect), ' Di:', num2str(Di),...
              ' Fi:', num2str(Fi)]);
        end
          
        if n >= MAX_N
            break 
        end
        
    end
    
    %% Weak learned added, update false detects and rates
    [F, D, Npass] = evalCascade(cascade, P, N);
    
	if verbose
        disp(['Weak learner added i:', num2str(i), ' n:', num2str(n),...
            ' F:', num2str(F), ' D:', num2str(D)]);
    end
        
    if i >= MAX_ENS
        break 
    end
end

end