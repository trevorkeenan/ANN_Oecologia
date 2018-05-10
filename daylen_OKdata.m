% This script takes the output of 'Match_data_flags.m', which is a climate
% file or flux file that includes only data with flags 1,4 and 5 OR 
% takes as input the concatenated climate files made with the
% script "concatenate.m" (based on whether you want to use gap filled or 
% not gap filled data)  Then it determines whether each half-hour period will
% be counted as day or night for the purposes of half-day (daytime or nighttime
% averages).  Then it calculates half-day averages for all flux variables and all 
% climate variables except for precipitation (calculates half-day sums of 
% precipitation.  Note that precip has no gaps, so summing non-gap-filled 
% or gap filled should be okay).  Whether a daytime/nighttime averaged data
% point is considered NaN depends upon a threshold defined in this script.
% Script based on Laura Scott-Denton's munge_niwot_pt2.m and Dave's
% daylen.m scripts.  A threshold is set for whether a half-day's data is
% included or whether that half-day is counted as NaN.
%
% Note--when using gap-filled data from script concatenate.m, the threshold 
% is still applied because this is the Ameriflux data, and there are still
% some NaNs despite gap-filling noted by the flags.
%
% After this script, next step is 'prep_data_for_ANN.m'
%
% To do: 
% 1) Choose whether to use climate or flux data under 'changeable options'
% 2) Choose a 'cut off' threshold for whether to include half-day periods with 
% equal to or more than that amount of data (generally used 0.5).
% 3) If using more data than 1998 through 2013, change timeY: figure out 
%    how many days you need, given number of years. 
% 4) Create the correct number of elements for radY, parAY, daylenY, timeY
%    given number of years
% 5) If the format of the input file changes, need to re-define which
%    column is precipitation in the 'for' loop in automated section 4.
%    Precipitation is treated differently because it is summed not averaged.
% Note: as of 1-28-15, script is set up for Niwot 1998 through 2013

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To check:  
% 1) compare how I do threshold for inclusion with how Laura 
% does it; 
% 2) check lat/long for niwot--Latitude correct, check meridian offset.
% According to Scott-Denton 2013, the lat and long of Niwot are 40 deg 1'58''N
% and 105 deg 32'47''W respectively.  Conversion to decimal degrees (see
% transition.fcc.gov/mb/audio/bickel/DDDMMSS-decimal.html) gives correct
% latitude below.
% 3) What percentage of total half-day time periods were above threshold?
%  (Did count of NEE above threshold for Datatype == 2, see lines around
%  402)
% 4) Check that mean ignores NaNs (maybe need to use nanmean command
% instead?)--DONE (grpstats help says "grpstats treats NaNs as missing
% values, and removes them from the input data before calculating summary
% statistics.")
% 5) Note that Trevor's simple script sums precip, %R_global_in
% (NACP variable) and %R_longwave_in (NACP variable) but averages other
% climate variables.  Check what people usually do for radiation.
% 6) Fix code for data quality checks (add if statements for Datatype ==3
% or ==4)
% 7) Try running data == 4 (haven't tried that yet, but wrote code.  Make 
% sure it includes everything in other parts of if statement).  Only try if
% I think I'll need gap-filled flux data for the ANN.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%%%%%%%%%%%%%%%%%%%%%%
%% Changable options %
%%%%%%%%%%%%%%%%%%%%%%

% Change directory if not already there
% cd('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
% cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')


% Path names and output file path
%fileyear = 1998; %Year for data and flags files when going year by year
filepath = char('../../../NR data/Data output from matlab/'); %directory where files live
filepathout = char('../../../NR data/Data output from matlab/'); %directory for output

% Choose 1 for climate data file that includes only data with flags 1,4 and 5.
% Choose 2 for flux data file that includes only data with flags 1,4 and 5.
% Choose 3 for climate data file that is gap-filled (all flags included).
% Choose 4 for fluxdata file that is gap-filled (all flags included).
Datatype = 2;

% Set threshold of percent of data present for inclusion of half-day in output
threshold = 0.5; 

% This script has a few lines that calculate more stats for flux data for 
% plotting with pheno_period_NEE_climate_graphsv3.m. I probably don't need
% these extra stats though.
calcFluxPrctile = 0; %set to 1 to calculate and export

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 1--Import data and assign output file name%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If statement for importing data and choosing output file name based on data type
if Datatype == 1
    filename = strcat('climate_allyears_OKflags.txt'); %Output from Match_data_flags
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab'); 
    filenameout = strcat('climate_allyears_OKflags_daylen_thresh',num2str(threshold),'.txt'); % Output filename
elseif Datatype == 2
    filename = strcat('flux_allyears_OKflags.txt'); %Output from Match_data_flags
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate Fco2_21m_nee_stat_int_Ustar Fco2_21m_nee_stat_int Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle w_h2o_21m_Ustar] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    filenameout = strcat('flux_allyears_OKflags_daylen_thresh',num2str(threshold),'.txt'); % Output filename
elseif Datatype == 3
    filename = strcat('climate_allyears.txt'); %Output from Concatenate
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab'); 
    filenameout = strcat('climate_allyears_daylen_thresh',num2str(threshold),'.txt'); % Output filename
elseif Datatype == 4
     filename = strcat('flux_allyears.txt'); %Output from Concatenate
    filetoopen = strcat(filepath,filename); %concatenate file path with file name
    [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
    filenameout = strcat('flux_allyears_daylen_thresh',num2str(threshold),'.txt'); % Output filename
end
outputfilepath = strcat(filepathout,filenameout);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 2--Calculate daylengths for normal and leap years     % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Latitude, longitude and Central Meridian for Niwot Ridge
lat = 40.03;
latRad = lat*(pi/180);
omega = 0.2618; % pi/12
hrOffset = -0.036; % (Long - CentralMeridian)/15
% LPA note, the central meridian for Niwot area seems to be 33, so I calculate
% -0.014, but wouldn't make a difference in day length (see below, sunrise and sunset don't include offset).

parFrac = 1.0;
sunFrac = 1.0;

nt_nrm=24*365;
nt_leap=24*366;

% normal years
for doy=1:365	
	dayAng = 2*pi*(doy-1)/365;
	eccent = 1.000110 + 0.034221*cos(dayAng) + 0.00128*sin(dayAng) + 0.000719*cos(2*dayAng) + 0.000077*sin(2*dayAng);
	decl = (0.006918 - 0.399912*cos(dayAng) + 0.070257*sin(dayAng) - 0.006758*cos(2*dayAng) + 0.000907*sin(2*dayAng) - 0.002697*cos(3*dayAng) + 0.00148*sin(3*dayAng));

    for hr = 0:0.5:23.5 % every half hour
        k = (doy - 1)*48 + hr*2 + 1;
        t=mod((hr+0.25)+hrOffset,24)-12; % add 0.25 to put us in the middle of the timestep
		sza_nrm(k) = acos(sin(latRad)*sin(decl) + cos(latRad)*cos(decl)*cos(omega*t));
		rad_nrm(k) = max([0,parFrac*1367*eccent*(cos(decl)*cos(latRad)*cos(omega*t) + sin(decl)*sin(latRad))]);
		parA_nrm(k) = (.18+(.62*sunFrac))*((rad_nrm(k)*0.001*2.05*10000000)/10000);
	end 	
	srise_nrm(doy) = -(acos(-tan(decl)*tan(latRad))/omega); % don't bother doing offset on srise and sset
	sset_nrm(doy) = +(acos(-tan(decl)*tan(latRad))/omega); % because we only care about their difference
    daylen_nrm(doy) = sset_nrm(doy)-srise_nrm(doy);
end

% leap years
for doy=1:366
	dayAng = 2*pi*(doy-1)/366;
	eccent = 1.000110 + 0.034221*cos(dayAng) + 0.00128*sin(dayAng) + 0.000719*cos(2*dayAng) + 0.000077*sin(2*dayAng);
	decl = (0.006918 - 0.399912*cos(dayAng) + 0.070257*sin(dayAng) - 0.006758*cos(2*dayAng) + 0.000907*sin(2*dayAng) - 0.002697*cos(3*dayAng) + 0.00148*sin(3*dayAng));

    for hr = 0.5:0.5:24 % every half hour
        k = (doy - 1)*48 + hr*2;
        t=mod((hr-0.25)+hrOffset,24)-12; % subtract 0.25 to put us in the middle of the timestep
        sza_leap(k) = acos(sin(latRad)*sin(decl) + cos(latRad)*cos(decl)*cos(omega*t));
		rad_leap(k) = max([0,parFrac*1367*eccent*(cos(decl)*cos(latRad)*cos(omega*t) + sin(decl)*sin(latRad))]);
		parA_leap(k) = (.18+(.62*sunFrac))*((rad_leap(k)*0.001*2.05*10000000)/10000);
	end 	
	srise_leap(doy) = -(acos(-tan(decl)*tan(latRad))/omega); % don't bother doing offset on srise and sset
	sset_leap(doy) = +(acos(-tan(decl)*tan(latRad))/omega); % because we only care about their difference
    daylen_leap(doy) = sset_leap(doy)-srise_leap(doy);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 3--Combine year 1998, normal years, and leap years %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To do if you change years from range 1998 to 2012:
% 1) Change timeY: figure out how many days you need, given number of years, 
% 2) Create the correct number of elements for radY, parAY, daylenY

% last 2928 half-hours (61 days) of 1998
rad_1998 = rad_nrm(end-2927:end);
parA_1998 = parA_nrm(end-2927:end);
daylen_1998 = daylen_nrm(end-60:end);

% 365 days for 1999, 2001, 2002, 2003, 2005, 2006, 2007, 2009, 2010, 2011, 2013;
% 366 days for 2000, 2004, 2008, 2012; 
% last 61 days of 1998
timeY = 1:(48*(61+365*11+366*4)); % 10 normal years and 4 leap years
radY = [rad_1998';rad_nrm';rad_leap';rad_nrm';rad_nrm';rad_nrm';rad_leap';rad_nrm';rad_nrm';rad_nrm'; rad_leap';rad_nrm';rad_nrm';rad_nrm'; rad_leap';rad_nrm'];
parAY = [parA_1998';parA_nrm';parA_leap';parA_nrm';parA_nrm';parA_nrm';parA_leap';parA_nrm';parA_nrm';parA_nrm';parA_leap';parA_nrm';parA_nrm';parA_nrm';parA_leap';parA_nrm'];
daylenY = [daylen_1998';daylen_nrm';daylen_leap';daylen_nrm';daylen_nrm';daylen_nrm';daylen_leap';daylen_nrm';daylen_nrm';daylen_nrm';daylen_leap';daylen_nrm';daylen_nrm';daylen_nrm';daylen_leap';daylen_nrm'];

ndays = length(parAY)/48; % Calculate number of days by dividing payAY by number of half-hours

% Count how many half-hour periods were light within each day
for i=1:ndays
    r = (i-1)*48+1:i*48; % half-hours
    nlight(i)=length(find(parAY(r)>0));
end
nlight = nlight';
%potpar = parAY;
daylen = daylenY;

% Some figures for fun
%figure;
%plot(timeY,parAY,timeY,radY)
%figure;
%plot(ndays,parAY)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 4--Calculate half-day averages of non-gap-filled CLIMATE data and threshold by data available% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Datatype == 1

q=parAY; % parAY is calculated as maximum potential par (ie. daylight)
q(find(q>0))=1; % this makes "day" = 1, "night" = 0
%q=diff(q); % this marks the timestep where night turns to day as 1. Day to night is =-1. Shortens q by one element.
%q(end+1)=1; % puts an 1 at end of q to make it correct length again.
%q=abs(q); % makes all the transition timesteps = 1.
%w=find(q==1); % creates an array indexing all transition timestep positions
%i0=1;

% Make matrix then a dataset out of column vectors
data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m q];
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m', 'q'};
dataset1 = dataset({data,header{:}});
%dataset.Properties %look at properties
%ds = mat2dataset(data); %Turns data into type dataset, but without headers

% Make ordinal variable for day and night based on "q"
labels = {'night' 'day'};
dataset1.quantum = ordinal(dataset1.q,labels);

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(Year(:));
Y = max(Year(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
dataset1.YearOrd = ordinal(dataset1.Year,labels2,[],edges);
%dataset1.YearNom = nominal(dataset1.Year,labels2,[],edges); %Just to test if this acts the same

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(DecimalDate(:)));
M = floor(max(DecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
%ordDay = ordinal(DecimalDate,labels,[],edges); %this makes a vector of day
%w/o decimal, but the command below actually adds the new ordinal column
dataset1.Day = ordinal(dataset1.DecimalDate,labels,[],edges);

% Calculate variable means by combination of year, day of year and day/night
% Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
% Note that 'MO' is included as a data variable simply as a way to keep it
% in the dataset (and the mean of the month numbers should still represent the month)
% Calculate daily means:
% statmean = grpstats(dataset1,'Day','mean','DataVars',{'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
% Calculate half-day means for each day of each year
statmean = grpstats(dataset1,{'YearOrd','Day','quantum'},'mean','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
statcount = grpstats(dataset1,{'YearOrd','Day','quantum'},'numel','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
% For precipitation, calculate sum
statsum = grpstats(dataset1,{'YearOrd','Day','quantum'},'sum','DataVars',{'MO','precip_mm'});
% test = grpstats(dataset1,{'YearNom','Day','quantum'},'numel','DataVars',{'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
% statcountnum = double(statcount); %Turn dataset into numeric array.  For some reason it reassigns ordinal years to numbers (e.g. 1998 becomes 1)
% statTest = double(statmean); % Same problem--1998 turns into a 1.

% Calculate what percentage of data is present for calculations of half-days averages
% (Note, I figured out a better way to do this in the flux data section
% below)
GroupC = statcount.GroupCount; %This is the number of possible half-hour periods in each half-day period
%Divide each variable by number of elements it should have to be complete 
T_21m_perc = statcount.numel_T_21m./GroupC; 
RH_21m_perc= statcount.numel_RH_21m./GroupC;
P_bar_12m_perc= statcount.numel_P_bar_12m./GroupC;
ws_21m_perc= statcount.numel_ws_21m./GroupC;
wd_21m_perc= statcount.numel_wd_21m./GroupC;
ustar_21m_perc= statcount.numel_ustar_21m./GroupC;
z_L_21m_perc= statcount.numel_z_L_21m./GroupC;
precip_mm_perc= statcount.numel_precip_mm./GroupC;
Td_21m_perc= statcount.numel_Td_21m./GroupC;
vpd_perc= statcount.numel_vpd./GroupC;
wet_b_perc= statcount.numel_wet_b./GroupC;
T_soil_perc= statcount.numel_T_soil./GroupC;
T_bole_pi_perc= statcount.numel_T_bole_pi./GroupC;
T_bole_fi_perc= statcount.numel_T_bole_fi./GroupC;
T_bole_sp_perc= statcount.numel_T_bole_sp./GroupC;
Rppfd_in__perc= statcount.numel_Rppfd_in_./GroupC;
Rppfd_out_perc= statcount.numel_Rppfd_out./GroupC;
Rnet_25m__perc= statcount.numel_Rnet_25m_./GroupC;
Rsw_in_25_perc= statcount.numel_Rsw_in_25./GroupC;
Rsw_out_2_perc= statcount.numel_Rsw_out_2./GroupC;
Rlw_in_25_perc= statcount.numel_Rlw_in_25./GroupC;
Rlw_out_2_perc= statcount.numel_Rlw_out_2./GroupC;
T_2m_perc= statcount.numel_T_2m./GroupC;
T_8m_perc= statcount.numel_T_8m./GroupC;
RH_2m_perc= statcount.numel_RH_2m./GroupC;
RH_8m_perc= statcount.numel_RH_8m./GroupC;
h2o_soil_perc= statcount.numel_h2o_soil./GroupC;
co2_21m_perc= statcount.numel_co2_21m./GroupC;

% Make new array from vectors representing percentage of data 'present'
sameColumns = double(statmean(:,1:5)); %columns 1 to 5 are not climate variables
perc_data = [sameColumns, T_21m_perc, RH_21m_perc, P_bar_12m_perc, ws_21m_perc, wd_21m_perc, ustar_21m_perc, z_L_21m_perc, precip_mm_perc, Td_21m_perc, vpd_perc, wet_b_perc, T_soil_perc, T_bole_pi_perc, T_bole_fi_perc, T_bole_sp_perc, Rppfd_in__perc, Rppfd_out_perc, Rnet_25m__perc, Rsw_in_25_perc, Rsw_out_2_perc, Rlw_in_25_perc, Rlw_out_2_perc, T_2m_perc, T_8m_perc, RH_2m_perc, RH_8m_perc, h2o_soil_perc, co2_21m_perc];


% Select half-day timesteps that meet the threshold criteria and put them
% in new array
numrows=size(statmean,1);
numcols=size(statmean,2);
colcount = zeros(1,numcols);
halfDayThresh = zeros(numrows,numcols);
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i>5 && i<=12 %Between 6 and 12 are climate variables to average
            if perc_data(j,i) >= threshold
            halfDayThresh(j,i) = statmean(j,i);
            else
                halfDayThresh(j,i) = NaN;
            end
        elseif i>=14 %Columns above 13 are climate variables to average
            if perc_data(j,i) >= threshold
            halfDayThresh(j,i) = statmean(j,i);
            else
                halfDayThresh(j,i) = NaN;
            end
        elseif i == 13 %Column 13 is precipitation and we want the sum not the mean
             if perc_data(j,i) >= threshold
            halfDayThresh(j,i) = statsum(j,'sum_precip_mm');
            else
                halfDayThresh(j,i) = NaN;
            end   
        elseif i <= 5
             halfDayThresh(j,i) = statmean(j,i); % Leave the first 5 columns alone--they are not climate variables
        end
    end
end

% For some reason converting ordinal year to numeric array makes it start
% at 1 instead of 1998.  Add 1997 to years to fix.
YearN = halfDayThresh(:,1:1) + 1997;
halfDayThresh(:,1:1) = YearN;

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names command to make
% 'statmean' dataset with 'GroupCount' added as the grpstats command adds that column
header = {'%Year','Day','quantum','GroupCount','MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,halfDayThresh,'-append','delimiter','\t');
% dlmwrite(outputfilepath,halfDayThresh,'\t'); %output tab delimited file without headers

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 5--Calculate half-day averages of non-gap-filled FLUX data and threshold by data available % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif Datatype == 2

q=parAY; % parAY is calculated as maximum potential par (ie. daylight)
q(find(q>0))=1; % this makes "day" = 1, "night" = 0

% Make matrix then a dataset out of column vectors
fluxdata = [Year MO DD HR MM SS DecimalDate Fco2_21m_nee_stat_int_Ustar Fco2_21m_nee_stat_int Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle w_h2o_21m_Ustar q];
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','w_h2o_21m_Ustar','q'};
fluxdataset1 = dataset({fluxdata,header{:}});

% Make ordinal variable for day and night based on "q"
labels = {'night' 'day'};
fluxdataset1.quantum = ordinal(fluxdataset1.q,labels);

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(DecimalDate(:)));
M = floor(max(DecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
fluxdataset1.Day = ordinal(fluxdataset1.DecimalDate,labels,[],edges);

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(Year(:));
Y = max(Year(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
fluxdataset1.YearOrd = ordinal(fluxdataset1.Year,labels2,[],edges);

% Calculate variable means by combination of year, day of year and day/night
% Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
% Note that 'MO' is included as a data variable simply as a way to keep it
% in the dataset (and the mean of the month numbers should still represent the month)
% Calculate means
fstatmean = grpstats(fluxdataset1,{'YearOrd','Day','quantum'},'mean','DataVars',{'MO','Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','w_h2o_21m_Ustar','q'});
% Calculate number of elements in each group
fstatcount = grpstats(fluxdataset1,{'YearOrd','Day','quantum'},'numel','DataVars',{'MO','Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','w_h2o_21m_Ustar','q'});
fstatcountnum = double(fstatcount); %Turn dataset into numeric array.  For some reason it reassigns ordinal years to numbers (e.g. 1998 becomes 1)

% Calculate more stats for variables that will be plotted. This will be
% exported separately for possible plotting in pheno_period_NEE_climate_graphsv3.m
% Stats by combination of year, day of year and day/night
if calcFluxPrctile == 1
    moreFluxStats = grpstats(fluxdataset1,{'YearOrd','Day','quantum'},...
        {'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},...
        'DataVars',{'MO','Fco2_21m_nee_stat_int_Ustar','Fco2_21m_nee_stat_int',...
        'w_h2o_21m','w_h2o_21m_Ustar','q'});
else
end

% Calculate what percentage of data is present for calculations of half-days averages
GroupC = fstatcount.GroupCount;
num_data_cols = size(fstatcount,2)-5;
GroupCmatrix = repmat(GroupC,1,num_data_cols); % Create a matrix of Group C
fYearStat = double(fstatcount);
f_perc_data = fYearStat(:,6:end)./GroupCmatrix; % divide each element of fYearStat by same element of GroupCmatrix
% Make columns for first four columns of f_perc_data
day = double(fstatmean(:,2:2));
quantum = double(fstatmean(:,3:3));
groupCount = double(fstatmean(:,4:4));
YearN = double(fstatmean(:,1:1)) + 1997; % For some reason converting ordinal year to numeric array makes it start at 1 instead of 1998.  Add 1997 to years to fix.
Month = double(fstatmean(:,5:5));
% Add back first five columns (non-data columns)
flux_perc_data = [YearN, day, quantum, groupCount, Month, f_perc_data];
disp(['There are ',num2str(sum(flux_perc_data(:,6)>=threshold)),' non-gap-filled NEE half-days with proportion of data present above or equal to ', num2str(threshold),' out of ', num2str(length(day)), ' possible']);
disp(['There are ',num2str(sum(flux_perc_data(:,7)>=threshold)),' ustar (but not stationarity/integral stats) non-gap-filled NEE half-days with proportion of data present above or equal to ', num2str(threshold)]);
disp(['There are ',num2str(sum(flux_perc_data(:,13)>=threshold)),' non-gap-filled water flux half-days with proportion of data present above or equal to ', num2str(threshold),' out of ', num2str(length(day)), ' possible']);
disp(['There are ',num2str(sum(flux_perc_data(:,19)>=threshold)),' ustar filtered non-gap-filled water flux half-days with proportion of data present above or equal to ', num2str(threshold)]);
% total daytime and nighttime half-days
sum(flux_perc_data(:,3)>1)

% Select half-day timesteps that meet the threshold criteria and put them
% in new array
numrows=size(fstatmean,1);
numcols=size(fstatmean,2);
colcount = zeros(1,numcols);
fhalfDayThresh = zeros(numrows,numcols);
count = 0;
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i>5
            if flux_perc_data(j,i) >= threshold
            fhalfDayThresh(j,i) = fstatmean(j,i);
            else
                fhalfDayThresh(j,i) = NaN;
            end
        elseif i <= 5
             fhalfDayThresh(j,i) = fstatmean(j,i);   
        end
    end
end


% For some reason converting ordinal year to numeric array makes it start
% at 1 instead of 1998.  Add 1997 to years to fix.
YearN = fhalfDayThresh(:,1:1) + 1997;
fhalfDayThresh(:,1:1) = YearN;

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names command to make
% 'fstatmean' dataset with 'GroupCount' added as the grpstats command adds that column
header = {'%Year','Day','quantum', 'GroupCount','Month','Fco2_21m_nee_stat_int_Ustar', 'Fco2_21m_nee_stat_int', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','w_h2o_21m_Ustar','q'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,fhalfDayThresh,'-append','delimiter','\t');
%%dlmwrite(outputfilepath,fhalfDayThresh,'\t'); %output tab delimited file without header

if calcFluxPrctile == 1
    % Export the stats for the flux data for plotting
    export(moreFluxStats,'file','moreFluxStats.txt')
else
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 6 -- CLIMATE data file that is gap-filled (all flags included)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif Datatype == 3

q=parAY; % parAY is calculated as maximum potential par (ie. daylight)
q(find(q>0))=1; % this makes "day" = 1, "night" = 0

% Make matrix then a dataset out of column vectors
data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m q];
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m', 'q'};
dataset1 = dataset({data,header{:}});
%dataset.Properties %look at properties
%ds = mat2dataset(data); %Turns data into type dataset, but without headers

% Make ordinal variable for day and night based on "q"
labels = {'night' 'day'};
dataset1.quantum = ordinal(dataset1.q,labels);

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(Year(:));
Y = max(Year(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
dataset1.YearOrd = ordinal(dataset1.Year,labels2,[],edges);
%dataset1.YearNom = nominal(dataset1.Year,labels2,[],edges); %Just to test if this acts the same

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(DecimalDate(:)));
M = floor(max(DecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
%ordDay = ordinal(DecimalDate,labels,[],edges); %this makes a vector of day
%w/o decimal, but the command below actually adds the new ordinal column
dataset1.Day = ordinal(dataset1.DecimalDate,labels,[],edges);

% Calculate variable means by combination of year, day of year and day/night
% Calculate daily means:
statmean = grpstats(dataset1,{'YearOrd','Day','quantum'},'mean','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
statcount = grpstats(dataset1,{'YearOrd','Day','quantum'},'numel','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
% For precipitation, calculate sum
statsum = grpstats(dataset1,{'YearOrd','Day','quantum'},'sum','DataVars',{'MO','precip_mm'});

% Calculate what percentage of data is present for calculations of half-days averages
% (Note, I figured out a better way to do this in the flux data section)

GroupC = statcount.GroupCount; %This is the number of possible half-hour periods in each half-day period
%Divide each variable by number of elements it should have to be complete 
T_21m_perc = statcount.numel_T_21m./GroupC; 
RH_21m_perc= statcount.numel_RH_21m./GroupC;
P_bar_12m_perc= statcount.numel_P_bar_12m./GroupC;
ws_21m_perc= statcount.numel_ws_21m./GroupC;
wd_21m_perc= statcount.numel_wd_21m./GroupC;
ustar_21m_perc= statcount.numel_ustar_21m./GroupC;
z_L_21m_perc= statcount.numel_z_L_21m./GroupC;
precip_mm_perc= statcount.numel_precip_mm./GroupC;
Td_21m_perc= statcount.numel_Td_21m./GroupC;
vpd_perc= statcount.numel_vpd./GroupC;
wet_b_perc= statcount.numel_wet_b./GroupC;
T_soil_perc= statcount.numel_T_soil./GroupC;
T_bole_pi_perc= statcount.numel_T_bole_pi./GroupC;
T_bole_fi_perc= statcount.numel_T_bole_fi./GroupC;
T_bole_sp_perc= statcount.numel_T_bole_sp./GroupC;
Rppfd_in__perc= statcount.numel_Rppfd_in_./GroupC;
Rppfd_out_perc= statcount.numel_Rppfd_out./GroupC;
Rnet_25m__perc= statcount.numel_Rnet_25m_./GroupC;
Rsw_in_25_perc= statcount.numel_Rsw_in_25./GroupC;
Rsw_out_2_perc= statcount.numel_Rsw_out_2./GroupC;
Rlw_in_25_perc= statcount.numel_Rlw_in_25./GroupC;
Rlw_out_2_perc= statcount.numel_Rlw_out_2./GroupC;
T_2m_perc= statcount.numel_T_2m./GroupC;
T_8m_perc= statcount.numel_T_8m./GroupC;
RH_2m_perc= statcount.numel_RH_2m./GroupC;
RH_8m_perc= statcount.numel_RH_8m./GroupC;
h2o_soil_perc= statcount.numel_h2o_soil./GroupC;
co2_21m_perc= statcount.numel_co2_21m./GroupC;

% Make new array from vectors representing percentage of data 'present'
sameColumns = double(statmean(:,1:5)); %columns 1 to 5 are not climate variables
perc_data = [sameColumns, T_21m_perc, RH_21m_perc, P_bar_12m_perc, ws_21m_perc, wd_21m_perc, ustar_21m_perc, z_L_21m_perc, precip_mm_perc, Td_21m_perc, vpd_perc, wet_b_perc, T_soil_perc, T_bole_pi_perc, T_bole_fi_perc, T_bole_sp_perc, Rppfd_in__perc, Rppfd_out_perc, Rnet_25m__perc, Rsw_in_25_perc, Rsw_out_2_perc, Rlw_in_25_perc, Rlw_out_2_perc, T_2m_perc, T_8m_perc, RH_2m_perc, RH_8m_perc, h2o_soil_perc, co2_21m_perc];

% Select half-day timesteps that meet the threshold criteria and put them
% in new array
numrows=size(statmean,1);
numcols=size(statmean,2);
colcount = zeros(1,numcols);
halfDay = zeros(numrows,numcols);
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i>5 && i<=12 %Between 6 and 12 are climate variables to average
            if perc_data(j,i) >= threshold
            halfDay(j,i) = statmean(j,i);
            else
                halfDay(j,i) = NaN;
            end
        elseif i>=14 %Columns above 13 are climate variables to average
            if perc_data(j,i) >= threshold
            halfDay(j,i) = statmean(j,i);
            else
                halfDay(j,i) = NaN;
            end
        elseif i == 13 %Column 13 is precipitation and we want the sum not the mean
             if perc_data(j,i) >= threshold
            halfDay(j,i) = statsum(j,'sum_precip_mm');
            else
                halfDay(j,i) = NaN;
            end   
        elseif i <= 5
             halfDay(j,i) = statmean(j,i); % Leave the first 5 columns alone--they are not climate variables
        end
    end
end

% For some reason converting ordinal year to numeric array makes it start
% at 1 instead of 1998.  Add 1997 to years to fix.
YearN = halfDay(:,1:1) + 1997;
halfDay(:,1:1) = YearN;

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names command to make
% 'statmean' dataset with 'GroupCount' added as the grpstats command adds that column
header = {'%Year','Day','quantum','GroupCount','MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,halfDay,'-append','delimiter','\t');
% dlmwrite(outputfilepath,halfDay,'\t'); %output tab delimited file without headers


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Automated 7 -- FLUX data file that is gap-filled (all flags included)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif Datatype == 4

q=parAY; % parAY is calculated as maximum potential par (ie. daylight)
q(find(q>0))=1; % this makes "day" = 1, "night" = 0

% Make matrix then a dataset out of column vectors
fluxdata = [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle q];
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','q'};
fluxdataset1 = dataset({fluxdata,header{:}});

% Make ordinal variable for day and night based on "q"
labels = {'night' 'day'};
fluxdataset1.quantum = ordinal(fluxdataset1.q,labels);

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(DecimalDate(:)));
M = floor(max(DecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
fluxdataset1.Day = ordinal(fluxdataset1.DecimalDate,labels,[],edges);

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(Year(:));
Y = max(Year(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
fluxdataset1.YearOrd = ordinal(fluxdataset1.Year,labels2,[],edges);

% Calculate variable means by combination of year, day of year and day/night
% Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
% Note that 'MO' is included as a data variable simply as a way to keep it
% in the dataset (and the mean of the month numbers should still represent the month)
% Calculate means
fstatmean = grpstats(fluxdataset1,{'YearOrd','Day','quantum'},'mean','DataVars',{'MO','Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','q'});
% Calculate number of elements in each group
fstatcount = grpstats(fluxdataset1,{'YearOrd','Day','quantum'},'numel','DataVars',{'MO','Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','q'});
fstatcountnum = double(fstatcount); %Turn dataset into numeric array.  For some reason it reassigns ordinal years to numbers (e.g. 1998 becomes 1)

% Calculate what percentage of data is present for calculations of half-days averages
GroupC = fstatcount.GroupCount;
GroupCmatrix = repmat(GroupC,1,14); % Create a matrix of Group C
fYearStat = double(fstatcount);
f_perc_data = fYearStat(:,6:end)./GroupCmatrix; % divide each element of fYearStat by same element of GroupCmatrix
% Make columns for first four columns of f_perc_data
day = double(fstatmean(:,2:2));
quantum = double(fstatmean(:,3:3));
groupCount = double(fstatmean(:,4:4));
YearN = double(fstatmean(:,1:1)) + 1997; % For some reason converting ordinal year to numeric array makes it start at 1 instead of 1998.  Add 1997 to years to fix.
Month = double(fstatmean(:,5:5));
% Add back first five columns (non-data columns)
flux_perc_data = [YearN, day, quantum, groupCount, Month, f_perc_data];

% Select half-day timesteps that meet the threshold criteria and put them
% in new array
numrows=size(fstatmean,1);
numcols=size(fstatmean,2);
colcount = zeros(1,numcols);
fhalfDay = zeros(numrows,numcols);
count = 0;
for i = 1:numcols %Going through each column
    for j = 1:numrows %Going through each row
        if i>5
            if flux_perc_data(j,i) >= threshold
            fhalfDay(j,i) = fstatmean(j,i);
            else
                fhalfDay(j,i) = NaN;
            end
        elseif i <= 5
             fhalfDay(j,i) = fstatmean(j,i);   
        end
    end
end


% For some reason converting ordinal year to numeric array makes it start
% at 1 instead of 1998.  Add 1997 to years to fix.
YearN = fhalfDay(:,1:1) + 1997;
fhalfDay(:,1:1) = YearN;

% Export data into tab-delimited file
% Note that header names are hard-coded and based on names command to make
% 'fstatmean' dataset with 'GroupCount' added as the grpstats command adds that column
header = {'%Year','Day','quantum', 'GroupCount','Month','Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle','q'};
fid = fopen(outputfilepath, 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(outputfilepath,fhalfDay,'-append','delimiter','\t');
% dlmwrite(outputfilepath,fhalfDay,'\t'); %output tab delimited file without header

end


%% Checks and quality control
%  
% This section causes errors to show up if certain criteria are not met.
%
% Check 1: halfDayThresh or fhalfDayThresh have same number of columns as
% output header
% (Can add if Datatype ==3 or 4 here)
if Datatype == 1
    if abs(size(halfDayThresh,2)-size(header,2))>0
        error('Check 1: columns of dataset do not equal number of columns in header')
    end
elseif Datatype == 2
    if abs(size(fhalfDayThresh,2)-size(header,2))>0
        error('Check 1: columns of dataset do not equal number of columns in header')
    end
end

% Check 2: What are the minimum and maximum values of temperature for 30
% minutes average data and half-day average data?
% Could add Datatype==4 here
if Datatype == 1
    disp(['For 30 minute averaged data, non-gap-filled T_21m ranges from ',num2str(min(data(:,8))),' to ', num2str(max(data(:,8)))]);
    disp(['For half-day averaged data, non-gap-filled T_21m ranges from ',num2str(min(halfDayThresh(:,6))),' to ', num2str(max(halfDayThresh(:,6)))]);
    % find(halfDayThresh(:,6)<-29)
    % find(data(:,8)==-34.12)
elseif Datatype == 2
    disp(['For 30 minute averaged data, non-gap-filled NEE ranges from ',num2str(min(fluxdata(:,8))),' to ', num2str(max(fluxdata(:,8)))]);
    disp(['For half-day averaged data, non-gap-filled NEE ranges from ',num2str(min(fhalfDayThresh(:,6))),' to ', num2str(max(fhalfDayThresh(:,6)))]);
elseif Datatype == 3
    disp(['For 30 minute averaged data, gap-filled T_21m ranges from ',num2str(min(data(:,8))),' to ', num2str(max(data(:,8)))]);
    disp(['For half-day averaged data, gap-filled T_21m ranges from ',num2str(min(halfDay(:,6))),' to ', num2str(max(halfDay(:,6)))]);
end

% Check 3: For a random day, calculate mean for variables for one random
% day and compare to dataset averages produced above.
% Could add if Datatype==1,2,4 here
if Datatype == 3
ind30min=find(data(:,1)==2004 & data(:,2)==1 & data(:,3)==25 & data(:,36)==1); %for column 36, "day" = 1, "night" = 0
testMat=data(ind30min,:);
meanTest=mean(testMat(:,:));
indHD=find(halfDay(:,1)==2004 & halfDay(:,2)==25 & halfDay(:,3)==2); %for column 3, 1=night and 2=day
meanTest2=halfDay(indHD,:); % The averages calculated here should be the same as meanTest (although column numbers are offset by two)
end

% % Check 4: Make some plots of U* (this will only work when Datatype==1 or 3)
% % All 30 minute time periods
% nbins=25;
% hist(ustar_21m,nbins)
% xlabel('U*')
% 
% % Night 30 minute time periods
% ustar_night_ind=find(q==0);
% ustar_night=data(ustar_night_ind,:);
% hist(ustar_night(:,13),nbins)
% xlabel('U*')
% title('U* during half-day night')
% 
% % Day 30 minute time periods
% ustar_day_ind=find(q==1);
% ustar_day=data(ustar_day_ind,:);
% hist(ustar_day(:,13),nbins)
% xlabel('U*')
% 
% % Scatterplot of U* versus hour of night
% scatter(ustar_night(:,4),ustar_night(:,13))
% xlabel('Hour (half-day night)')
% ylabel('U*')
