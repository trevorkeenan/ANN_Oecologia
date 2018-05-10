% this script will...
% use all drivers to train the ANN on the observations
%
% Edited by Loren Albert
% To do
% 1) Under 'define the inputs' choose columns to use as drivers
% 2) Under 'set what the ANN is trained to' choose appropriate column (one
% column has my U* filter applied, see header in
% master_neuralNetDriverAnalysis). Now this is automatic based on HD and
% TAR.
% 3) Change x axis limits for diagnostic plots (diagnostics plots section
% at end). Now this is automatic based on HD.
%
% To fix
% 1) Decide whether to use 'complete' or 'pairwise' with corrcoef
% command--DONE (these commands should be the same since we're only comparing two
% variables)
% 2) Should fix Diagnostic plots x-limits when TAR==1 (for water flux as
% target).  For now uncommented definitions of x-axis limits, so matlab
% will choose defaults regarless of TAR.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Train the Artificial Neural Network

close all

% print site/year to screen
fprintf('%c','Benchmarking with all drivers');
fprintf('%c\n',' ');

% define the inputs
%%%Use this for all data
% inputs = driversDaily(:,6:13)';
%%% Use this for subset of years and months
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,21,23,31,32,34])'; % 12 drivers
inputs = subDriversMonths(:,[6,9,10,11,13,15,17,21,23,31,34])'; % 11 drivers (excludes soil H2O)
% inputs = subDriversMonths(:,[6,9,10,11,13,15,17,21,23,31,32])'; % 11 drivers (excludes SWE)
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,21,23,31])'; % 10 drivers (excludes SWE & soil H20)
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,31,32,34])'; % 10 drivers (excludes Rnet and PPFDin for nighttime)
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,31,34])'; % 9 drivers (excludes soil H2O, & (Rnet and PPFDin for nighttime)
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,31,32])'; % 9 drivers (excludes SWE, & (Rnet and PPFDin for nighttime)
%inputs = subDriversMonths(:,[6,9,10,11,13,15,17,31])'; % 8 drivers (excludes SWE, soil H2O, & (Rnet and PPFDin for nighttime)


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


%% Create a Fitting Networks
hiddenLayerSize = 8;

net1 = fitnet(hiddenLayerSize);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess (lpa note:
% search 'processFcns')
% mapminmax scales each row of matrix to [-1 1]; removeconstantrows removes rows with no variation

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
net1.trainFcn = 'trainlm';  % Levenberg-Marquardt.  Matlab NN user guide says L-M can only be used in batch mode, pg 1-34

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

% Create cell array to store the n=numRuns number of networks (in case I
% want Standard Deviation, etc later)
ALL_BENCH_NET = cell(numRuns,1);

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
    
    % Save outputs
    outputs1(ii,:) = outputs;
    
    % Calculate the r2 of the 10 ANN training runs (ultimately for standard deviation)
    tmpR_ii = corrcoef(outputs,targets,'rows','pairwise');
    numruns_r2_benchmark(ii) = tmpR_ii(1,2)^2;
  
    % Save neural networks in cell array
    ALL_BENCH_NET{ii}=net;
    
end

% Double Check some things about the network transfer function
net1.layers{1}.transferFcn
net1.layers{2}.transferFcn
net1.performFcn %what 'Performance' means

clear outputs net train errors performance trainTargets valTargets testTargets
clear trainPerformance valPerformance tmpR_ii

% use output from the best performing network
best=find(testPerformance==min(testPerformance));
if length(best)>1
    % to account for the possiblility that there is more than one,
    % or no, best ANN
    best=best(1);
end

outputs_best=outputs1(best,:);

clear outputs1

% calculate r2 and rmse for the 'best' benchmark
% tmpR=corrcoef(outputs_best,targets);
tmpR_bench=corrcoef(outputs_best,targets,'rows','pairwise'); %This excludes NaNs. Note: an error here might mean the ANN didn't run becz a driver was all NANs for selected period(s)
r2_benchmark=tmpR_bench(1,2)^2;

% Calculate sample size n for correlation coefficient (for z transform later)
% r_n_bench = min([sum(~isnan(outputs_best)), sum(~isnan(targets))]);
% NOTE; ABOVE LINE was used for the Oecologia run, but logic wasn't
% right. Use something like this instead in the future: sum(~any(isnan([targets; inputs])))

%RMSE_benchmark=rms(outputs_best-targets); %doesn't work with nans
RMSE_benchmark=nanrms(outputs_best-targets);

% Calculate standard deviation of the r2 for all of the 10 runs
std_all_r2_benchmark=std(numruns_r2_benchmark); %This is what is saved in workspaces, but it is normalized by n-1
std_all_r2_benchmark_pop=std(numruns_r2_benchmark,1); %This is what I want--'population' standard deviation (normalized by n).

fprintf('Performance: %f\n',testPerformance);
fprintf('-------------------- \n');

% estimate the data error as the residual to the model
dataError=(targets-outputs_best);

% Some quality control checks
% See how many NaNs there are in each column of inputs
naninputs = isnan(inputs);
nansuminputs = sum(naninputs);
nancolsinputs = nansuminputs>=1;
%sum(nancolsinputs)
disp(['A total of ',num2str(sum(nancolsinputs)),' half-days are NaNs'])

%% Diagnostic plots

if diagnosticP == 1
    
    % % Turned plots into subplots, but this is helpful code for plotting
    % regressions:
    % % Plot regression of targets versus outputs_best
    % figure('name','Linear regression')
    % plotregression(targets,outputs_best) %Plots the linear regression
    % % Note that the R on plot is correlation coefficient not R^2
    
    % % Plot the data error using 'subplot'
    figure0=figure('name','Diagnostic Plots');
    
    % Plot regression of targets versus outputs_best
    h1 = subplot(2,2,1); % For some reason, plotregression(targets,outputs_best) doesn't work, so coding from scratch.
    scatter(targets,outputs_best,'.');
    h=lsline;
    set(h,'linewidth',2,'color','r');
    hline=refline(1,0);
    set(hline,'Color','black','LineStyle',':');
%     if HD == 1
%         xlim([-1 8]); % for half-day 'night' NEEobsMod min is about -.7 and max is a bit over 7
%     elseif HD ==2
%         xlim([-11 3.5]); % for half-day 'day' NEEobsMod min is almost -11 and max is around 3
%     end
    xlabel('Targets');
    ylabel('ANN Outputs');
    title('Linear regression of targets versus outputs');
    
    % Note that the R on plot is correlation coefficient not R^2
    h2 = subplot(2,2,2);
    hist(h2,dataError);
    title('This is an estimate of the distribution of error');
    
    % Plot where the missing values are
    h3 = subplot(2,2,3);
    bar(h3,sum(naninputs));
    xlabel('Days'); % Note that days aren't necessarily consecutive.
    title('NaN barplot: Shows when there are missing values');
    
%     % Plot data error across timespan
%     h4 = subplot(2,2,4);
%     bar(h4,dataError);
%     xlabel('Days'); % Note that days aren't necessarily consecutive.
%     title('Targets minus outputs');
    

%% Save diagnostic plots (optional)
if saveFigures==1;
    set(gcf, 'PaperPositionMode', 'auto');
    if year_consecutive==1
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/diagnosticP_night_',month{1},'TAR',num2str(TAR)); % this should give day/night, period, and target (H2O or NEE)
            elseif HD ==2
                filename=strcat('./Graphs/diagnosticP_day_',month{1},'TAR',num2str(TAR));
            end
        else
            if HD ==1
                filename=strcat('./Graphs/diagnosticP_night_',month,'TAR',num2str(TAR));
            elseif HD ==2
                filename=strcat('./Graphs/diagnosticP_day_',month,'TAR',num2str(TAR));
            end
        end
        print(figure0,'-depsc', filename);
    % Add years in filename for nonconsecutive year analyses
    elseif year_consecutive==0
        if exist('eco_pheno_periods','var')
            if HD ==1
                filename=strcat('./Graphs/diagnosticP_night_',month{1},'_',num2str(yearsInclude),'TAR',num2str(TAR)); % this should give day/night, period, year(s), and target (H2O or NEE)
            elseif HD ==2
                filename=strcat('./Graphs/diagnosticP_day_',month{1},'_',num2str(yearsInclude),'TAR',num2str(TAR));
            end
        else
            if HD ==1
                filename=strcat('./Graphs/diagnosticP_night_',month,'_',num2str(yearsInclude),'TAR',num2str(TAR));
            elseif HD ==2
                filename=strcat('./Graphs/diagnosticP_day_',month,'_',num2str(yearsInclude),'TAR',num2str(TAR));
            end
        end
        print(figure0,'-depsc', filename);
    end
end
    
elseif diagnosticP == 2
end

outputBenchmark=outputs_best;

clear outputs_best
