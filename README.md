# ANN code for Albert et al. Oecologia


General ANN settings:

These were settings that were defined in multiple scripts, but always the same as each other:

hiddenLayerSize: 10

training=60;

validating=20;

testing=20;

net1.trainFcn = 'trainlm';

net1.inputs{1}.processFcns = {'mapminmax'};    

net1.outputs{2}.processFcns = {'mapminmax'};

net1.divideFcn = 'dividerand';  % Divide data randomly

net1.divideMode = 'sample';  % Divide up every sample

 

In run_all_eco_pheno_periods.m

(this script loops master_neuralnetdriveranalysis.m for multiple periods)

prim_r2_thresh: primary driver relevance threshold for list, usually set to 0.2

sec_r2_thresh: secondary driver relevance threshold for list, usually set to 0.2

FindRelevant: produces ‘primary_r2_list’ and ‘secondary_r2_list’ when set to 1.  These are lists of drivers above the threshold for relevance set in prim_r2_thresh and sec_r2_thresh.

eco_pheno_periods: Select which seasonal periods to loop through

 

In run_all_periods_each_year.m

Same settings as run all eco pheno periods.

 

In master_neuralnetdriveranalysis.m

(this script runs each of the other scripts below, although many_OneDriver_forPlot.m is toggle-able to run or not run)

numRuns: number of ANN runs for each ensemble in neuralNet_benchmark.m , neuralNet_OneDriver.m, and neuralNet_bestPlusOneDriver.m  generally set to 10.

saveFigures: whether to save figures (generally set to 1)

diagnosticP: whether to show/save diagnostic plots (generally set to 1)

averageOneDriverPlots: whether to create/show plots of average predictions from many single-driver ANNs (runs many_OneDriver_forPlot.m)

SaveWorkspace: whether to save workspace at the end of this script

fileNames={'_allyears_OKflags_daylen_thresh0.5_Day','_allyears_daylen_thresh0.5_Day', '_allyears_OKflags_daylen_thresh0.5_Night','_allyears_daylen_thresh0.5_Night'}; these are the daytime/nighttime gap-filled/non-gap-gilled eddy flux data  options.

TAR: for ANN target (NEE or H2O flux) in neuralNet_benchmark, neuralNet_OneDriver, neuralNet_bestPlusOne. Note that many_OneDriver_forPlot.m will automatically use this target also.

 

In loadObsAndDrivers.m

loadData: whether to load data from scratch (I always did, just to be safe)

HD: Daytime (2) or nighttime (1) time steps for inputs and targets

year_consecutive: set whether running several consecutive years, or single years (or other variations)

month: the month (or seasonal period) to be used for ANNs.  This is not defined (commented out) when running master_neuralnetdriveranalysis.m within run_all_eco_pheno_periods.m

fileGF _ or fileOK__ in importdata command: gap-filled or non gap-filled climate or flux (NEE or H2O) data. For submitted version I used gap-filled drivers (day and night) and non gap-filled targets.

yearStart: starting year, if year_consecutive==1

yearEnd:  last year, if year_consecutive==1

yearsInclude: which subset of years to include if not running consecutive years

columns structure: defines driver column locations (should not need to be changed unless data changes are made to ‘fileNames’ object).

 

neuralNet_benchmark.m

inputs: choose columns to use as ANN inputs, by column number, for benchmark.  (Target is already set based on ‘TAR’)

 

neuralNet_OneDriver.m

driverIndex: Define drivers in the columns structure object to loop through (make ANNs for each of these single input drivers to see primary driver relevance)

 

In neuralNet_bestPlusOneDriver.m

driverIndex:

Note: After running, change inputs to include all but the best driver in ‘driverIndex’ object, and only the best driver in ‘inputs’ object, unless running this script within ‘run_all_eco_pheno_periods.m,’ in which case include all drivers in driverIndex

best_driver: If running this script within run_all_eco_pheno_periods.m or run_all_periods_each_year.m, then have this uncommented (otherwise comment out).

inputs: If running this script within run_all_eco_pheno_periods.m or run_all_periods_each_year.m, then include ‘best_driver’ as the driver to run with each other driver.  Otherwise, manually enter the best primary driver based on ‘neuralNet_OneDriver.m’ result

 

In many_OneDriver_forPlot.m

driverIndex: define drivers for averaged-ANN response plots.  Generally should be defined the same as in the ‘neuralNet_OneDriver.m’ script

PlotNumRuns: number of ANN runs to do for plot with average and variance of model runs (generally 100)

consistent_x_ax: whether to have consistent x min and max for axes in figures produced by plot_MANY_single_input_ANNs (generally set to zero)

response_NEE: Show response curves in terms of NEE or NEP (Note that if TAR ==1 (for H2O flux) then response_NEE setting doesn't matter).

(Note: ANN target automatically set based on ‘TAR’ from master_neuralnetdriveranalysis.m)

 

In plot_MANY_single_input_ANNs

Probably don’t need to change anything as long as it continues to be run within ‘many_OneDriver_forPlot.m’

 

 

Share with.... folders

These folders contain the versions of the MS and figures that I sent to my committee or co-authors.  Note that many intermediate versions are not here (look in Niwot Ridge project-->Niwot writing-->drafts

 

Note for data processing

For concatenating data, matching with flags, daytime/nighttime averaging, etc, here is a snapshot of the useful scripts to examine and run. (loadobsandDrivers is there just for reference).

 

:::Desktop:Screen Shot 2017-01-10 at 3.54.22 PM.png

 

Notes about making tables for revision

Scripts in all data analyses /Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Workspace-derived Tables (and similar in ‘each year’ analyses /Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/non-consecutive years/ Workspace-derived Tables) are as follows:

 

·      GenerateWorkspaceDerivedTables.m:

Generates LaTex file that can be compiled by TexPad to produce tables.

 

·      Matlab2Latex.m:

a function called by GenerateWorkspaceDerivedTables.m to generate a LaTex file by formatting in Latex syntax.  Runs automatically.

 

·      LatexFndAndReplace:

Opens the Latex file produced by GenerateWorkspaceDerivedTables (you tell it which one), then finds all NaN values and replaces them with emdash.  This runs independently.

 

·      Extract_n_r_for_FisherT.m:

Opens existing workspaces from seasonal and all data ANN runs, calculates sample sizes, and compares correlation coefficients using Fisher r-to-z transforms. Outputs go to folder ‘Workspace-derived Tables/sampleSize_FisherT’ and matrices of zeros and 1s that determine bolding are called by ‘GenerateWorkspaceDerivedTables.m’

 

·      Folders in ‘Scripts in /Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Workspace-derived Tables’

 

·      /cropped_final:

Final pdf files of tables.  Had soil moisture row added, top driver in bold (mostly automated from 0 and 1s matrix in GenerateWorkspaceDerivedTables.m, but when soil moisture was top driver this needed to be double checked), saved as _edited, opened in graphic converter (2,500 resolution B/W), cropped (smart crop option) then rotated, then saved as .pdf.

 

·      /sampleSize_FisherT:

Outputs from Extract_n_r_for_FisherT.m

 

·      /Edited for barplots:

The .txt files used with matlab script ‘panel_barplot_each_driver_txt.m’ in ‘/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts’ to make barplots of r2 for main text.  These were originally .txt outputs from ‘GenerateWorkspaceDerivedTables.m’, then edited with soil moisture r2 added (since it is empty in the ‘no soil moisture version’, which is otherwise what I want because ‘no soil moisture version’ is 1999-2013 instead of 2002-2013).

 

For ETdaytime and NEPdaytime there were two ‘significantly highest relevance’ primary drivers, so they were both run plus each secondary driver, necessitating two ‘all data’ columns in secondary driver tables.  The workspaces for this and the script for making the extra column are in /Users/lpapgm/Dropbox/Niwot Results draft2/Results graphs/Consecutive years/Eco Pheno Workspaces/Additional secondary driver



