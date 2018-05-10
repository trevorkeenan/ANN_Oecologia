% This script takes the output of daylen_OKdata.m, which are flux files and
% climate files that have been averaged for half-day steps (and half-day periods
% with amounts of data that are below some threshold are excluded).  OR, 
% for climate data, can choose to use gap-filled data (Datatype==3).  Next it
% subsets the data to produce datasets of half-day "night" and half-day
% "day".  This script could be modified to use other files (e.g. half-hour averaged files).

% This script also does a few other things.  It adds the snotel data as a
% driver in the climate files.  It also adds NEE from the previous
% half-day period as a driver for the subsequent half-day period. (Since
% this is a driver is it added to the dataset of 'climate' variables)

% Update for Oecologia re-submission: a 3*standard deviation filter to remove extreme
% values from all variables where bounds did not create a very long tail
% (which is everything but precip, SWE, soil
% moisture, wet_b, VPD, ustar, z, relative humidity, and windspeed.... but Rppfd_in during
% the night is also skewed with a long tail)

% Next step after this script is input into the ANN script from Trevor.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To do:
% 1) Choose whether to use gap-filled or non-gap-filled data.
% 
% 2) Decide whether to show histograms of each daytime and nighttime averaged

% Resources:
% https://www.mathworks.com/help/matlab/data_analysis/inconsistent-data.html
% http://stackoverflow.com/questions/25281160/statistical-outlier-detection-in-matlab
% help bsxfun

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To fix:
% 1) add 'if' statement and flux data--DONE
%
% 2) see if trevor's scripts will run on datasets, which should be what
% this produces--SORT OF DONE.  Importdata command works with datasets and
% wrote script 'trainMyANN_NACP_Loren_with_datasets.m' that functions.
% Only thing is that I still haven't figured out how to call drivers by
% names....still calling by column (although I print out the column header
% to 'show' which drivers I am using as input).
%
% 3) Add data == 4 for gap filled flux data? Might not be needed if we
% don't decide to use gap filled flux data.
%
% 4) Output of this script used to go to 'Data output from
% matlab/DataIn/' folder.  Changed so it goes to 
% '/LPA-edited scripts/MatlabScripts_from_TK/DataIn/'--DONE
%
% 5) Add snotel data to climate files--DONE (units are converted from 
% inches to mm in load_snotel.m)
%
% 6) Consider adding precipitation offset for half-day 'night',(so columns 
% for previous night, previous half-day, previous half-day plus half night 
% (summed).  Half-day 'day' is done)--decided probably don't need to add
% half night at this point.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%%%%%%%%%%%%%%%%%%%%
%Changable options %
%%%%%%%%%%%%%%%%%%%%

% Choose 1 for preparing climate data file of only OK flags
% (non-gap-filled)
% Choose 2 for preparing flux data file of only OK flags
% Choose 3 for preparing climate data file of original Ameriflux
% (gap-filled) data.

Datatype = 1;

% For input and output file names, what threshold of data was used in daylen_OKdata.m?
threshold = 0.5; %This goes into input file name

% Decide whether to show histograms of each daytime and nighttime averaged
% climate variables. Set to 1 to show.
showhist = 0; 

% Change directory if not already there
% cd('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts') %for mac mini


% Path names and output file path
% fileyear = 1998; %Year for data and flags files when going year by year
filepath = char('../../../NR data/Data output from matlab/'); %directory where files live
% filepathout = char('../../../NR data/Data output from matlab/DataIn/'); %old directory for output, but this was annoying because I had to copy and paste files into directory called by ANN scripts.
filepathout = char('../../../Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/DataIn/');

%% For Climate (OK flags):
% Make datasets of half-day day and half-day night climate data, and export to tab-delimited file
if Datatype == 1
    filename = strcat('climate_allyears_OKflags_daylen_thresh',num2str(threshold),'.txt'); %Input file: output from daylen_OKdata.m
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year, DD, quantum, GroupCount, MO, T_21m, RH_21m, P_bar_12m, ws_21m, wd_21m, ustar_21m, z_L_21m, precip_mm, Td_21m, vpd, wet_b, T_soil, T_bole_pi, T_bole_fi, T_bole_sp, Rppfd_in_, Rppfd_out, Rnet_25m_, Rsw_in_25, Rsw_out_2, Rlw_in_25, Rlw_out_2, T_2m, T_8m, RH_2m, RH_8m, h2o_soil, co2_21m] = ...
        textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    
    climData = [Year MO DD quantum GroupCount T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    header = {'Year', 'MO', 'DD', 'quantum', 'GroupCount', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    climDataset = dataset({climData,header{:}});
    
    %Create two new datasets: one of 'night' half-days and the other of 'day'
    %half-days
    %note: in daylen_OKdata.m 'night' and 'day' labels in dataset are converted into 1 for night and 2 for day when dataset converted back to array
    climDatasetDay = climDataset(climDataset.quantum ==2,:);
    climDatasetNight = climDataset(climDataset.quantum ==1,:);
    
    % Run script to load snotel SWE dataset and a 30-day offset
    % (Note that SWE will be the same for half-day 'day' and half-day
    % 'night' since Snotel offers only daily values.
    run load_snotel.m
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts') %Change back to this directory
    
    % Create offset datasets for precipitation (for 'Day'): previous night, previous
    % half-day, previous half-day plus half night (summed)
    precip_prev_Night=climDatasetNight(:,13);
    filler=dataset(NaN, 'VarNames',{'precip_mm'});
    precip_prev_Day=[filler; climDatasetDay(1:end-1,13)];
    precip_prev_24hrs=dataset(double(precip_prev_Night)+double(precip_prev_Day));
    
    % Change names of offset precipitation so they are informative
    precip_prev_Night=set(precip_prev_Night,'VarNames','precip_mm_prev_Night');
    precip_prev_Day=set(precip_prev_Day,'VarNames','precip_mm_prev_Day');
    precip_prev_24hrs=set(precip_prev_24hrs,'VarNames','precip_mm_prev_24hrs');
    
%     % Run script to load NEE data and half-day offset of NEE 
% (decided not to include these variables in output since I generally won't
% use them as drivers later, so commenting out)
%     run load_prev_nee
%     
%     % Change names of offset NEE so they are informative
%     NEE_prev_HN_Day=set(NEE_prev_HN_Day,'VarNames','NEE_OK_prev_HN_Day');
%     NEE_prev_HD_Night=set(NEE_prev_HD_Night,'VarNames','NEE_OK_prev_HD_Night');
    
    % Add offset precipitation data columns and SWE to appropriate climDatasets
    % (SWE offset (SWE_prev30DS), NEE prev HD could be included if being used as drivers
    % later)
    climDatasetDay=[climDatasetDay SWE_DS precip_prev_Night precip_prev_Day precip_prev_24hrs];
    climDatasetNight=[climDatasetNight SWE_DS];
    
    % Look at histograms of each variable for day and night
    % (e.g. what is the shape of the distribution? Bounded?)
    if showhist ==1

        % DAY
        climMatDay = double(climDatasetDay);
        for i = 6:size(climMatDay,2)
            figure;
            histogram(climMatDay(:,i)) % before R2014b use "hist" instead
            title(['Histogram of row ',num2str(i)]);
            xlabel('Bins');
            ylabel('Frequency');
        end
        % Night
        climMatNight = double(climDatasetNight);
        for i = 6:size(climMatNight,2)
            figure;
            histogram(climMatNight(:,i)) % before R2014b use "hist" instead
            title(['Histogram of row ',num2str(i)]);
            xlabel('Bins');
            ylabel('Frequency');
        end
    else
    end
    
    % Find and replace outliers with NaN
    % prctileExample = prctile(double(climDatasetDay),[.5 25 50 75 99.5],1); %example of .5, 25, 50, 75, and 99.5 percentile for each column
    % When an outlier is considered >three standard deviations from the mean,
    % use this:
    % DAY
    climMatDay = double(climDatasetDay);
    muDay = nanmean(climMatDay);
    sigmaDay = nanstd(climMatDay);
    [nDay,p] = size(climMatDay);
    % Create a matrix of mean values by replicating the mu vector for n rows
    MeanMatDay = repmat(muDay,nDay,1);
    % Create a matrix of standard deviation values by replicating the sigma vector for n rows
    SigmaMatDay = repmat(sigmaDay,nDay,1);
    % Create a matrix of zeros and ones, where ones indicate the location of outliers
    outliersDay = abs(climMatDay - MeanMatDay) > 3*SigmaMatDay;
    % Calculate the number of outliers in each column
    numoutDay = sum(outliersDay);
    numoutDayUse = numoutDay(:,[6,17,23]); %outliers that will be filtered in columns and that will be used as ANN inputs
    % [row,col] = find(outliers); % (To get row and column numbers of outliers if i want to check them)
    % Replace outliers with NaN.
    climMatDayNoOut = climMatDay;
    climMatDayNoOut(outliersDay) = NaN;
    % Use filtered (no outlier) version of columns for all variables not
    % bounded by zero or 100, which is everything but precip, SWE, soil
    % moisture, wet_b, VPD, ustar, z, relative humidity, and windspeed.
    % Leave bounded variables unfiltered.
    climMatDay2 = [climMatDayNoOut(:,1:6) climMatDay(:,7) climMatDayNoOut(:,8) climMatDay(:,9:13)...
        climMatDayNoOut(:,14) climMatDay(:,15:16) climMatDayNoOut(:,17:29) climMatDay(:,30:32) climMatDayNoOut(:,33)...
        climMatDay(:,34:37)];
    % Convert back to dataset for export
    header2 = get(climDatasetDay,'VarNames');
    climDatasetDay2 = dataset({climMatDay2,header2{:}});
    % Can compare original and outlier filtered datasets column by column
    % as in this example:
    % test = find(ismember(climDatasetDay.T_21m, climDatasetDay2.T_21m)==0);
    % sum(isnan(climDatasetDay.T_21m)) %Note that comparing NaN == Nan shows up as a nonmatch
    
    % NIGHT
    climMatNight = double(climDatasetNight);
    muNight = nanmean(climMatNight);
    sigmaNight = nanstd(climMatNight);
    [nNight,p] = size(climMatNight);
    % Create a matrix of mean values by replicating the mu vector for n rows
    MeanMatNight = repmat(muNight,nNight,1);
    % Create a matrix of standard deviation values by replicating the sigma vector for n rows
    SigmaMatNight = repmat(sigmaNight,nNight,1);
    % Create a matrix of zeros and ones, where ones indicate the location of outliers
    outliersNight = abs(climMatNight - MeanMatNight) > 3*SigmaMatNight;
    % Calculate the number of outliers in each column
    numoutNight = sum(outliersNight);
    numoutNightUse = numoutNight(:,[6,17,23]); %outliers that will be filtered in columns and that will be used as ANN inputs...
    % although 23 might not be used with night
    % [row,col] = find(outliersNight); % (To get row and column numbers of outliers if i want to check them)
    % Replace outliers with NaN.
    climMatNightNoOut = climMatNight;
    climMatNightNoOut(outliersNight) = NaN;
    % Use filtered (no outlier) version of columns for all variables not
    % bounded by zero or 100, which is everything but precip, SWE, soil
    % moisture, wet_b, VPD, ustar, z, relative humidity, windspeed, AND
    % Rppfd_in for nighttime but not daytime.
    % Leave bounded variables unfiltered.
    climMatNight2 = [climMatNightNoOut(:,1:6) climMatNight(:,7) climMatNightNoOut(:,8) climMatNight(:,9:13)...
        climMatNightNoOut(:,14) climMatNight(:,15:16) climMatNightNoOut(:,17:20) climMatNight(:,21) climMatNightNoOut(:,22:29)...
        climMatNight(:,30:32) climMatNightNoOut(:,33) climMatNight(:,34)];
    % Convert back to dataset for export
    header2 = get(climDatasetNight,'VarNames');
    climDatasetNight2 = dataset({climMatNight2,header2{:}});
    
    % Use export function to save datasets
    filenameoutDay = strcat('climate_allyears_OKflags_daylen_thresh',num2str(threshold),'_Day.txt'); % Output filename
    outputfilepathD = strcat(filepathout,filenameoutDay);
    export(climDatasetDay2,'file',outputfilepathD)
    filenameoutNight = strcat('climate_allyears_OKflags_daylen_thresh',num2str(threshold),'_Night.txt'); % Output filename
    outputfilepathN = strcat(filepathout,filenameoutNight);
    export(climDatasetNight2,'file',outputfilepathN)


%% For Flux OK flags:
% Make datasets of half-day day and half-day night flux data, and export to tab-delimited file
elseif Datatype == 2
    filename = strcat('flux_allyears_OKflags_daylen_thresh',num2str(threshold),'.txt'); %Input file: output from daylen_OKdata.m
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year, Day, quantum, GroupCount, MO, Fco2_21m_nee_stat_int_Ustar, Fco2_21m_nee_stat_int, Strg_co2, tu_w_21m, Taua_21m, Qh_21m, Qe_21m, w_h2o_21m, Qh_soil, Strg_Qh, Strg_Qe, Strg_bole, Strg_needle, w_h2o_21m_Ustar, q] = ...
        textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    
    fluxData = [Year MO Day quantum GroupCount Fco2_21m_nee_stat_int_Ustar Fco2_21m_nee_stat_int Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle w_h2o_21m_Ustar q];
    header = {'Year','MO','Day','quantum', 'GroupCount','Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','w_h2o_21m_Ustar','q'};
    fluxDataset = dataset({fluxData,header{:}});

    %Create two new datasets: one of 'night' half-days and the other of 'day'
    %half-days
    %note: in daylen_OKdata.m 'night' and 'day' labels in dataset are converted into 1 for night and 2 for day when dataset converted back to array
    fluxDatasetDay = fluxDataset(fluxDataset.quantum ==2,:);
    fluxDatasetNight = fluxDataset(fluxDataset.quantum ==1,:);
    
    % Use export function to save datasets
    filenameoutDay = strcat('flux_allyears_OKflags_daylen_thresh',num2str(threshold),'_Day.txt'); % Output filename
    outputfilepathD = strcat(filepathout,filenameoutDay);
    export(fluxDatasetDay,'file',outputfilepathD)
    filenameoutNight = strcat('flux_allyears_OKflags_daylen_thresh',num2str(threshold),'_Night.txt'); % Output filename
    outputfilepathN = strcat(filepathout,filenameoutNight);
    export(fluxDatasetNight,'file',outputfilepathN)
    
%     % Display information about dataset completeness
    disp(['There are ',num2str(sum(isnan(double(fluxDatasetDay(:,7))))),' NEE Daytimes that are NAN out of ', num2str(size(fluxDatasetDay,1)),...
        ' possible, assuming column 7 is used for daytime analyses']);
    disp(['There are ',num2str(sum(isnan(double(fluxDatasetDay(:,6))))),' NEE Nighttimes that are NAN out of ', num2str(size(fluxDatasetDay,1)),...
        ' possible, assuming column 6 is used for daytime analyses']);
%     % Also look at find_count_NANs.m

    %% For Climate (Original, gap-filled):
% Make datasets of half-day day and half-day night climate data, and export to tab-delimited file
elseif Datatype == 3
    filename = strcat('climate_allyears_daylen_thresh',num2str(threshold),'.txt'); %Input file: output from daylen_OKdata.m
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year, DD, quantum, GroupCount, MO, T_21m, RH_21m, P_bar_12m, ws_21m, wd_21m, ustar_21m, z_L_21m, precip_mm, Td_21m, vpd, wet_b, T_soil, T_bole_pi, T_bole_fi, T_bole_sp, Rppfd_in_, Rppfd_out, Rnet_25m_, Rsw_in_25, Rsw_out_2, Rlw_in_25, Rlw_out_2, T_2m, T_8m, RH_2m, RH_8m, h2o_soil, co2_21m] = ...
        textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    
    climData = [Year MO DD quantum GroupCount T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    header = {'Year', 'MO', 'DD', 'quantum', 'GroupCount', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    climDataset = dataset({climData,header{:}});
    
    %Create two new datasets: one of 'night' half-days and the other of 'day'
    %half-days
    %note: in daylen_OKdata.m 'night' and 'day' labels in dataset are converted into 1 for night and 2 for day when dataset converted back to array
    climDatasetDay = climDataset(climDataset.quantum ==2,:);
    climDatasetNight = climDataset(climDataset.quantum ==1,:);
    
    % Run script to load snotel SWE dataset and a 30-day offset
    run load_snotel.m
    cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts') %Change back to this directory
    
    % Create offset datasets for precipitation: previous night, previous
    % half-day, previous half-day plus half night (summed)
    precip_prev_Night=climDatasetNight(:,13);
    filler=dataset(NaN, 'VarNames',{'precip_mm'});
    precip_prev_Day=[filler; climDatasetDay(1:end-1,13)];
    precip_prev_24hrs=dataset(double(precip_prev_Night)+double(precip_prev_Day));
    
    % Change names of offset precipitation so they are informative
    precip_prev_Night=set(precip_prev_Night,'VarNames','precip_mm_prev_Night');
    precip_prev_Day=set(precip_prev_Day,'VarNames','precip_mm_prev_Day');
    precip_prev_24hrs=set(precip_prev_24hrs,'VarNames','precip_mm_prev_24hrs');
    
    % Run script to load NEE data and half-day offset of NEE
    % (decided not to include these variables in output since I generally won't
% use them as drivers later, so commenting out)
%     run load_prev_nee
%     
%     % Change names of offset NEE so they are informative
%     NEE_prev_HN_Day=set(NEE_prev_HN_Day,'VarNames','NEE_OK_prev_HN_Day');
%     NEE_prev_HD_Night=set(NEE_prev_HD_Night,'VarNames','NEE_OK_prev_HD_Night');
    
    % Add offset precipitation data columns, SWE, SWE offset, NEE prev HD to appropriate climDatasets
    % Add offset precipitation data columns and SWE to appropriate climDatasets
    % (SWE offset (SWE_prev30DS), NEE prev HD could be included if being used as drivers
    % later)
    climDatasetDay=[climDatasetDay SWE_DS precip_prev_Night precip_prev_Day precip_prev_24hrs];
    climDatasetNight=[climDatasetNight SWE_DS];
    
        % Look at histograms of each variable for day and night
    % (e.g. what is the shape of the distribution? Bounded?)
    if showhist ==1

        % DAY
        climMatDay = double(climDatasetDay);
        for i = 6:size(climMatDay,2)
            figure;
            histogram(climMatDay(:,i)) % before R2014b use "hist" instead
            title(['Histogram of row ',num2str(i)]);
            xlabel('Bins');
            ylabel('Frequency');
        end
        % Night
        climMatNight = double(climDatasetNight);
        for i = 6:size(climMatNight,2)
            figure;
            histogram(climMatNight(:,i)) % before R2014b use "hist" instead
            title(['Histogram of row ',num2str(i)]);
            xlabel('Bins');
            ylabel('Frequency');
        end
    else
    end
    
    % Find and replace outliers with NaN
    % prctileExample = prctile(double(climDatasetDay),[.5 25 50 75 99.5],1); %example of .5, 25, 50, 75, and 99.5 percentile for each column
    % When an outlier is considered >three standard deviations from the mean,
    % use this:
    % DAY
    climMatDay = double(climDatasetDay);
    muDay = nanmean(climMatDay);
    sigmaDay = nanstd(climMatDay);
    [nDay,p] = size(climMatDay);
    % Create a matrix of mean values by replicating the mu vector for n rows
    MeanMatDay = repmat(muDay,nDay,1);
    % Create a matrix of standard deviation values by replicating the sigma vector for n rows
    SigmaMatDay = repmat(sigmaDay,nDay,1);
    % Create a matrix of zeros and ones, where ones indicate the location of outliers
    outliersDay = abs(climMatDay - MeanMatDay) > 3*SigmaMatDay;
    % Calculate the number of outliers in each column
    numoutDay = sum(outliersDay);
    numoutDayUse = numoutDay(:,[6,17,23]); %outliers that will be filtered in columns and that will be used as ANN inputs
    % [row,col] = find(outliers); % (To get row and column numbers of outliers if i want to check them)
    % Replace outliers with NaN.
    climMatDayNoOut = climMatDay;
    climMatDayNoOut(outliersDay) = NaN;
    % Use filtered (no outlier) version of columns for all variables not
    % bounded by zero or 100, which is everything but precip, SWE, soil
    % moisture, wet_b, VPD, ustar, z, relative humidity, and windspeed.
    % Leave bounded variables unfiltered.
    climMatDay2 = [climMatDayNoOut(:,1:6) climMatDay(:,7) climMatDayNoOut(:,8) climMatDay(:,9:13)...
        climMatDayNoOut(:,14) climMatDay(:,15:16) climMatDayNoOut(:,17:29) climMatDay(:,30:32) climMatDayNoOut(:,33)...
        climMatDay(:,34:37)];
    % Convert back to dataset for export
    header2 = get(climDatasetDay,'VarNames');
    climDatasetDay2 = dataset({climMatDay2,header2{:}});
    % Can compare original and outlier filtered datasets column by column
    % as in this example:
    % test = find(ismember(climDatasetDay.T_21m, climDatasetDay2.T_21m)==0);
    % sum(isnan(climDatasetDay.T_21m)) %Note that comparing NaN == Nan shows up as a nonmatch
    
    % NIGHT
    climMatNight = double(climDatasetNight);
    muNight = nanmean(climMatNight);
    sigmaNight = nanstd(climMatNight);
    [nNight,p] = size(climMatNight);
    % Create a matrix of mean values by replicating the mu vector for n rows
    MeanMatNight = repmat(muNight,nNight,1);
    % Create a matrix of standard deviation values by replicating the sigma vector for n rows
    SigmaMatNight = repmat(sigmaNight,nNight,1);
    % Create a matrix of zeros and ones, where ones indicate the location of outliers
    outliersNight = abs(climMatNight - MeanMatNight) > 3*SigmaMatNight;
    % Calculate the number of outliers in each column
    numoutNight = sum(outliersNight);
    numoutNightUse = numoutNight(:,[6,17,23]); %outliers that will be filtered in columns and that will be used as ANN inputs...
    % although 23 might not be used with night
    % [row,col] = find(outliersNight); % (To get row and column numbers of outliers if i want to check them)
    % Replace outliers with NaN.
    climMatNightNoOut = climMatNight;
    climMatNightNoOut(outliersNight) = NaN;
    % Use filtered (no outlier) version of columns for all variables not
    % bounded by zero or 100, which is everything but precip, SWE, soil
    % moisture, wet_b, VPD, ustar, z, relative humidity, windspeed, AND
    % Rppfd_in for nighttime but not daytime.
    % Leave bounded variables unfiltered.
    climMatNight2 = [climMatNightNoOut(:,1:6) climMatNight(:,7) climMatNightNoOut(:,8) climMatNight(:,9:13)...
        climMatNightNoOut(:,14) climMatNight(:,15:16) climMatNightNoOut(:,17:20) climMatNight(:,21) climMatNightNoOut(:,22:29)...
        climMatNight(:,30:32) climMatNightNoOut(:,33) climMatNight(:,34)];
    % Convert back to dataset for export
    header2 = get(climDatasetNight,'VarNames');
    climDatasetNight2 = dataset({climMatNight2,header2{:}});
    
    % Use export function to save datasets
    filenameoutDay = strcat('climate_allyears_daylen_thresh',num2str(threshold),'_Day.txt'); % Output filename
    outputfilepathD = strcat(filepathout,filenameoutDay);
    export(climDatasetDay2,'file',outputfilepathD)
    filenameoutNight = strcat('climate_allyears_daylen_thresh',num2str(threshold),'_Night.txt'); % Output filename
    outputfilepathN = strcat(filepathout,filenameoutNight);
    export(climDatasetNight2,'file',outputfilepathN)
  
end
