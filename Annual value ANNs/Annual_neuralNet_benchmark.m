% this script will...
% use all drivers to train the ANN on the observations

% Notes
% 1) I changed hiddenLayerSize to 2 (was 5 in Trevor's script) because
% I was worried it was overfitting and 2 seemed to give a better result
% than other neuron sizes between 1 and 5.  Still not sure if there is
% enough input data for a good ANN if using one value per year though...
% 2) Oddly, r2 benchmark is showing as lower than r2 for individual
% drivers.  Need to troubleshoot.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Train the Artificial Neural Network

% print site/year to screen
fprintf('%c','Benchmarking with all drivers');
fprintf('%c\n',' ');

% define the inputs
inputs = sub_annual_var_data(:,2:8)';

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

net1.trainParam.showWindow = true;
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
    trainPerformance = perform(net,trainTargets,outputs);
    valPerformance = perform(net,valTargets,outputs);
    testPerformance(ii) = perform(net,testTargets,outputs);
    
    outputs1(ii,:) = outputs;
    
end

clear outputs net train errors performance trainTargets valTargets testTargets
clear trainPerformance valPerformance

% use output from the best performing network

best=find(testPerformance==min(testPerformance));
if length(best)>1
    % to account for the possiblility that there is more than one,
    % or no, best ANN
    best=best(1);
end

outputs=outputs1(best,:);

clear outputs1

% calculate r2 and rmse for the benchmark
tmpR=corrcoef(outputs,targets);
r2_benchmark=tmpR(1,2)^2;

RMSE_benchmark=rms(outputs-targets);

fprintf('Performance: %f\n',testPerformance);
fprintf('-------------------- \n');

% estimate the data error as the residual to the model
dataError=(targets-outputs);

% plot the data error
hist(dataError)
title('This is an estimate of the distribution of error')


outputBenchmark=outputs;

clear outputs
