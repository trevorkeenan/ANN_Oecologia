% This script takes as input the concatenated climate files made with the
% script "concatonate.m". Then it creates a new matrix of climate data 
% using only data with specific flags (flags 1,4 and 5) OR of flux data with
% specific flags (flags 1, 4 and 5). The next script in workflow is daylen_OKdata.
% 
% For flux data, see emails
% between me and Sean on 9-25-13 to explain why I chose which flag variable
% to associate with which flux dataset variable (there is not one flag
% column for each column of flux data). Note that data is at half-hour
% resolution (averaging happens in a later script).
% 
% Also for flux data, see emails between me and sean on 10-18-2013 that 
% discuss how flux data that failed BOTH the integral and stationarity 
% tests was gap-filled.  Also, NEE data that had a ustar filter 
% applied (Fco2_21m_nee_wust) does not have
% a flag indication that it was gap-filled.  To address both of these gap-
% filling issues in this script, I made code to create a new flag value in
% new NEE flag vectors when the NEE with the ustar filter was gap-filled
% (flag 7 for when integral and stationarity were both failed, and flag 8
% for when U* was less than 0.2; see emails between me and Sean in early
% April 2014 for why I decided to apply my own U* filter).  The result is that
% for one column of the output (first column, 8 here), NaNs replaced 
% numbers for failed stationarity/integral stats AND low U*.  For another 
% column of output (column 9 here) NaNs replaced numbers for failed 
% stationarity/integral stats.
%
% Also I realized that earlier water flux analyses (up through manuscript
% version 20) did not have a ustar filter applied (see emails with Sean 
% Burns 5-17-2016). I decided to add a water flux flag column
% for nighttime ET analyses with a new flag that filters water vapor flux
% based on a 0.2 ustar threshold.  This matches an added water flux column
% (last column of the flux dataset) that will be used for nighttime ET
% analyses.
%
% Output is called 'flux_allyears_OKflags.txt'or 'climate_allyears_OKflags.txt'
% There are some commented-out parts for use of the script with one year of
% climate data to produce 'climate_fileyear_ver.2011.04.20.dat.OKflags.'
% It is safe to ignore these... I left them in just in case they are useful
% for the future.
% See help file for fprintf for how to add header to output file
%
% To do:
% 1) Under changeable options, chose whether to work with climate data or flux data.
% 2) Under changeable options, check input and output paths
% Note: there is some hard-coding identifying specific columns by number,
% so if format of input file changes, these will need to be changed.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To check: 
% 1) see if I need to care about Balance/Stationarity/Integral Stats-- DONE
% flags for flux data; 
% 2) do some checks of output files that appropriate
% data (e.g. for flags 1,4,5) is included (is it doing what I want)-- DONE 
% 3) Compare NEE w/ and w/o u* filter to remove gap-filled data...--DONE
% 4) Compare my flag assignments with Laura's: munge_niwot_pt2 section
% 3--decided not necessary.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%%%%%%%%%%%%%%%%%%%%%
%% Changable options %
%%%%%%%%%%%%%%%%%%%%%

% Path names and output path
%fileyear = 1998; %Year for data and flags files when going year by year
filepath = char('../../../NR data/Data output from matlab/'); %directory where files live
filepathout = char('../../../NR data/Data output from matlab/'); %directory for output

% Choose file type--this determines which part of code runs (using if stmt)
% this also determines whether to match climate data with climate flags or
% flux data with flux flags, and to how name output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose 1 to match climate data with climata data flags
% Choose 2 to match flux data with flux data flags
% Also, can use line below from old code using only one year of climate data
% and flags (instead of concatenated file)
%filenameout = strcat('climate_fileyear_ver.2011.04.20.dat.OKflags') % Use this output filename when going year by year

dataType=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated--chooses output file name%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If statement for output file name
if dataType == 1
    filenameout = strcat('climate_allyears_OKflags.txt'); % Use this line if matching concatonated files of climate/climate flag data
elseif dataType == 2
    filenameout = strcat('flux_allyears_OKflags.txt');%Use this line if matching concatonated files of  all years of flux data/flux flags
end
outputfilepath = strcat(filepathout,filenameout);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated section--climate data and flags%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If statement for importing data, making a matrix, cross-referencing
% climate data and flags, etc

if dataType == 1
    
% Import climate data file
% filename = strcat('climate_',num2str(fileyear),'_ver.2011.04.20.dat'); %%Use this line if you only want one specific year
filename = strcat('climate_allyears.txt');
filetoopen = strcat(filepath,filename); %concatenate file path with file name
[Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

%Import climate flags file
%filenameflag = strcat('climate_flags_',num2str(fileyear),'_ver.2011.04.20.dat'); %Use this line if you only want one specific year
filenameflag = strcat('climate_flags_allyears.txt');
filetoopenflag = strcat(filepath,filenameflag); %concatenate file path with file name
[fYear fMO fDD fHR fMM fSS fDecimalDate fT_21m fRH_21m fP_bar_12m fws_21m fwd_21m fustar_21m fz_L_21m fprecip_mm fTd_21m fwet_b fT_soil fT_bole_pine fT_bole_fir fT_bole_spru fRppfd_in_25 fRppfd_out_2 fc2Rnet_25m_RE4 fRswlw_25m_K fT_2m fT_8m fRH_2m fRH_8m fc3h2o_soil0 fco2_21m] = ...
    textread(filetoopenflag,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

%% Make climate data matrix out of column vectors
data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
length = size(data,1); %number of rows in data

% Resolve differences in number of columns between climate files and climate
% flag files: Sean said, 'the "Rswlw_25m_K" flag correspond to Rsw_in_25m_KZ,
% Rsw_out_25m_KZ, Rlw_in_25m_KZ, and Rlw_out_25m_KZ' thus I repeated the 
% Rswlw_25m_K in the matrix below so it would correspond to all four of these variables.
% For vpd, creating a flag that is based on T_8m and RH_8m as these were
% used to calculate vpd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fvpd = zeros(length,1);
for i = 1:length
    if fT_8m(i) ==1 && fRH_8m(i) ==1
        fvpd(i) = fT_8m(i);
    elseif fT_8m(i) ==4 && fRH_8m(i) ==1
        fvpd(i) = fT_8m(i);
    elseif fT_8m(i) ==5 && fRH_8m(i) ==1
        fvpd(i) = fT_8m(i);
    elseif fT_8m(i) ==1 && fRH_8m(i) ==4
        fvpd(i) = fRH_8m(i);
    elseif fT_8m(i) ==1 && fRH_8m(i) ==5
        fvpd(i) = fRH_8m(i);
    else fvpd(i)= NaN; %If the flag is zero the fvpd becomes NaN
    end
end


%% Make climate flag matrix out of column vectors (same number of columns as climate data matrix)
fdata = [fYear fMO fDD fHR fMM fSS fDecimalDate fT_21m fRH_21m fP_bar_12m fws_21m fwd_21m fustar_21m fz_L_21m fprecip_mm fTd_21m fvpd fwet_b fT_soil fT_bole_pine fT_bole_fir fT_bole_spru fRppfd_in_25 fRppfd_out_2 fc2Rnet_25m_RE4 fRswlw_25m_K fRswlw_25m_K fRswlw_25m_K fRswlw_25m_K fT_2m fT_8m fRH_2m fRH_8m fc3h2o_soil0 fco2_21m];

%% Count the number of climate data points with flags 1, 4 or 5
% and create 'okdata' from climate data points associated with flags 1,4, or 5
count = 0;

numrows=size(data,1);
numcols=size(data,2);
colcount = zeros(1,numcols);
okdata = zeros(numrows,numcols);
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i > 7 % because first 7 columns are time stamp info
            if fdata(j,i) == 1 || fdata(j,i)==4 || fdata(j,i)==5 % if flag is 1,4 or 5 it goes in 'okdata'.
                count=count+1; %Adding 1 for each time a flag 1,4 or 5 is encountered
                okdata(j,i) = data(j,i);
            else
                okdata(j,i) = NaN;
            end
        else
            okdata(j,i) = data(j,i);
        end
    end
    colcount(i)=count; %For each column i, assigns the number of flags 1,4 or 5 to this vector.
    count = 0;
end

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names used to make 'data' matrix
header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2', 'T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,okdata,'-append','delimiter','\t');
%dlmwrite(outputfilepath,okdata,'\t'); %output tab delimited file for file without header


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated section--Import flux data and flags %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif dataType == 2
    
% Import flux data file
filename = strcat('flux_allyears.txt');
filetoopen = strcat(filepath,filename); %concatenate file path with file name
[Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    
%Import flux flags file
filenameflag = strcat('flux_flags_allyears.txt');
filetoopenflag = strcat(filepath,filenameflag); %concatenate file path with file name
[fYear fMO fDD fHR fMM fSS fDecimalDate fFco2_21m_ne fStrg_co2 fTaua_21m fQh_21m fQe_21m fQe_21m_flag fQh_soil fStrg_Qh fStrg_Qe fenergy_bala fstationarit fintegral_st fStrg_bole fStrg_needle] = ...
            textread(filetoopenflag,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

        
%% Create new flags for gap-filled NEE data%

% See emails with Sean Burns 10-18-13.  Basically, in this version of the data
% release, there is some gap filling even when the CO2 NEE flux flag is "1" (okay
% data).  NEE data was gap-filled if it failed both the stationarity and integral
% tests.  Also, the CO2 NEE flux flag is "1" even if the Fco2_21m_nee_wust
% was gap-filled.  Since I want to exclude low u* values, originally I compared the 
% Fco2_21m_nee_wust and Fco2_21m_nee columns and created a new flag (flag 7) for the
% CO2 NEE flag column  See notes and code at http://urquell.colorado.edu/data_ameriflux/docs/email_fix_to_nee_flag_for_ver2011.04.20.txt
% HOWEVER, I discovered later that there were sill U* values less than .2
% during the night.  In talking with Sean, we think this is because I
% defined night dynamically throughout the year (daylen_OKdata script)
% whereas the Ameriflux data had nights defined as 20:00-5:00 MST.  Since
% the U* filter was only applied at night, this could lead to my problem
% (see emails with Sean around April 4th).
% My SOLUTION: Make one column of NEE with stat & integral gaps, and make
% one column of NEE with stat & integral gaps PLUS gaps when U* was less
% than 0.2.  Use the first for half-day 'day' NEE and the second for
% half-day 'night' NEE.

% Create flag 7 in a new NEE flags vector for when ustar is less than 0.2
% % (Here's old code that was used to compare the two NEE columns previously.
% % Since I'm defining my own, commenting this out)
% % fFco2_21m_ne_new = fFco2_21m_ne ;
% % fFco2_21m_ne_new(abs(Fco2_21m_ne-Fco2_21m_nee_wust)>0) = 7 ;
% % disp(['There are ',num2str(sum(fFco2_21m_ne_new==7)),' differences between ustar and nonustar NEE columns']);
%
% First import U* values from concatenated climate data. (There is a way in textscan to import only one column, but I couldn't get it working in half
% an hour and so just importing the whole climate dataset and clearing unneeded stuff).
filename = strcat('climate_allyears.txt');
filetoopen = strcat(filepath,filename); %concatenate file path with file name
[cYear cMO cDD cHR cMM cSS cDecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
   textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
clear cYear cMO cDD cHR cMM cSS cDecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m  z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m
%
% Create flag 7 in a new NEE flags vector for when stationarity and integral stats are both failed.
fFco2_21m_ne_new = fFco2_21m_ne;
fFco2_21m_ne_new(fstationarit(:,1)>1 & fintegral_st(:,1)>1)=7;
disp(['Stationarity and integral stats failed ',num2str(sum(fFco2_21m_ne_new==7)),' times for NEE']);

% Make flag number 8 in a second new NEE flags based on the first for when vector for NEE with u* <0.2
fFco2_21m_ne_new2 = fFco2_21m_ne_new;
lowUstarInd=find(ustar_21m<=0.2);
fFco2_21m_ne_new2(lowUstarInd) = 8;
disp(['There are ',num2str(sum(fFco2_21m_ne_new2==8)),' half-hour NEE periods with U*<0.2']);

%Some checks for creating NEE flags 7 and 8 (not sure if these still work)
% doublefailIndextest = find(fFco2_21m_ne_new2 == 7);
% nnz(fFco2_21m_ne_new2==7); %Should be same length as find index
% nnz(fintegral_st==2 & fstationarit==2) %Should be same length as find index (number of timese integral AND stationarity failed
% hist(fFco2_21m_ne_new2);
disp(['The NEE flag shows that NEE was gap-filled/modelled (flags 2,3,or 6) ',num2str(sum(fFco2_21m_ne == 2 | fFco2_21m_ne==3 | fFco2_21m_ne==6)),' times'])
% Not including version 2015 flux flag 7 here because that should relate to ustar rather than integral and stationarity flags.

% Now deal with water flux column
% Make flag number 8 in a new H2O flux (latent heat) flag for when u* <0.2
fQe_21m_U = fQe_21m;        % Qe_21m is Latent Heat Flux Flag1
fQe_21m_U(lowUstarInd) = 8;
disp(['There are ',num2str(sum(fQe_21m_U==8)),' half-hour water flux periods with U*<0.2']);

% Some checks for H2O flags
disp(['The Qe_21m flag shows that w_h2o_21m was gap-filled/modelled (flags 2,3,or 6) ',num2str(sum(fQe_21m == 2 | fQe_21m==3 | fQe_21m==6)),' times'])

%% Make flux data matrix out of column vectors
% Since I will apply my own U*, not using the Ameriflux 'Fco2_21m_nee_wust'
% column.  Instead, I repeat Fco2_21m_ne twice.  One will have flags 7 and
% 8 apply.  The other will only have flag 7 apply.  For NEE, all flags not 1,4, or 5
% are excluded from all columns (see 'match flux data and flags' below). I
% also repeat w_h2o_21m at the end of the dataset, creating a second water 
% flux column with a ustar filter (fQe_21m_U) applied. This is also applied
% in 'match flux data and flags' below.
fluxdata = [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_ne Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle w_h2o_21m];
length = size(fluxdata,1); %number of rows in flux data


%% Make flux flag matrix out of column vectors

% To make match the flux data with the flux flags, I made two matrices with
% the same number of rows.  Sometimes this involved repeating a flag column
% when appropriate.  I didn't use the 'Qe_21m_flag2' because it tells which
% sensor was used, whereas the other Qe_21m flag tells about gap filling
% (so I used that one).  For more info, see emails
% between me and Sean on 9-25-13.  Note: fFco2_21m_ne_new is for stat failures
% and fFco2_21m_ne_new2 is for stat failures AND low U*

flagdata = [fYear fMO fDD fHR fMM fSS fDecimalDate fFco2_21m_ne_new2 fFco2_21m_ne_new fStrg_co2 fTaua_21m fTaua_21m fQh_21m fQe_21m fQe_21m fQh_soil fStrg_Qh fStrg_Qe fStrg_bole fStrg_needle fQe_21m_U];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated section--match flux data and flags %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Count the number of flux dataset data points with flags 1, 4 or 5, and
% create 'OKdata' from flux data points associated with flags 1, 4, or 5.
% (Note that for NEE flux flag (flagdata column 8) there are no 4s or 5s,
% and for H2O flux, there are no 4s: 
% sum(find(fFco2_21m_ne==5))
% sum(find(fFco2_21m_ne==4))
% sum(find(fQe_21m==5))
% sum(find(fQe_21m==4))
count = 0;

numrows=size(fluxdata,1);
numcols=size(fluxdata,2);
colcount = zeros(1,numcols);
OKdata = zeros(numrows,numcols);
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i > 7 % because first 7 columns are time stamp info
            if flagdata(j,i) == 1 || flagdata(j,i)==4 || flagdata(j,i)==5 % if flag is 1,4 or 5.
                count=count+1; %Adding 1 for each time a flag 1,4 or 5 is encountered
                OKdata(j,i) = fluxdata(j,i);
            else
                OKdata(j,i) = NaN;
            end
        else
            OKdata(j,i) = fluxdata(j,i);
        end
    end
    colcount(i)=count; %For each column i, assigns the number of flags 1,4 or 5 to this vector.
    count = 0;
end

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names used to make 'fluxdata' matrix
header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle', 'w_h2o_21m_Ustar'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,OKdata,'-append','delimiter','\t');
%dlmwrite(outputfilepath,OKdata,'\t'); %output tab delimited file without headers

end


%%% Checks and quality control
%  
% This section causes errors to show up if certain criteria are not met.
%
% Check 1: size of OKdata = size of input
if dataType == 1
    if abs(size(okdata)-size(data))>0
        error('Check 1: input flux dataset and output flux dataset not same size')
    end
elseif dataType == 2
    if abs(size(OKdata)-size(fluxdata))>0
        error('Check 1: input flux dataset and output flux dataset not same size')
    end
end
    
% Note:
% Matlab does not count something as a match if comparing a number with a
% NaN, and also does not count something as a match if comparing two NaNs.
% It counts these as not-matching.
% Note that mismatches between original columns (Fco2_21m_ne and
% Fco2_21m_nee_wust) do not equal the mismatches between OK data columns 8
% and 9 because whenever the flux flag was 1, 4, or 5 and the ustar
% flux flag was 7, then it became a new non-match.

%Comment out for when using climate data and not flux data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% orig_nee_raw=fluxdata(:,8);                 % NEE without ustar-filter flux data
% orig_nee_ustar=fluxdata(:,9);               % NEE with ustar-filter flux data
% nee_ok=OKdata(:,8);                         % NEE without ustar-filtered data or integral stats/stationarity failure data (all converted to NANs)
% nee_ustar=OKdata(:,9);                      % NEE without ustar-filtered data (converted to NANs)
% 
% origdiff = Fco2_21m_ne~=Fco2_21m_nee_wust;  % zero if the same, 1 if different
% middiff = orig_nee_raw~=orig_nee_ustar;
% newdiff = nee_ok~=nee_ustar;
% flagdiff = sum(fFco2_21m_ne~=fFco2_21m_ne_new);
% 
% % The Ameriflux gap-filled data had no NANs: sum(isnan(orig_nee_raw)); sum(isnan(orig_nee_ustar))
% NanRawCount = sum(isnan(nee_ok));           % Sum of NANs due to removal of ustar, integral and stationarity
% NanUCount = sum(isnan(nee_ustar));          % Sum of nans due to removal of just ustar
% NanDiff = sum(abs(NanRawCount - NanUCount));
% testcount=sum(nee_ok==nee_ustar);           % 248400-testcount is 60805
% 248400-testcount
%
% % Are there instances when more than one flag caused removal?
% sum(fFco2_21m_ne_new==6 & fFco2_21m_ne_new==7)
% sum(fFco2_21m_ne_new == 2 & fFco2_21m_ne_new==7)
% sum(fFco2_21m_ne_new==3 & fFco2_21m_ne_new==7)

%% Check 2 %Comment out for now when using climate data and not flux data
%Comment out for when using climate data and not flux data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if sum(origdiff)~=sum(middiff);
%     error('Check 2: mismatches between input flux dataset flux columns do not equal mismatches between flag columns) ');
% end
% 
% changes = sum(flagdata(:,9)==2) + sum(flagdata(:,9)==3) + sum(flagdata(:,9)==6) + sum(flagdata(:,9)==7);
% 

%% Check 3: Comparing differences between NEE columns of 'OKdata' with
% % expected differences based on non 1,4,5 flags.  Number of non 1,4,5 flags
% % is expected number of NaN values written into OKdata column 9.
% %Comment out for when using climate data and not flux data
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % if sum(newdiff) ~=changes;
% %     error('the number of expected differences between the two NEE flux columns dow not equal number expected based on flags')
% % end
% 
% % Check 4: what are the lowest ustar values that have NEE values that are not NAN
% % Using this requires both flux and climate data to be in workspace, so
% % comment out 'clear all'
% 
% figure()
% scatter(okdata(:,13),OKdata(:,8)) %This should have no U* <0.2
% figure()
% scatter(okdata(:,13),OKdata(:,9)) %This should have all U* values
% % Let's look at histograms of ustar values that have or don't have NEE values present
% % (so if NEE was ustar filtered, it should be NAN, and so ustar conditional 
% % on NEE presence should have been removed)
% % Histogram of 'okdata' ustar
% nbins=39;
% % Histogram of ustar in original data (some values are negative?)
% figure()
% hist(data(:,13),nbins) % data is climate data matrix
% xlabel('U*')
% % Histogram of ustar in 'non-gap-filled' data
% figure()
% hist(okdata(:,13),nbins) % okdata is climate data matrix with flags 1, 4 or 5
% xlabel('U*')
% % Histogram of ustar only when NEE with ustar filter is not NAN
% ind=find(isnan(OKdata(:,8))==0); %1 means is nan, 0 means not nan
% ustarForNEE=(okdata(ind,13));
% figure()
% hist(ustarForNEE,nbins)
% xlabel('U*')

%% Check 4: Look at new water flux column (with ustar filter applied)

% % The water flux column without the ustar filter should have more data than
% % the ustar filter with the ustart filter
% 
% H2O_OK = sum(isnan(OKdata(:,15)));
% H2O_OK_ustar = sum(isnan(OKdata(:,21)));
% 
% % Plot ustar and non-ustar filtered water flux column versus u*
% figure()
% scatter(ustar_21m, OKdata(:,15)) % only flag filtered
% figure()
% scatter(ustar_21m, OKdata(:,21)) % flag and .2 ustar filtered


%% Some code for trouble-shooting
% 
% Find where the differences are between the OKdata flux columns
% trouble = find(OKdata(:,8)~=OKdata(:,9));
%
% See how many flags are different between the two NEE flag columns
% flagdatads = mat2dataset(flagdata);
% counter = grpstats(flagdatads,{'flagdata8','flagdata9'},'numel','DataVars','flagdata10');
%
% Above shows that none of the differences between co2 nee flux and co2 nee
% flux with ustar happened when the flags were 4 or 5.