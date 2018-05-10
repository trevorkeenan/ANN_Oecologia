% this script will...
% Run an ANN on the observations with:
%   1. All drivers together (benchmark)
%   2. Each driver individually (find the best)
%   3. Best + each driver individually (find the second best)

% written by T.F. Keenan, March 2013 (keenan_trevor@yahoo.ie)
%
% Adapted/edited by Loren Albert for use with her processed Ameriflux
% Niwot dataset.
%
%%% TO DO:
% 1) Before running each time, make sure that input files are the correct
% version.
% 2) Set how many runs to do in this master script.
% 3) Check that the year and month/day range for analysis in 'loadObsAndDrivers' 
% is what is desired.
% 4) In 'loadObsAndDrivers', select gap-filled or not-gap filled climate
% data to use. (The not-gap-filled half-day averaged flux data doesn't exist yet
% because I don't think I'll need it).
% 5) Check that drivers selected in neuralNet_benchmark,
% neuralNet_oneDriver, neuralNet_BestPlusOneDriver, and many_OneDriver_forPlot
% are the ones desired (can ignore many_OneDriver_forPlot if averageOneDriverPlots
% is not set to one).
% 6) Set TAR based on whether NEE should be the target, or water flux vapor
% should be the target, for all ANNs.
% 7) After running to find best driver, change neuralNet_BestPlusOneDriver
% so that the best driver runs with all the other selected drivers.
% 8) In non-gap-filled 'OK' data flux dataset, the first NEE column has 
% NaNs for failed stationarity/integral stats and low U*.  For the second
% NEE column (column 7), NaNs replace numbers for failed 
% stationarity/integral stats.  Thus use column 6 for half-day 'night' NEE
% and column 7 for half-day 'day' NEE to use U* filter for only night (now code
% does this automatically based on if statement in each neuralNet... script, and
% will automatically chose target for water vapor flux based on 'TAR' too)
% 9) In non-gap-filled 'OK' data flux dataset, column 13 is water flux that
% has flag-filtered (includes flags 1,4 & 5; effectively 1 & 5 since there
% are no 4s in latent heat flux flag 1; see emails with Sean).  Column 19
% is flag filtered AND low ustar filtered.  Thus use column 13 for daytime
% analyses, and use column 19 for nighttime analyses.  (ow code
% does this automatically based on if statement in each neuralNet... script
% 10) Check directory where workspace is saved (if saving workspace) in
% 'save_workspace_and_ANNs.m'
%
%%% TO FIX:
% 1) See if there is a way to improve column naming method from 
% 'loadObsAndDrivers' that doesn't cause downstream problems--DONE (somewhat)
% 2)Add way to select time window for analysis--DONE
% 3) Make way to select OK and Gap-filled data easily for climate and flux
% independently--DONE
% 4) Optional, but could add definition for 'hidden layer size' into this
% master script instead of in subscripts (neuralNet_benchmark,
% neuralNet_Onedriver, neuralNet_bestPlusone)
% 5) Optional, but could find some way to link driver index in each 'sub' script
% to the 'columns' structure created in loadObsAndDrivers
%
% Useful links/resources:
% http://www.mathworks.com/matlabcentral/fileexchange/15986-format-tick-labels
% http://www.mathworks.com/matlabcentral/answers/35772-what-is-the-difference-between-feedforwardnet-with-fitnet
% http://stackoverflow.com/questions/33399073/population-standard-deviation/33404617#33404617
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Changeable options:

numRuns= 10; % set the number of ANNs to run for each ensemble

saveFigures=1; % set to 1 to save

diagnosticP=1; % set to 1 to show/save diagnostic graphs from neuralNet_benchmark

onedriverplots = 0; % set to 1 to create/show plots of the 'best' (of n=numRuns) single-driver ANNs versus targets

averageOneDriverPlots = 0; % set to 1 to create & show plots of average predictions +/- one standard dev. from 
% many single-driver ANNs (the number of single-driver ANNs to run for the plot is set in 'many_OneDriver_forPlot.m'

saveWorkspace = 0; % set to 1 to save variables in workspace at end of this
% script (requires 'eco_pheno_periods' in workspace, so depends on
% run_all_eco_pheno_periods.m right now.

% set the filenames (used for reading in data)
fileNames={'_allyears_OKflags_daylen_thresh0.5_Day','_allyears_daylen_thresh0.5_Day',...
    '_allyears_OKflags_daylen_thresh0.5_Night','_allyears_daylen_thresh0.5_Night'};

TAR = 1; % set to 0 for NEE, set to 1 for water vapor flux. For target in neuralNet_benchmark.m, 
% neuralNet_OneDriver.m, neuralNet_bestPlusOne.m

%% % load the data if need be
% 
% if ~exist('NEEobsMod','var')
%     run ./loadObsAndDrivers.m
% end
run ./loadObsAndDrivers.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. Benchmark the fluxes
%   This involves running the ANN with all available drivers to assess what
%   the best performance is.
%   Residuals can be thought of as data error

run ./neuralNet_benchmark.m

%% Some Universal figure options
fname='Arial';
fsize=22;
fsizeMed=18;

%% Make figure of fluxes over time
figure1=figure;
% Create axes
axes1 = axes('Parent',figure1,'FontSize',20);
hold(axes1,'all');

plot(targets,'k.','LineWidth',2,'DisplayName','OBS')
hold on
plot(outputBenchmark,'r.','DisplayName','ANN')
l1=legend('show');
xlim([0 length(outputBenchmark)])
xlabel('Day since start','FontName',fname)
ylabel('Daily NEE','FontName',fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Run with each Driver individually

run ./neuralNet_OneDriver.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. Select best Driver

[B,IX] = sort(r2,'descend');

IX(B==0)=[];
B(B==0)=[]; % r2 contains zeros if driver index has column numbers higher 
% than number of drivers, so this gets rid of the zeros that were filled in

fields=fieldnames(columns);

for i = 1:numel(fields)
    columnValue(i)=columns.(fields{i});
end

for i=1:length(IX)
    IX2=(columnValue==IX(i));
    orderedDriver{i}=fields{IX2==1};
    
end


%% 4.  Make greyscale plot for 'one-drivers' (single drivers)

addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts')
run Make_each_driver_plot_greyscale.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. Run again with best driver and all other drivers

run ./neuralNet_bestPlusOneDriver.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. Order the 2nd best driver combinations

[Bb,IXb] = sort(r2b,'descend');

IXb(Bb==0)=[];
Bb(Bb==0)=[];

fields=fieldnames(columns);

for i = 1:numel(fields)
    columnValue(i)=columns.(fields{i});
end

for i=1:length(IXb)
    IX2b=(columnValue==IXb(i));
     orderedDriverb{i}=fields{IX2b==1};
    
end


%% 7.  Make stacked plot for best driver plus 1

run Make_stacked_plot_best_plus_one.m


%% 8.  Run many single-driver ANNs for each driver (optional, set at top)
%  For plotting average predictions
if averageOneDriverPlots == 1
    run many_OneDriver_forPlot.m
else
end

%% 9.  Display some useful reference info
if year_consecutive==1
    disp(['Year start: ', num2str(yearStart), '; Year end: ', num2str(yearEnd)])
elseif year_consecutive==0
    disp(['Years', num2str(yearsInclude)])
end
disp(['Number of runs: ', num2str(numRuns)])
disp(['hidden layer size: ',num2str(hiddenLayerSize)])
disp(month)
%disp([num2str(DayStartMat)]) %Would be good to make this conditional on existence
% disp(['For each year, start date: ', num2str(dayStart), '; stop date: ', num2str(dayStop)])
% % Display names of drivers (code to make table is in
% 'loadObsAndDrivers_old') % Table_driver_names_num

%% 10.  Save workspace variables (optional; set at top)
if saveWorkspace == 1;
    addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
    run save_workspace_and_ANNs.m
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple');
else
end
