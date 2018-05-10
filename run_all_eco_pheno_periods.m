% Run all ecosystem phenology periods
% Loren Albert
% Fall 2014
%
% This script for running the master_nerualNetDriver script for all
% ecosystem phenology periods

% Instructions/to do:
% 1) comment out 'month = X' in loadObsAndDrivers
%
% 2) set all relevant settings (day/night, drivers, etc in
% master_neuralNetDriverAnalysis and it's subscripts. (May want to set
% SaveWorkspace to 1 in master_neuralNet).  Make sure the settings are
% appropriate for the seasonal periods being selected in eco_pheno_periods
% object (e.g. do not include SWE for pre-monsoon and monsoon periods)
%
% 3) in neuralNet_bestPlusOne, include all drivers in driverIndex (because
% there is no simple way of subtracting the 'best' driver from the
% driverIndex for each eco_pheno period in the loop below... this just
% means that the best driver is run plus itself in the secondary driver
% step).  To do this, make sure code uncommented to run 'best_driver' plus 
% each other driver for inputs in neuralNet_bestPlusOne.
%
% 4) Set FindRelevant to 1 in this script to see which drivers have an r^2
% above some threshold (set prim_r2_thresh and sec_r2_thresh) for ANY 
% eco phenology period as a primary and/or secondary driver.  (See objects
% primary_r2_list and secondary_r2_list when FindRelevant==1)
%
% Note: After this script finishes, look at 'primary_r2_list' and 
% 'secondary_r2_list' to see primary and r2 for each driver for each eco 
% pheno period run


clear all
close all

cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple') % Directory for master_neuralNetDriverAnalysis

% Changeable options
FindRelevant = 1; % Set to 1 to run the section 'Find which drivers are relevant' (this relies on parts from loop through all eco pheno periods)

% Make cell array of all eco pheno periods
%%% eco_pheno_periods={'all','winter','snowmelt','preMonsoon','monsoon','post-monsoon'};
%eco_pheno_periods={'preMonsoon','monsoon'};     %non-snowy periods
eco_pheno_periods={'all','winter','snowmelt','post-monsoon'};  %periods with some snow

% Loop through all eco pheno periods with master_neuralNetDriverAnalysis.m
for kk = 1:length(eco_pheno_periods);
    month = eco_pheno_periods(kk);
    run master_neuralNetDriverAnalysis.m
    
    % Make list of primary and secondary driver r^2 values to see which
    % drivers are relevant
    r2_prim_cols = find(r2);                    % Column numbers for r2 values for primary driver
    r2_prim_list = nonzeros(r2)';               % r2 values for primary driver (neuralNet_oneDriver already filters for best of 10 runs)
    r2b_sec_cols = find(r2b);                   % Column numbers for r2 values for secondary driver
    r2b_sec_list = nonzeros(r2b)';              % r2 values for secondary driver (neuralNet_oneDriver already filters for best of 10 runs)
    if kk == 1
        primary_r2_list = [r2_prim_cols; r2_prim_list]; % Only need column numbers in first row for primary drivers (since they don't change)
        secondary_r2_list = [r2b_sec_cols; r2b_sec_list];
    else
        primary_r2_list = [primary_r2_list; r2_prim_list];
        secondary_r2_list = [secondary_r2_list; r2b_sec_list];
    end
    
    % Save workspace variables for each eco pheno period (directory depends
    % on whether using consecutive or non-consecutive years; see save_workspace_and_ANNs.m
    addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
    run save_workspace_and_ANNs.m
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/notSoSimple');
end

    %% Find which drivers are relevant
    if FindRelevant == 1
        
        % Find difference between secondary driver R^2 (which actually includes
        % the primary driver plus the secondary driver) and best primary driver (the max
        % r2 from primary list for each period)
        best_primary_each_period = max(primary_r2_list,[],2);
        sec_r2_diff = secondary_r2_list-best_primary_each_period*ones(1,length(secondary_r2_list));
        
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

    
    
    