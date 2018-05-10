% This script was adapted from neuralNet_OneDriver
% Goal is to run many single driver ANNs to make plot of average
% predictions.  Script runs within 'master_neuralNetDriverAnalysis.m,' or
% on previously saved workspace (in which case, make sure all variables are
% defined, such as 'year_consecutive')
%
% script will...
% run the ANN with each driver individually a set number of times to run
% with plot_MANY_single_input_ANNs.m, which will plot 'average' ANN
% response function and standard error.
% 
%
% LPA edited
% To do:
% 1) make sure correct 'target' column is selected under 'set what the ANN
% is trained to.' (Currently automatically set based on TAR setting in
% master_neuralnetdriveranalysis. See header of master_neuralnetdriveranalysis.)
% 2) In 'loop over all drivers' section, make sure driverIndex has all the
% desired columns
%
% To fix/add/ideas
% To fix:
% 1) Since 2013 was added, check max/min values for x axis limits when 
% HD ==1 (HD ==2 was already checked if present).  Also some HD ==1 were never
% added.  These x axis limits are defined in plot_MANY_single_input_ANNs.
% Other ideas:
% Could add 'oneDriverBestNet' to the beginning of
% 'run_all_eco_pheno_periods' so that the columns not equal to the current
% loop index are not over-written by new creation of cell array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Changeable options (also see loop over all drivers)
% set number of runs
PlotNumRuns = 100;

% Decide whether to have consistent x min and max for axes in figures
% produced by plot_MANY_single_input_ANNs.  Choose 0 for matlab defaults;
% choose 1 for consistent x axes.
consistent_x_ax = 0;

% Show response curves in terms of NEE or NEP? For NEE, set 'response_NEE =1'
% For NEP, set response_NEE = 0.  Note that if TAR ==1 (for H2O flux) then
% response_NEE setting doesn't matter.
response_NEE = 0;

%% Initialize things
% cell array to hold the best network for each driver
if exist('eco_pheno_periods')      % If looping through all eco_pheno_periods, want one column for each eco pheno period and one row per individual input driver
    oneDriverBestNet = cell(length(fieldnames(columns)),length(eco_pheno_periods));
else
    oneDriverBestNet = cell(length(fieldnames(columns)),1); % length(fieldnames(columns)) should match number of drivers in driverIndex below
end

% Counter for use indexing cell array
counter = 0;

%% loop over all drivers.  Add and subtract drivers as desired.
for driverIndex=[columns.T21m... 
        columns.ws21m columns.wd21m...
        columns.ustar21m columns.precipmm...
        columns.vpd columns.Tsoil...
        columns.Rppfdin columns.Rnet25...
        columns.RH8m columns.h2osoil...
        columns.swe]; %     
    
    % print to screen
    fprintf('%c','Testing the predictive power of each driver');
    fprintf('%c\n',' ');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          Run the Artificial Neural Network
    
    % define the inputs
    %identify which spot in the list of drivers is labeled by driverIndex
    %inputs = driversDaily(:,driverIndex)'; %Use this for all data
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
    
    % Train the Network
    clear outputs1 testPerformance
    
    oneDriverNets = cell(PlotNumRuns,1); % Initialize cell array to hold networks
    for ii=1:PlotNumRuns
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
        
        % Save networks so we can use the best
        oneDriverNets{ii} = net;
        
        outputs1(ii,:) = outputs;
        clear outputs net train errors performance trainTargets valTargets testTargets
        clear trainPerformance valPerformance
    end
   
    % Add one to counter each time through loop (for use with
    % plot_MANY_single_input_ANNs.m)
    counter = [counter+1];
    
    % Plot the outputs of the best single-driver ANN versus targets (looped for each driver)
    addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts')
    addpath('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts')
    run plot_MANY_single_input_ANNs.m

    
    %tmpR=corrcoef(outputs1(best,:),targets); % Trevor's original code, which doesn't work with missing values. 
    tmpR=corrcoef(outputs1(best,:),targets,'rows','pairwise'); %This excludes NaNs. Since it is only comparing two things, I think 'pairwise' and 'complete' are the same in this case.  (Applying 'pairwise' Trevor's original example script does not change r value)
    r2m(1,driverIndex)=tmpR(1,2)^2;
    
    RMSE(1,driverIndex)=rms(outputs1(best,:)-targets);
    
    outputs{driverIndex}=outputs1(best,:);
    
    fprintf('Test Performance: %f\n',testPerformance);
    fprintf('-------------------- \n');
end

clear output numYears indexx j net outputs performance error endx inputs
clear test* tr* val* tmp* driverIndex
clear i errors startx oneDriverNet ii PlotNumRuns

% Make sound when script is done (doesn't work yet)
% player = audioplayer(signal, Fs);
% play(player)
