% Loren Albert, 2015
% This script is to see how many NANs there are in columns of driversDaily
% Workspace must include 'driversDaily and NEEobsMod.'  Script needs to be
% run for both daytime and nighttime periods separately.  Updated in 2016
% to include water vapor flux gaps after ustar filter applied.

%%% find nans in columns of driversDaily that I use in analyses
col6 = find(isnan(driversHourly.data(:,6)));
col9 = find(isnan(driversHourly.data(:,9)));
col10 = find(isnan(driversHourly.data(:,10)));
col11 = find(isnan(driversHourly.data(:,11)));
col13 = find(isnan(driversHourly.data(:,13)));
col15 = find(isnan(driversHourly.data(:,15)));
col17 = find(isnan(driversHourly.data(:,17)));
col21 = find(isnan(driversHourly.data(:,21)));
col23 = find(isnan(driversHourly.data(:,23)));
col31 = find(isnan(driversHourly.data(:,31)));
col32 = find(isnan(driversHourly.data(:,32)));
col34 = find(isnan(driversHourly.data(:,34)));

%%% find nans in columns of NEEobsMod.data that I use in analyses
fluxcol6 = find(isnan(NEEobsMod.data(:,6)));
fluxcol7 = find(isnan(NEEobsMod.data(:,7)));
fluxcol13 = find(isnan(NEEobsMod.data(:,13)));
fluxcol19 = find(isnan(NEEobsMod.data(:,19)));

%%% How many rows have one or more missing values across NEE + climate columns? (i.e. a value might be missing in more than one row)
NEE_Nan_rows = unique([col6; col9; col10; col11; col13; col15; col17; col21; col23; col31; col32; col34; fluxcol6; fluxcol7]);
% The above was what I used in versions before v21.  The problem is
% that if I include soil moisture, we should only care about gaps across 
% soil moist+ET and soil moist+NEE since I didn't use benchmark from tuple 
% with soil moisture
NEE_Nan_rows_only_soilm = unique([col32; fluxcol6; fluxcol7]);
% Try also without soil h20 since that has the most NANs
NEE_Nan_rows_no_soilH2O = unique([col6; col9; col10; col11; col13; col15; col17; col21; col23; col31; col34; fluxcol6; fluxcol7]);

%%% How many total rows across NEE and climate datasets with no missing data?
total = length(NEEobsMod.data) - length(NEE_Nan_rows);
soilM_single_input = length(NEEobsMod.data) - length(NEE_Nan_rows_only_soilm);
total_no_soilH2O = length(NEEobsMod.data) - length(NEE_Nan_rows_no_soilH2O);
% Above, 'total' is the least data that a run including soil moisture could
% include (with gaps in secondary drivers), and 'soilM_single_input' is what 
% soil as a single primary driver would include.

%%% How many rows have one or more missing values across ET + climate columns? (i.e. a value might be missing in more than one row)
ET_Nan_rows = unique([col6; col9; col10; col11; col13; col15; col17; col21; col23; col31; col32; col34; fluxcol13; fluxcol19]);
ET_Nan_rows_only_soilm = unique([col32; fluxcol13; fluxcol19]);
% Try also without soil h20 since that has the most NANs
ET_Nan_rows_no_soilH2O = unique([col6; col9; col10; col11; col13; col15; col17; col21; col23; col31; col34; fluxcol13; fluxcol19]);

%%% How many total rows across ET and climate datasets with no missing data?
ET_total = length(NEEobsMod.data) - length(ET_Nan_rows);
ET_soilM_single_input = length(NEEobsMod.data) - length(ET_Nan_rows_only_soilm); %Gives the same as above
ET_total_no_soilH2O = length(NEEobsMod.data) - length(ET_Nan_rows_no_soilH2O);
% Above, 'ET_total' is the least data that a run including soil moisture could
% include (with gaps in secondary drivers), and 'ET_soilM_single_input' is what 
% soil as a single primary driver would include.
