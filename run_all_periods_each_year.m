% Run all years
% Loren Albert
% Fall 2015
%
% This script is for running the master_nerualNetDriver script for each year
% (all ecosystem phenology periods, although setting 'month' to something
% other than 'all' should just do a chosen month/period)

% Instructions/to do:
% 1) set 'month = all' in loadObsAndDrivers
%
% 2) set year_consecutive = 0 in loadObsAndDrivers, and comment out the 
% yearsInclude in the if statement in loadObsAndDrivers.
%
% 3) set all relevant settings (day/night, drivers, etc) in
% master_neuralNetDriverAnalysis and it's subscripts. (May want to set
% SaveWorkspace to 1 in master_neuralNet)
%
% 4) in neuralNet_bestPlusOne, include all drivers in driverIndex (because
% there is no simple way of subtracting the 'best' driver from the
% driverIndex for each eco_pheno period in the loop below... this just
% means that the best driver is run plus itself in the secondary driver
% step).  Make sure code uncommented to run 'best_driver' plus each other
% driver for inputs.
%
% 5) Set FindRelevant to 1 in this script to see which drivers have an r^2
% above some threshold (set prim_r2_thresh and sec_r2_thresh) for ANY 
% eco phenology period as a primary and/or secondary driver.  (See objects
% primary_r2_list and secondary_r2_list when FindRelevant==1)
%
% 6) Make sure year range in this script is the desired year range
% (remember that soil moisture dataset didn't start until 2002)
%
% Note: After this script finishes, look at 'primary_r2_list' and 
% 'secondary_r2_list' to see primary and r2 for each driver for each eco 
% pheno period run
%
% Note: If there is an error: 'Error using  - Matrix dimensions must agree.'
% it is probably because the driverIndex in neuralNet_bestPlusOne was
% missing one driver.
% 
% Note: Because workspaces are saved within the scripts run by
% master_neuralNetDriverAnalysis.m, the objects created after 
% master_neuralNetDriverAnalysis.m is run (such as primary_r2_list for year 
% kk) are not saved.  I could fix this, but work around is to run script
% below master_neuralNetDriverAnalysis.m for the 'final' year in EACH_year
% and manually save that workspace (as the final year it would then contain
% values of interest for all years in objects like primary_r2_list).

% To fix:
% 1) See if 'find relevant section' is useful and if it works--DONE (it works)
% 2) See if run save_workspace_and_ANNs.m works--DONE (it works)
% 3) look into saving graphs
% 4) Could wrap this script around 'master' script to incorporate it.
% 5) the call to     run Convert_std_for_numRuns.m might not be needed
% anymore.  Remove if not needed.


clear all
close all

cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple') % Directory for master_neuralNetDriverAnalysis

% Changeable options
FindRelevant = 1; % Set to 1 to run the section 'Find which drivers are relevant' (this relies on parts from loop through all eco pheno periods)

% Make cell array of all eco pheno periods
EACH_year=[1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013];
%EACH_year=[2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013]; %use this if including soil moisture

% Initialize vector of r^2 benchmarks and model standard deviations
r2_benchmark_yrs_list = [];
std_all_r2_benchmark_pop_list = [];
std_all_r2_oneDriver_pop_converted_list = [];
std_all_r2_b_pop_converted_list = [];

% Loop through all eco pheno periods with master_neuralNetDriverAnalysis.m
for kk = 1:length(EACH_year);
    %     yearStart = EACH_year(kk);
    %     yearEnd = EACH_year(kk);
    yearsInclude = EACH_year(kk);
    run master_neuralNetDriverAnalysis.m
    
    % Make list of primary and secondary driver r^2 values to see which
    % drivers are relevant
    r2_prim_cols = find(r2);                    % Column numbers for r2 values for primary driver
    r2_prim_list = nonzeros(r2)';               % r2 values for primary driver (neuralNet_oneDriver already filters for best of 10 runs)
    r2b_sec_cols = find(r2b);                   % Column numbers for r2 values for secondary driver
    r2b_sec_list = nonzeros(r2b)';              % r2 values for secondary driver (neuralNet_oneDriver already filters for best of 10 runs)
    if kk == 1
        primary_r2_list = [r2_prim_cols; r2_prim_list]; % Only need column numbers in first row for primary drivers (since column numbers don't change)
        secondary_r2_list = [r2b_sec_cols; r2b_sec_list];
    else
        primary_r2_list = [primary_r2_list; r2_prim_list];
        secondary_r2_list = [secondary_r2_list; r2b_sec_list];
    end
    
    % Also save benchmark r^2 for each year
    r2_benchmark_yrs_list = [r2_benchmark_yrs_list; r2_benchmark];
    
    % Calculate population standard deviation
    run Convert_std_for_numRuns.m
    std_all_r2_benchmark_pop_list = [std_all_r2_benchmark_pop_list; std_all_r2_benchmark_pop];
    std_all_r2_oneDriver_pop_converted_list = [std_all_r2_oneDriver_pop_converted_list; std_all_r2_oneDriver_pop_converted];
    std_all_r2_b_pop_converted_list = [std_all_r2_b_pop_converted_list; std_all_r2_b_pop_converted];
end

    %% Find which drivers are relevant
    if FindRelevant == 1
        
        % Find difference between secondary driver R^2 (which actually includes
        % the primary driver plus the secondary driver) and best primary driver (the max
        % r2 from primary list for each period)
        best_primary_each_period = max(primary_r2_list,[],2);
        % sec_r2_diff = secondary_r2_list-best_primary_each_period*ones(1,length(secondary_r2_list)); %Not sure why this works in run_all_eco_pheno_periods but not here
        sec_r2_diff = secondary_r2_list-repmat(best_primary_each_period,1,size(secondary_r2_list,2));
        
        % Show maximum primary and secondary r^2 (minus best primary) for each DRIVER
        % across all periods (What is the most relevant it ever is?)
        max_prim = max(primary_r2_list(2:end,:));
        max_sec = max(sec_r2_diff(2:end,:));
        
        % Find which drivers are 'relevant' by looking at max r^2 for each driver
        % across all eco pheno periods.  (The idea is to exclude drivers that never
        % go above a certain threshold for any period)
        % Primary:
        prim_r2_thresh = 0.2;
        relevant_prim_driversIND = find(max_prim > prim_r2_thresh);
        % Secondary
        sec_r2_thresh = 0.2;
        relevant_sec_driversIND = find(max_sec > sec_r2_thresh);
        
        % Figure out which drivers have those indices
        relevant_prim_drivers = primary_r2_list(1,relevant_prim_driversIND);
        relevant_sec_drivers = secondary_r2_list(1,relevant_sec_driversIND);
        
%         % Initialize cell arrays for 'for' loops
%         if kk == 1;
%             rev_driver_list_prim=cell(length(eco_pheno_periods),length(relevant_prim_drivers));
%             rev_driver_list_sec = cell(length(eco_pheno_periods),length(relevant_sec_drivers));
%         else
%         end
            rev_driver_list_prim = cell(1,length(relevant_prim_drivers));
            rev_driver_list_sec = cell(1,length(relevant_sec_drivers));
        
        % Loop through each 'relevant' primary driver to return name (optional)
        for jj = 1:size(relevant_prim_drivers,2)
            % Make list of driver labels
            search_num = relevant_prim_drivers(jj);
            fns=fieldnames(columns);
            rev_driver_list_prim(jj) = fns(struct2array(columns)==search_num);
        end
        
        % Loop through each driver (column) for 'secondary' driver list (for
        % reference)
        for mmm = 1:size(relevant_sec_drivers,2)
            % Make column labels into titles for secondary r2 list
            second_search_num = relevant_sec_drivers(mmm);
            second_fns = fieldnames(columns);
            rev_driver_list_sec(mmm) = second_fns(struct2array(columns)==second_search_num);
        end
    end

    
    
    