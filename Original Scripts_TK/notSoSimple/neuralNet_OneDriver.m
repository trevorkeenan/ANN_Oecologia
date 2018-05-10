% script will...
% run the ANN with each driver individually
%
% LPA edited
% To do:
% 1) make sure correct 'target' column is selected under 'set what the ANN
% is trained to.'--For no gap-filled, use column 6.  See header of
% master_neuralnetdriveranalysis.  Now this is automatic based on HD and
% TAR
% 2) In 'loop over all drivers' section, make sure it is through the total
% number of columns you want (i.e driverIndex includes all the columns you want).
%
% To fix/add/ideas
% Could add 'oneDriverBestNet' to the beginning of
% 'run_all_eco_pheno_periods' so that the columns not equal to the current
% loop index are not over-written by new creation of cell array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Initialize things
% cell array to hold the best network for each driver
if exist('eco_pheno_periods')      % If looping through all eco_pheno_periods, want one column for each eco pheno period and one row per individual input driver
    oneDriverBestNet = cell(length(fieldnames(columns)),length(eco_pheno_periods));
else
    oneDriverBestNet = cell(length(fieldnames(columns)),1); % length(fieldnames(columns)) should match number of drivers in driverIndex below
end
% Counter for use indexing cell array
counter = 0;

% % loop over all drivers.  Add and subtract drivers as desired.
for driverIndex=[columns.T21m... 
        columns.ws21m columns.wd21m...
        columns.ustar21m columns.precipmm...
        columns.vpd columns.Tsoil...
        columns.Rppfdin columns.Rnet25...
        columns.RH8m...
        columns.swe]; %    columns.h2osoil 
    
    % print to screen
    fprintf('%c','Testing the predictive power of each driver');
    fprintf('%c\n',' ');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          Run the Artificial Neural Network
    
    % define the inputs
    %identify which spot in the list of drivers is labeled by driverIndex
    %inputs = driversDaily(:,driverIndex)'; %Use this for all data (not subset by loadObsAndDrivers)
    inputs = subDriversMonths(:,driverIndex)'; %Use this for subset year/month data
    
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
            targets = subDataMonths(:,13)';         %Use this for subset of years and months, days water flux
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
    oneDriverNet = cell(numRuns,1); % Initialize cell array to hold networks
    
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
        numruns_r2_oneDriver(ii) = tmpR_ii(1,2)^2;
        
        % Save networks in cell array so we can use the best
        oneDriverNet{ii} = net;
        
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
        oneDriverBestNet{counter,kk} = oneDriverNet{best,1};    % Assign name to the best network in the cell array oneDriverNet.  If looping through eco pheno periods, one column in oneDriverBestNet for each period
    else
        oneDriverBestNet{counter} = oneDriverNet{best,1};       % Assign name to the best network in the cell array oneDriverNet
    end
    
    % Plot the outputs of the best single-driver ANN versus targets (looped for each driver)
    if onedriverplots == 1
        addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts')
        run plot_single_input_ANN.m
    else
    end
    
    % Calculate r2 and rmse for the 'best' network 
    % (note: driverIndex number used as column index to save r2, rmse and standard deviation for all drivers in driverIndex)
    % tmpR=corrcoef(outputs1(best,:),targets); % Trevor's original code, which doesn't work with missing values. 
    tmpR_prim=corrcoef(outputs1(best,:),targets,'rows','pairwise'); %This excludes NaNs. Since it is only comparing two things, I think 'pairwise' and 'complete' are the same in this case.  (Applying 'pairwise' Trevor's original example script does not change r value)
    r2(1,driverIndex)=tmpR_prim(1,2)^2;
    
    % Calculate sample size n for correlation coefficient (for z transform later)
    % r_n_prim(1,driverIndex) = min([sum(~isnan(outputs1(best,:))), sum(~isnan(targets))]);
    % NOTE; ABOVE LINE was used for the Oecologia run, but logic wasn't
    % right. Use something like this instead in the future:     test=sum(~any(isnan([targets; inputs]), 1)); % concatenate and test along columns
    % See also sample size table from Extract_n_r_for_FisherT.m
    
    %RMSE(1,driverIndex)=rms(outputs1(best,:)-targets); %doesn't work with nans
    RMSE_prim(1,driverIndex)=nanrms(outputs1(best,:)-targets);
    
    outputs{driverIndex}=outputs1(best,:);
    
    % Calculate standard deviation of the r2 for all of the 10 runs
    std_all_r2_oneDriver(1,driverIndex)=std(numruns_r2_oneDriver); %This is what is saved in the old workspaces, normalizes by n-1
    std_all_r2_oneDriver_pop(1,driverIndex)=std(numruns_r2_oneDriver,1); %This is what I want--'population' standard deviation (normalized by n).   Calculated later in workspaces: Convert_std_for_numRuns.m
    
    % Calculate the mean of the r2 for all for the 10 runs
    mean_all_r2_oneDriver(1,driverIndex)=mean(numruns_r2_oneDriver);
    
    fprintf('Test Performance: %f\n',testPerformance);
    fprintf('-------------------- \n');
end

clear output outputs numYears indexx j net performance error endx inputs
clear test* tr* val* tmp* driverIndex
clear i errors startx oneDriverNet ii %hiddenLayerSize




