% this script will...
% run the ANN with the previous best driver, and all other drivers
%
% Edited by LPA
%
% To do:
% 1) Remove best driver from 'driverIndex,' and add it to 'inputs' below 
% (unless running as part of big for loop such as run all eco pheno 
% workspaces or run all years.
% 2) Make sure all drivers (except best) are in driverIndex
% 3) Make sure correct 'target' column is selected under 'set what the ANN
% is trained to'--For no gap-filled, use column 6.  See header of
% master_neuralnetdriveranalysis.  Now this is automatic based on HD and
% TAR.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% % Remove the best driver from driverIndex, add it to inputs
for driverIndex=[columns.T21m...
        columns.ws21m columns.wd21m...
        columns.ustar21m columns.precipmm...
        columns.vpd columns.Tsoil...
        columns.Rppfdin columns.Rnet25... 
        columns.RH8m columns.h2osoil...
        columns.swe]; %                     
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% TRAIN THE ANN
    
    % print site/year to screen
    fprintf('%c','Best driver plus all other drivers');
    fprintf('%c\n',' ');
    
    % define the inputs (best driver plus driver index)
%     best_driver = strcat('columns.',char(orderedDriver(1)));        % Gives name of best driver
%     inputs = subDriversMonths(:,[eval(best_driver) driverIndex])';  %Use this plus line above for subset year/month data, when running run_all_eco_pheno_periods or run_all_periods_each_year
      inputs = subDriversMonths(:,[columns.Tsoil driverIndex])';    %Use this for subset year/month data, when running for one period
    
    % set what the ANN is trained to (set in master_neuralNetDriver)
    if TAR ==0
        if HD == 1
            targets = subDataMonths(:,6)';    %Use this for subset of years and months, nights (U* applied), NEE target
        elseif HD == 2
            targets = subDataMonths(:,7)';    %Use this for subset of years and months, days,  NEE target
        end
    elseif TAR ==1
        if HD ==1
            targets = subDataMonths(:,19)';      %Use this for subset of years and months, nights (U* applied) water flux
        elseif HD ==2
            targets = subDataMonths(:,13)';     %Use this for subset of years and months, days water flux
        end
    end
    
    % Create a Fitting Network
    hiddenLayerSize = 8;
    
    net1 = fitnet(hiddenLayerSize);
    
    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net1.inputs{1}.processFcns = {'mapminmax'}; %'removeconstantrows' doesn't seem necessary
    net1.outputs{2}.processFcns = {'mapminmax'};
    
    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivide
    net1.divideFcn = 'dividerand';  % Divide data randomly
    net1.divideMode = 'sample';  % Divide up every sample
    
    training=60;
    validating=20;
    testing=20;
    
    net1.divideParam.trainRatio = training/100;
    net1.divideParam.valRatio = validating/100;
    net1.divideParam.testRatio = testing/100;
    
    % For help on training function 'trainlm' type: help trainlm
    % For a list of all training functions type: help nntrain
    net1.trainFcn = 'trainlm';  % Levenberg-Marquardt
    
    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net1.performFcn = 'mse';  % Mean squared error
    
    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net1.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
        'plotregression', 'plotfit'};
    
    net1.trainParam.epochs = 50;
    net1.trainParam.goal = 0.0001;
    
    net1.trainParam.showWindow = false;
    net1.trainParam.showCommandLine = false;
    
    % Create cell array to store the n=numRuns number of networks
    twoDriverNet = cell(numRuns,1); % Initialize cell array to hold networks
    
    % Train the Network
    clear outputs1 testPerformance
    
    for ii=1:numRuns
        [net,tr] = train(net1,inputs,targets);
        outputs = net(inputs);
        
        errors = gsubtract(targets,outputs);
        performance = perform(net,targets,outputs);
        
        % Recalculate Training, Validation and Test Performance
        trainTargets = targets .* tr.trainMask{1};
        valTargets = targets  .* tr.valMask{1};
        testTargets = targets  .* tr.testMask{1};
        trainPerformance(ii) = perform(net,trainTargets,outputs);
        valPerformance(ii) = perform(net,valTargets,outputs);
        testPerformance(ii) = perform(net,testTargets,outputs);
        
        % Calculate the r2 of the 10 ANN training runs (ultimately for standard deviation)
        tmpR_ii = corrcoef(outputs,targets,'rows','pairwise');
        numruns_r2_b(ii) = tmpR_ii(1,2)^2;
        
        % Save networks in cell array so we can use the best
        twoDriverNet{ii} = net;
        
        outputs1(ii,:) = outputs;
        clear outputs net train errors performance trainTargets valTargets testTargets
        clear trainPerformance valPerformance tmpR_ii
    end
    
    
    % use output from the best performing network
    
    best=find(testPerformance==min(testPerformance));
    if length(best)>1
        % to account for the possiblility that there is more than one,
        % or no, best ANN
        best=best(1);
    end
    
    % Put the best performing network into the
    % oneDriverBestNet array so it can be saved (looped for each driver)
    counter = [counter+1];                                      % This increases by one each time through driverIndex loop
    if exist('eco_pheno_periods')
        twoDriverBestNet{counter,kk} = twoDriverNet{best,1};    % Assign name to the best network in the cell array oneDriverNet.  If looping through eco pheno periods, one column in oneDriverBestNet for each period
    else
        twoDriverBestNet{counter} = twoDriverNet{best,1};       % Assign name to the best network in the cell array oneDriverNet
    end
    
    %tmpR=corrcoef(outputs1(best,:),targets); % Trevor's original code, which doesn't work with missing values.
    tmpR_b=corrcoef(outputs1(best,:),targets,'rows','pairwise'); %This excludes NaNs. Since it is only comparing two things, I think 'pairwise' and 'complete' are the same in this case.  (Applying 'pairwise' Trevor's original example script does not change r value)
    r2b(1,driverIndex)=tmpR_b(1,2)^2;
    
    % Calculate sample size n for correlation coefficient (for z transform later)
    %  r_n_b(1,driverIndex) = min([sum(~isnan(outputs1(best,:))), sum(~isnan(targets))]);
    % NOTE; ABOVE LINE was used for the Oecologia run, but logic wasn't
    % right. Use something like this instead in the future:     nanrows = isnan(targets)+isnan(B); sum(nanrows(:)==0)
    % See also sample size table from Extract_n_r_for_FisherT.m
    
    %RMSEb(1,driverIndex)=rms(outputs1(best,:)-targets); %doesn't work with nans
    RMSEb(1,driverIndex)=nanrms(outputs1(best,:)-targets);
    
    outputsb{driverIndex}=outputs1(best,:);
    
    % Calculate standard deviation of the r2 for all of the 10 runs
    std_all_r2_b(1,driverIndex)=std(numruns_r2_b); %This is what is saved in the workspaces, normalizes by n-1
    std_all_r2_b_pop(1,driverIndex)=std(numruns_r2_b,1); %This is what I want--'population' standard deviation (normalized by n).  Calculated later in workspaces: Convert_std_for_numRuns.m
    
    % Calculate the mean of the r2 for all for the 10 runs
    mean_all_r2_b(1,driverIndex)=mean(numruns_r2_b);
    
    fprintf('Test Performance: %f\n',testPerformance);
    fprintf('-------------------- \n');
    
    
end


% clear output numYears indexx inputs j net outputs performance error endx
% clear hiddenLayerSize test* tr* val* tmp* driverIndex
% clear i errors startx

