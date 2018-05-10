% this script will...
% run the ANN with the previous best driver, and all other drivers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% driver 1 was the previous best
% for driverIndex=[columns.driver2...
%         columns.driver3 columns.driver4...
%         columns.driver5 columns.driver5...
%         columns.driver7 columns.driver8];

for driverIndex=[columns.Tmax columns.Tmin...
    columns.cumPrecip...
    columns.cumPPFD columns.cumVPD...
    columns.SWEmax]
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% TRAIN THE ANN
    
    % print site/year to screen
    fprintf('%c','Best driver plus all other drivers');
    fprintf('%c\n',' ');
    
    % define the inputs
    inputs = sub_annual_var_data(:,[columns.Tmean driverIndex])';
    
    % set what the ANN is trained to
    targets = sub_annual_var_data(:,10)';
    
    % Create a Fitting Network
    hiddenLayerSize = 3;
    
    net1 = fitnet(hiddenLayerSize);
    
    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net1.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
    net1.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};
    
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
        
        outputs1(ii,:) = outputs;
        clear outputs net train errors performance trainTargets valTargets testTargets
        clear trainPerformance valPerformance
    end
    
    
    % use output from the best performing network
    
    best=find(testPerformance==min(testPerformance));
    if length(best)>1
        % to account for the possiblility that there is more than one,
        % or no, best ANN
        best=best(1);
    end
    
    tmpR=corrcoef(outputs1(best,:),targets);
    r2b(1,driverIndex)=tmpR(1,2)^2;
    
    RMSEb(1,driverIndex)=rms(outputs1(best,:)-targets);
    
    outputsb{driverIndex}=outputs1(best,:);
    
    fprintf('Test Performance: %f\n',testPerformance);
    fprintf('-------------------- \n');
    
    
end


clear output numYears indexx inputs j net outputs performance error endx
clear hiddenLayerSize test* tr* val* tmp* driverIndex
clear i errors startx




