% Loren Albert
% spring 2015
% Updated spring 2017 for Oecologia re-submission

% This script makes plots of NEP, climate variables and start/end dates for
% each ecosystem phenology period for the Niwot Ridge ANN project, and 
% saves them as .eps files.  The goal for this script is to show overall
% patterns for NEP and climate. Version 2 just uses precip and SWE for env
% variables (had problems adding temperature with temperature iqr using plotyy, see notes). 
%
% Inputs: 
% 1) output of 'concatenate.m' (all data) or 'Match_data_flags.m' (which is a flux file that includes only data with flags 1,4 and 5.
% 
% 2) The output from define_start_stop_dates.m, which is a matrix of start
% and stop date indices and doy for each ecosystem phenology period (loaded
%
% 3) Daytime averaged flux data
%
% 4) Nighttime averaged flux data
%
% Sections:
% Section 0: Some Changeable options
% Section 1: Section 1: Load NEE flux data, start/stop dates, make matrices, calculate NEP & stats
% Section 1B: Load HALF-DAY flux data
% Section 2: Load environment data, make matrices, calculate environment stats
% Section 3: Plot daily NEP for each year
% Section 4: Plot MEAN daily NEP for all years with interquartile range (as a subplot panel)
% Section 5: Boxplots for start/end dates for periods (as a subplot panel)
% Section 6: Plot MEAN daily environment variables for all years with stand. dev. (as a subplot panel)
% Section 7: Plot mean DAYTIME NEP for all years with interquartile range (as a subplot panel)
% Section 8: Plot mean NIGHTTIME NEP for all years with interquartile range (as a subplot panel)
% etc....
%
% To do:
% 1) Choose gap-filled or non-gap filled data 
% 2) Choose which NEE column to use to calculate NEP
% 3) Change filename for use with laptop directory or mac mini directory
% (if there is an error about load_snotel, check the directory in that
% script too)
% 4) Change font sizes in 'parameters to set' if necessary
% 5) Check that directories in section 1 and 2 are correct for current
% computer (for loading snotel, start/stop, climate data and NEE)(if they
% aren't, there will be an error)

% To fix:
% 1) Add code to export figures--DONE for .fig file (need to save as .eps
% manually)
% 2) Check a sum of NEP for a period or two to make sure it worked

% Notes:
% 1) Start/stop dates currently hard-coded to use
% 'start_stop_from_climate_allyears_OKflags.txt' (I think this was the only
% version of start/stop dates I made so far).
% 2) NEP daily sums and annual stats from daily sums ignore NANs
% 3) Subplot Graphs do not exclude 1998 (which is the first year; incomplete year)
% But the NEP for each period plot does exclude 1998.
% 4) When I try to add mean temperature to plot (by mentioning second axis
% in plotyy) I get an error.  see:
% http://stackoverflow.com/questions/29980757/add-shaded-area-to-plotyy-in-matlab/29984101?noredirect=1#comment48104876_29984101

% Resources:
% http://stackoverflow.com/questions/22572761/how-to-draw-two-box-plots-horizontally-and-at-the-same-height-in-one-figure
% http://stackoverflow.com/questions/9728970/matlab-extract-values-from-boxplot
% http://stackoverflow.com/questions/13935703/sum-of-values-between-start-and-end-date-in-matlab
% Reference for interquantile range calculations in Matlab: Statistics for
% Bioengineering Sciences: With MATLAB and WinBUGS Support pp 18-19.
% (There was also a ref online somewhere about how to use prctile command
% with grpstats).
% http://pirate.shu.edu/~wachsmut/Teaching/MATH1101/Descriptives/quartiles.html
% https://www.mathworks.com/matlabcentral/answers/53929-two-y-axes-in-subplot
% http://blogs.mathworks.com/pick/2012/12/21/figure-margins-subplot-spacings-and-more/

close all
clear all

%% Section 0: Some Changeable options

% Choose which NEE column to use to calculate NEP for half-hour data
% (daytime and nighttime are already hard-coded below)
NEP_col = 8;

% Some parameters to set
BigFont=14;
MediumFont= 13; %12;
SmallFont= 11; %8.8;

% IQR range color
iqr_col = [0.7 0.7 0.7];

% Precip color
precip_color = [84/255,39/255,136/255];

% SWE color
swe_col = [179/255,88/255,6/255];

% NEP color
nep_col = [26/255,152/255,80/255];

% ET color
ET_col = [50/255,136/255,189/255];

%% Section 1: Load 30 min NEE flux data, start/stop dates, make matrices, calculate NEP & stats

% Define file names for use with textread import
fileNames={'_allyears_OKflags','_allyears'};
fileOK_30=fileNames{1}; % For use with 'load' for non-gap-filled 30 min climate data
fileGF_30=fileNames{2}; % For use with 'load' for gap-filled 30 min climate data

% Load flux data, and set 'fileOK' or 'fileGF'
% Note: vector names used with textread are for gap-filled data... could
% change them if you use non-gap-filled data
filetoopen = strcat('../../../../NR data/Data output from matlab/flux',fileGF_30,'.txt');
[fYear, fMO, fDD, fHR, fMM, fSS, fDecimalDate, Fco2_21m_ne, Fco2_21m_nee_wust, Strg_co2, tu_w_21m, Taua_21m, Qh_21m, Qe_21m, w_h2o_21m, Qh_soil, Strg_Qh, Strg_Qe, Strg_bole, Strg_needle] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

% Make matrix then dataset of flux variables from columns
fluxMat=[fYear fMO fDD fHR fMM fSS fDecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle];

% Load Start & Stop dates
% filename = '/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
filename = '/Users/lalbert/Dropbox/Niwot Ridge project/NR data/Data output from matlab/start_stop_from_climate_allyears_OKflags.txt';
delimiterIn = '\t';
headerlinesIn = 1;
StartStop = importdata(filename,delimiterIn,headerlinesIn);

% Edit Start & stop dates
% (This is needed because in 'loadObsAndDrivers' I defined period starts
% and stops with offsets of a day sometimes, to avoid overlap between
% periods.  This makes DOY columns of Start & Stop dates consistent with DayStartMat
% produced for each period in 'loadObsAndDrivers')
StartStopAdjusted = StartStop.data(:,:);
StartStopAdjusted(:,5) = StartStopAdjusted(:,5)+1; %Offset start of premonsoon by one
StartStopAdjusted(:,9) = StartStopAdjusted(:,9)+1; %Offset start of post-monsoon by one
StartStopAdjusted(:,11) = StartStopAdjusted(:,11)+1; %Offset start of winter by one

% Add NEP column then convert to dataset
% NEP = -NEE
fluxMat(:,end+1) = -1*(fluxMat(:,NEP_col));
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'tu_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole', 'Strg_needle', strcat('NEPcol', mat2str(NEP_col))};
NEP_dataset1 = dataset({fluxMat,header{:}});

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(fYear(:));
Y = max(fYear(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
NEP_dataset1.YearOrd = ordinal(NEP_dataset1.Year,labels2,[],edges);

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(fDecimalDate(:)));
M = floor(max(fDecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
NEP_dataset1.Day = ordinal(NEP_dataset1.DecimalDate,labels,[],edges);

% Calculate daily sum NEP, and then the mean, etc of daily sum NEP for all years
% Calculate variable NEP sum for each doy by combination of year, and day of year
% Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
Sum_NEP_DS = grpstats(NEP_dataset1,{'YearOrd','Day'},'sum','DataVars',{'Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', strcat('NEPcol', mat2str(NEP_col))});
Sum_NEP = double(Sum_NEP_DS);
YearN = Sum_NEP(:,1:1) + 1997;
Sum_NEP(:,1:1) = YearN;
% export(Sum_NEP_DS,'file','Sum_NEP_DS_for_Russ.csv','Delimiter',',') % Export doy sums (Russ requested this dataset) export(DS,'file',filename,'Delimiter',delim)
% run NEE_DOY_plot_for_Russ.m % Plot for russ

% Calculate mean of summed NEP by DOY across all years (for mean NEP for each DOY)
doy_Sum_NEPDS = grpstats(Sum_NEP_DS,{'Day'},{'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},'DataVars',{strcat('sum_','NEPcol', mat2str(NEP_col))});
doy_Sum_NEP = double(doy_Sum_NEPDS);

%% Section 1B: Load HALF-DAY flux data

% Import daytime and nighttime data
DayObsMod = importdata('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/DataIn/flux_allyears_OKflags_daylen_thresh0.5_Day.txt');
NightObsMod = importdata('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/MatlabScripts_from_TK/DataIn/flux_allyears_OKflags_daylen_thresh0.5_Night.txt');

% Convert to double
DayfluxMat = DayObsMod.data;
NightfluxMat = NightObsMod.data;

% Add NEP column then convert to dataset
% NEP = -NEE
% Day
DayfluxMat(:,end+1) = -1*(DayfluxMat(:,7));
header = {DayObsMod.colheaders{:}, 'Day_NEP_col7'};
Dayflux_dataset1 = dataset({DayfluxMat,header{:}});
% Night
NightfluxMat(:,end+1) = -1*(NightfluxMat(:,6));
header = {NightObsMod.colheaders{:}, 'Night_NEP_col6'};
Nightflux_dataset1 = dataset({NightfluxMat,header{:}});

% Make a new data column based on year that is ordinal for stats
% Day
y = min(DayfluxMat(:,1));
Y = max(DayfluxMat(:,1));
labels2 = num2str((y:Y)');
edges = y:Y+1;
Dayflux_dataset1.YearOrd = ordinal(Dayflux_dataset1.Year,labels2,[],edges);
% Night
Nightflux_dataset1.YearOrd = ordinal(Nightflux_dataset1.Year,labels2,[],edges);

% Calculate mean NEP and ET by DOY across all years 
% Day
doy_DayFlux_DS = grpstats(Dayflux_dataset1,{'Day'},...
    {'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},...
    'DataVars',{'Day_NEP_col7','w_h2o_21m'});
doy_DayFlux = double(doy_DayFlux_DS);
% Night
doy_NightFlux_DS = grpstats(Nightflux_dataset1,{'Day'},...
    {'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},...
    'DataVars',{'Night_NEP_col6','w_h2o_21m_Ustar'});
doy_NightFlux = double(doy_NightFlux_DS);

%% Section 2: Load 30 min environment data, make matrices, calculate environment stats

% Load climate data, and set 'fileOK' or 'fileGF'
filetoopen = strcat('../../../../NR data/Data output from matlab/climate',fileGF_30,'.txt');
[Year, MO, DD, HR, MM, SS, DecimalDate, T_21m, RH_21m, P_bar_12m, ws_21m, wd_21m, ustar_21m, z_L_21m, precip_mm, Td_21m, vpd, wet_b, T_soil, T_bole_pi, T_bole_fi, T_bole_sp, Rppfd_in_, Rppfd_out, Rnet_25m_, Rsw_in_25, Rsw_out_2, Rlw_in_25, Rlw_out_2, T_2m, T_8m, RH_2m, RH_8m, h2o_soil, co2_21m] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

% Make a matrix then dataset from data
climate_data = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
header = {'Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
clim_dataset1 = dataset({climate_data,header{:}});

% Make a new data column based on year that is ordinal (for concatenated all years file)
y = min(Year(:));
Y = max(Year(:));
labels2 = num2str((y:Y)');
edges = y:Y+1;
clim_dataset1.YearOrd = ordinal(clim_dataset1.Year,labels2,[],edges);

% Make a new data column based on DD that is ordinal and without decimal for use with
% statistics command.  Based on code here: http://www.mathworks.com/help/stats/ordinal.html
m = floor(min(DecimalDate(:)));
M = floor(max(DecimalDate(:)));
labels = num2str((m:M)');
edges = m:M+1;
clim_dataset1.Day = ordinal(clim_dataset1.DecimalDate,labels,[],edges);

% Calculate variable means and precip sum for each doy by combination of year, and day of year
% Based on code here: http://www.mathworks.com/help/stats/grpstats.html#bthgrw_
% Not plotting other variables right now: MeanEnvds = grpstats(clim_dataset1,{'YearOrd','Day'},'mean','DataVars',{'MO','T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', 'Rlw_out_2','T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'});
Env_stats_DS = grpstats(clim_dataset1,{'YearOrd','Day'},{'sum','mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},'DataVars',{'precip_mm','T_21m','Rppfd_in_'});
Env_stats=double(Env_stats_DS);
YearN = Env_stats(:,1:1) + 1997;
Env_stats(:,1:1) = YearN;

% Calculate mean precipitation by DOY across all years
doy_Env_stats_DS = grpstats(Env_stats_DS,{'Day'},{'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},'DataVars',{'sum_precip_mm','sum_Rppfd_in_'});
doy_Env_Stats = double(doy_Env_stats_DS);

% % QC check: sum of precip for each year should be 600-1000 mm range
% year_Sum_precipDS = grpstats(Env_stats_DS,{'YearOrd'},{'sum','std'},'DataVars',{'sum_precip_mm'});

% Calculate mean air temperature at 8 m across all years
doy_mean_TDS = grpstats(Env_stats_DS,{'Day'},{'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},'DataVars',{'mean_T_21m'});
doy_mean_T = double(doy_mean_TDS);

% Load snotel data
% addpath('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
addpath('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts')
run load_snotel
% cd('/Users/lpapgm/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts') % change back to directory for this script
cd('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts') % change back to directory for this script

% Add DOY to SWE data
SWE_vc = datevec(SWE_date);
SWE_DV  = SWE_vc(:, 1:3);   % [N x 3] array, no extra time columns
SWE_DV2 = SWE_DV;
SWE_DV2(:, 2:3) = 0;        % [N x 3], day before 01.Jan
SWE_y_DOY = cat(2, SWE_DV(:, 1), datenum(SWE_DV) - datenum(SWE_DV2));
SWE_DOY = datenum(SWE_DV) - datenum(SWE_DV2);
SWE_DS2 = [dataset(SWE_DOY) SWE_DS];

% Calculate mean SWE across all years
% Note that the difference between the 25 percentile and 75 percentile is
% the interquartile range: the range that contains 50% of observations.
% 'iqr' gives the 3rd quartile (or 75 percentile) minus the first quartile (or 25 percentile).
SWE_stats_DS = grpstats(SWE_DS2,{'SWE_DOY'},{'mean','median','numel','std',@(x)prctile(x,25),@(x)prctile(x,75)},'DataVars',{'SWE'});
SWE_stats = double(SWE_stats_DS);


%% Section 3: Plot daily NEP for each year
% Make plot of NEP by DOY for each year (graph is rather noisy)

% removed in this version of the script

%% Section 4: Plot MEAN daily environment variables for all years with interquartile range (as a subplot panel)

h_subplot = figure('color','white','PaperOrientation','portrait');
h_s1 = subplot(6,1,1);        

% Useful to check default axis font
%get(h_subplot,'defaultAxesFontName')

hold on;

% First variable: SWE
% Plot interquartile range of daily SWE
SWE_up_line = plot(SWE_stats(:,1),SWE_stats(:,8),'-'); %upper line: 75 percentile
SWE_low_line = plot(SWE_stats(:,1),SWE_stats(:,7),'-'); %lower line: 25 percentile

% Add shaded area between SWE 25 and 75 percentiles
shadearea=[SWE_stats(:,7), (SWE_stats(:,8)-SWE_stats(:,7))];
SWEHarea=area(SWE_stats(:,1),shadearea);

% % Second variable: precipitation
% %OPTION 1: Plot interquartile range of daily precip
% precip_up_line = plot(doy_Env_Stats(:,1),doy_Env_Stats(:,8),'-'); %upper line: 75 percentile
% precip_low_line = plot(doy_Env_Stats(:,1),doy_Env_Stats(:,7),'-'); %lower line: 25 percentile
% OPTION 2: Plot interquartile range of daily precip zoomed in
precip_zoom = 10; % factor to zoom in
upper_precip_z = doy_Env_Stats(:,8)*precip_zoom;
lower_precip_z = doy_Env_Stats(:,7)*precip_zoom;
precip_up_line = plot(doy_Env_Stats(:,1),upper_precip_z,'-'); %upper line: 75 percentile
precip_low_line = plot(doy_Env_Stats(:,1),lower_precip_z,'-'); %lower line: 25 percentile

% Add shaded area between Precip 25 and 75 percentiles
% %OPTION 1: unscaled precip
% shadearea=[doy_Env_Stats(:,7), (doy_Env_Stats(:,8)-doy_Env_Stats(:,7))];
% precipHarea=area(doy_Env_Stats(:,1),shadearea);
% OPTION 2: precip zoomed in by factor defined in 'precip zoom'
shadearea=[lower_precip_z, (upper_precip_z-lower_precip_z)];
precipHarea=area(doy_Env_Stats(:,1),shadearea);

% Add daily mean precip
% OPTION 1: unscaled precip
% hprecip =plot(doy_Env_Stats(:,1),doy_Env_Stats(:,3)); %precip mean
% set(hprecip,'Color',[0.3,0.3,0.3],... %precip color
%     'LineWidth',2,...
%     'LineStyle','-');
% OPTION 2: precip zoomed in by factor defined in 'precip zoom'
precip_mean_z = doy_Env_Stats(:,3)*precip_zoom;
hprecip =plot(doy_Env_Stats(:,1),precip_mean_z); %precip mean
set(hprecip,'Color',precip_color,... %precip color
    'LineWidth',2,...
    'LineStyle','-');

% Add daily SWE
hSWE = plot(SWE_stats(:,1),SWE_stats(:,3),'Color',swe_col,...  % plot swe
    'LineWidth',2,...
    'LineStyle','-');

hold off

% Adjust axes properties
%set(haxes,{'ycolor'},{'k';'k'})  % Left color , right color ...
%y1_Nticks = 5;
%y1 = linspace(0, ceil(max(SWE_stats(:,8))), y1_Nticks);
y1 = [0 ceil(max(SWE_stats(:,8)))];
set(gca,'xlim',[0 366],...      % set x limits
    'ylim',[y1(1) y1(end)],...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.012 .012] , ...
    'xticklabel'  , {}, ...
    'Box','off');               % get rid of top border.  See also 'linkaxes'
set(gca, 'FontSize', SmallFont) % Set axes font size

% Set line properties for Precip IQR/standard dev    
set(precip_up_line                  , ...   % Upper SD line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(precip_low_line                  , ...   % Lower SD line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
set(precipHarea(1),'FaceColor','none');           % Area below lower SD/iqr? Note: lower iqr for precip is zero most days
set(precipHarea(2),'FaceColor',iqr_col);    % Area between upper and lower SD/iqr
set(precipHarea,'LineStyle', 'none')              % Line around shape


% Set line properties for SWE IQR/standard dev        
set(SWE_up_line                  , ...   % Upper SD line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(SWE_low_line                  , ...   % Lower SD line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
%set(SWEHarea(1),'FaceColor','none');           % Area below lower SD?
set(SWEHarea(1),'FaceColor','none'); 
set(SWEHarea(2),'FaceColor',iqr_col);    % Area between upper and lower SD
set(SWEHarea,'LineStyle', 'none')              % Line around shape

% Add legend
leg_names={['Precipitation *' num2str(precip_zoom)],'SWE'};
LEG = legend([hprecip;hSWE],...
    leg_names,...
    'Location','Best',...
    'FontSize',SmallFont);
set(LEG, 'Box', 'off');

% Make x and y labels
ylabel({'Precipitation & snow';' (mm)'},'Fontsize',SmallFont) % label left y-axis
%ylabel('Daily precipitation & snow water (mm)','Fontsize',SmallFont) % label left y-axis
%xlabel('Day of year','Fontsize',BigFont) %Only want on bottom graph

% Add subplot label (a,b,c, etc)
%text(10, y1(2)*.95,'a)','FontSize',MediumFont,'HorizontalAlignment','right');
text(12, y1(2)*.9,'a)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section 5: Boxplots for start/end dates for periods (as a subplot panel)

W_SM = StartStopAdjusted(:,3);
SM_PM = StartStopAdjusted(:,5);
PMM = StartStopAdjusted(:,7);
MPM = StartStopAdjusted(:,9);
PMW = StartStopAdjusted(:,11);
period = [repmat({'WSM'}, 16, 1); repmat({'SMPM'}, 16, 1); repmat({'PMM'}, 16, 1); repmat({'MPM'}, 16, 1); repmat({'PMW'}, 16, 1)];

% Boxplots
h_s2 = subplot(6,1,2);
HB = boxplot([W_SM;SM_PM;PMM;MPM;PMW;], period, 'orientation', 'horizontal',...
        'boxstyle', 'filled', 'positions',[0.5 1.25 1.5 1.75 2]);
%     'boxstyle', 'filled', 'positions',[0.5 1 1.5 2 2.5]);
% Note, 'whisker' determines max whisker length beyond which points are ourliers.  
% To have no whiskers (values outside of 25% and 75% percentiles) set 'whisker',0,

% Make boxplots pretty
% columns relate to boxplots, rows relate to handles; 'box' is the 5th row
set(HB(1,:),'color','k','linewidth',1.5)
set(HB(2,:),'color',iqr_col,'linewidth',4.5) % this line-width should change for oecologia re-submission 
set(HB(3,:),'color','k')
set(HB(4,:),'color','r','linewidth',2)
% get(HB(:,3),'tag') % see handles of boxplot (whisker, box, etc)
yLimits = [0, 10];
xLimits = [0, 366];
set(gca, ...
    'Xlim'          , xLimits   , ...
    'Ylim'          , yLimits   , ...
    'Box'           , 'off'     , ...
    'TickDir'       , 'out'     , ...
    'TickLength'    , [.015 .015] , ...
    'YTickLabel'    ,{' '}      , ...   %remove y labels (for periods)
    'XTickLabel'    ,{' '}      , ...   %remove y labels (for periods)
    'ytick'         ,[]         , ...   %remove y ticks
    'LineWidth'     , 1         , ...
    'FontSize'      , SmallFont);
%    'xticklabel'    , {}        , ...   % remove x tick label


% Add demarcations at boxplot medians
f = findobj(gcf,'tag','Median');
xMedian = get(f,'XData');
yMedian = get(f,'YData');
l1=line([xMedian{1}],[yLimits(1) yLimits(2)],'LineStyle',':','Color','k','LineWidth',1.5);
l2=line([xMedian{2}],[yLimits(1) yLimits(2)],'LineStyle',':','Color','k','LineWidth',1.5);
l3=line([xMedian{3}],[yLimits(1) yLimits(2)],'LineStyle',':','Color','k','LineWidth',1.5);
l4=line([xMedian{4}],[yLimits(1) yLimits(2)],'LineStyle',':','Color','k','LineWidth',1.5);
l5=line([xMedian{5}],[yLimits(1) yLimits(2)],'LineStyle',':','Color','k','LineWidth',1.5);

% Calculate placement for period text labels along x axis
p1=xMedian{5}(1)+(xMedian{4}(1)-xMedian{5}(1))/2;
p2=xMedian{4}(1)+(xMedian{3}(1)-xMedian{4}(1))/2;
p3=xMedian{3}(1)+(xMedian{2}(1)-xMedian{3}(1))/2;
p4=xMedian{2}(1)+(xMedian{1}(1)-xMedian{2}(1))/2;
p5=xMedian{1}(1)+(xLimits(2)-xMedian{1}(1))/2;
p6=xLimits(1)+(xMedian{5}(1)-xLimits(1))/2;

% place period text
text(p1,yLimits(2)*.95,'snow melt','FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90);
text(p2,yLimits(2)*.95,' pre-monsoon','FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90);
text(p3,yLimits(2)*.95,'monsoon','FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90);
text(p4,yLimits(2)*.95,{'post-monsoon';''},'FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90); %empty second line prevents overlap with boxplot
text(p5,yLimits(2)*.95,'winter','FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90);
text(p6,yLimits(2)*.95,'winter','FontSize',SmallFont,'HorizontalAlignment','right','Rotation',90);
hold off

% Add subplot label (a,b,c, etc)
text(12, yLimits(2)*.9,'b)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section 6: Plot MEAN sum daily NEP for all years with interquartile range (as a subplot panel)
% % COMMENTED OUT FOR REVISED VERSION since showing daytime/nighttime separately.
% % Note, the problem with plotting stand. dev. is that standard dev. includes
% % negative values even though the data (like sum precip) does not go
% % negative.
% 
% % h_subplot = figure('color','white','PaperOrientation','portrait'); %moved to sec 4
% subplot(6,1,3);     
% hold on;
% 
% % % Plot standard deviation of daily NEP sums (or use interquartile range below)
% % upSD = ave_Sum_NEP(:,3)+ave_Sum_NEP(:,6); %mean plus standard deviation
% % lowSD = ave_Sum_NEP(:,3)-ave_Sum_NEP(:,6); %mean minus standard deviation
% % up_line = plot(ave_Sum_NEP(:,1),(upSD),'-'); %upper SD line
% % low_line = plot(ave_Sum_NEP(:,1),(lowSD),'-'); %lower SD line
% 
% % % Add shaded area between standard deviations (or use interquartile range below)
% % shadearea=[lowSD, (upSD-lowSD)];
% % Harea=area(ave_Sum_NEP(:,1),shadearea);
% 
% % Plot interquartile range of daily NEP sums
% up_line = plot(doy_Sum_NEP(:,1),doy_Sum_NEP(:,8),'-'); % 75 percentile
% low_line = plot(doy_Sum_NEP(:,1),doy_Sum_NEP(:,7),'-'); % 25 percentile
% 
% % Add shaded area between 25 and 75 percentiles
% shadearea=[doy_Sum_NEP(:,7), (doy_Sum_NEP(:,8)-doy_Sum_NEP(:,7))];
% Harea=area(doy_Sum_NEP(:,1),shadearea);
% 
% % Add daily average NEP sum
% ha=plot(doy_Sum_NEP(:,1),doy_Sum_NEP(:,3));
% 
% % % (Optional) plot all NEP daily values
% % plot(Sum_NEP(:,2),Sum_NEP(:,7),'k.')
% 
% hold off
% 
% % Set line properties
% set(ha,'Color',[0.3,0.3,0.3],... % line properties for all years/handles
%                 'LineWidth',2,...
%                 'LineStyle','-');         
% set(up_line                  , ...   % Upper SD/iqr line (probably want to match area color betw. upper & lower SD)
%     'LineWidth'     , 2             , ...
%     'Color'         , [.87 .87 .87]  );
% set(low_line                  , ...   % Lower SD/iqr line (probably want to match area color betw. upper & lower SD)
%     'LineWidth'     , 2             , ...
%     'Color'         , [.87 .87 .87]  );           
% set(Harea(1),'FaceColor','none');           % Area below lower SD?
% set(Harea(2),'FaceColor',[.87 .87 .87]);    % Area between upper and lower SD
% set(Harea,'LineStyle', 'none')              % Line around shape
% 
% % Adjust axes properties
% NEP_ylim1 = round(min(doy_Sum_NEP(:,7))-2);
% NEP_ylim2 = round(max(doy_Sum_NEP(:,8))+2);
% set(gca, ...
%     'Xlim'      , [0, 366]    , ...
%     'Ylim'      , [NEP_ylim1, NEP_ylim2]    , ...
%     'Box'         , 'off'     , ...
%     'TickDir'     , 'out'     , ...
%     'TickLength'  , [.02 .02] , ...
%     'LineWidth'   , 1         , ...
%     'FontSize',SmallFont);
% 
% % Add x label for bottom graph
% xlabel('Day of year','Fontsize', SmallFont)
% % ylabel('Net ecosystem productivity', 'Fontsize', SmallFont)
% ylabel('NEP (\mumol m^{-2} s^{-1})', 'Fontsize', SmallFont) % With Sean's suggestion to include units
% 
% 
% % Add subplot label (a,b,c, etc)
% text(10, NEP_ylim2*.95,'c.','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section 7: Plot mean DAYTIME NEP for all years with interquartile range (as a subplot panel)

h_s3 = subplot(6,1,3);
hold on

% Plot interquartile range of day NEP
up_line = plot(doy_DayFlux(:,1),doy_DayFlux(:,8),'-'); % 75 percentile
low_line = plot(doy_DayFlux(:,1),doy_DayFlux(:,7),'-'); % 25 percentile

% Add shaded area between 25 and 75 percentiles
shadearea=[doy_DayFlux(:,7), (doy_DayFlux(:,8)-doy_DayFlux(:,7))];
Harea=area(doy_DayFlux(:,1),shadearea);

% Add day average NEP
ha=plot(doy_DayFlux(:,1),doy_DayFlux(:,3));

% Define y axis limits and add lines showing periods
ylim1 = round(min(doy_NightFlux(:,7))-.1);  %To be the same as nighttime min
%ylim1 = round(min(doy_DayFlux(:,7))-.1); %To fit NEPdaytime well
ylim2 = round(max(doy_DayFlux(:,8))+.1);
l1=line([xMedian{1}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l2=line([xMedian{2}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l3=line([xMedian{3}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l4=line([xMedian{4}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l5=line([xMedian{5}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);

hold off

% Set line properties
set(ha,'Color',nep_col,... % line properties for all years/handles
                'LineWidth',2,...
                'LineStyle','-');         
set(up_line                  , ...   % Upper SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(low_line                  , ...   % Lower SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
set(Harea(1),'FaceColor','none');           % Area below lower SD?
set(Harea(2),'FaceColor',iqr_col);    % Area between upper and lower SD
set(Harea,'LineStyle', 'none')              % Line around shape

% Adjust axes properties
set(gca, ...
    'Xlim'      , [0, 366]    , ...
    'Ylim'      , [ylim1, ylim2]    , ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.012 .012] , ...
    'xticklabel'  , {}        , ...
    'LineWidth'   , 1         , ...
    'FontSize',SmallFont);

% ylabel('Net ecosystem productivity', 'Fontsize', SmallFont)
ylabel({'NEP_{daytime}'; '(\mumol m^{-2} s^{-1})'}, 'Fontsize', SmallFont) % With Sean's suggestion to include units


% Add subplot label (a,b,c, etc)
text(12, ylim2*.9,'c)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section 8: Plot mean NIGHTTIME NEP for all years with interquartile range (as a subplot panel)

h_s4 = subplot(6,1,4);
hold on

% Plot interquartile range of night NEP sums
up_line = plot(doy_NightFlux(:,1),doy_NightFlux(:,8),'-'); % 75 percentile
low_line = plot(doy_NightFlux(:,1),doy_NightFlux(:,7),'-'); % 25 percentile

% Add shaded area between 25 and 75 percentiles
shadearea=[doy_NightFlux(:,7), (doy_NightFlux(:,8)-doy_NightFlux(:,7))];
Harea=area(doy_NightFlux(:,1),shadearea);

% Add mean night NEP
ha=plot(doy_NightFlux(:,1),doy_NightFlux(:,3));

% Define y axis limits and add lines showing periods
ylim1 = round(min(doy_NightFlux(:,7))-.1);
ylim2 = round(max(doy_DayFlux(:,8))+.1); % To be the same as NEPdaytime
%ylim2 = round(max(doy_NightFlux(:,8))+.1);
l1=line([xMedian{1}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l2=line([xMedian{2}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l3=line([xMedian{3}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l4=line([xMedian{4}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l5=line([xMedian{5}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);

hold off

% Set line properties
set(ha,'Color',nep_col,... % line properties for all years/handles
                'LineWidth',2,...
                'LineStyle','-');         
set(up_line                  , ...   % Upper SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(low_line                  , ...   % Lower SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
set(Harea(1),'FaceColor','none');           % Area below lower SD?
set(Harea(2),'FaceColor',iqr_col);    % Area between upper and lower SD
set(Harea,'LineStyle', 'none')              % Line around shape

% Adjust axes properties
set(gca, ...
    'Xlim'      , [0, 366]    , ...
    'Ylim'      , [ylim1, ylim2]    , ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.012 .012] , ...
    'xticklabel'  , {}        , ...
    'LineWidth'   , 1         , ...
    'FontSize',SmallFont);

% ylabel('Net ecosystem productivity', 'Fontsize', SmallFont)
ylabel({'NEP_{nighttime}';'(\mumol m^{-2} s^{-1})'}, 'Fontsize', SmallFont) % With Sean's suggestion to include units


% Add subplot label (a,b,c, etc)
text(12, ylim2*.9,'d)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section : Plot mean DAYTIME ET for all years with interquartile range (as a subplot panel)

h_s5 = subplot(6,1,5);
hold on

% Plot interquartile range of night NEP sums
up_line = plot(doy_DayFlux(:,1),doy_DayFlux(:,14),'-'); % 75 percentile
low_line = plot(doy_DayFlux(:,1),doy_DayFlux(:,13),'-'); % 25 percentile

% Add shaded area between 25 and 75 percentiles
shadearea=[doy_DayFlux(:,13), (doy_DayFlux(:,14)-doy_DayFlux(:,13))];
Harea=area(doy_DayFlux(:,1),shadearea);

% Add mean night NEP
ha=plot(doy_DayFlux(:,1),doy_DayFlux(:,9));

% Define y axis limits and add lines showing periods
% ylim1 = round(min(doy_DayFlux(:,13))-.05); 
% ylim2 = round(max(doy_DayFlux(:,14))+.05);
ylim1 = -0.1;
ylim2 = round(max(doy_DayFlux(:,14)));
l1=line([xMedian{1}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l2=line([xMedian{2}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l3=line([xMedian{3}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l4=line([xMedian{4}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l5=line([xMedian{5}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);

hold off

% Set line properties
set(ha,'Color',ET_col,... % line properties for all years/handles
                'LineWidth',2,...
                'LineStyle','-');         
set(up_line                  , ...   % Upper SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(low_line                  , ...   % Lower SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
set(Harea(1),'FaceColor','none');           % Area below lower SD?
set(Harea(2),'FaceColor',iqr_col);    % Area between upper and lower SD
set(Harea,'LineStyle', 'none')              % Line around shape

% Adjust axes properties
set(gca, ...
    'Xlim'      , [0, 366]    , ...
    'Ylim'      , [ylim1, ylim2]    , ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.012 .012] , ...
    'xticklabel'  , {}        , ...
    'LineWidth'   , 1         , ...
    'FontSize',SmallFont);

% ylabel('Net ecosystem productivity', 'Fontsize', SmallFont)
ylabel({'ET_{daytime}';'(mmol m^{-2} s^{-1})'}, 'Fontsize', SmallFont)

% Add subplot label (a,b,c, etc)
text(12, ylim2*.9,'e)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Plot mean NIGHTTIME ET for all years with interquartile range (as a subplot panel)

h_s6 = subplot(6,1,6);
hold on

% Plot interquartile range of night NEP sums
up_line = plot(doy_NightFlux(:,1),doy_NightFlux(:,14),'-'); % 75 percentile
low_line = plot(doy_NightFlux(:,1),doy_NightFlux(:,13),'-'); % 25 percentile

% Add shaded area between 25 and 75 percentiles
shadearea=[doy_NightFlux(:,13), (doy_NightFlux(:,14)-doy_NightFlux(:,13))];
Harea=area(doy_NightFlux(:,1),shadearea);

% Add mean night NEP
ha=plot(doy_NightFlux(:,1),doy_NightFlux(:,9));

% Define y axis limits and add lines showing periods
% ylim1 = round(min(doy_NightFlux(:,13))-.05);
% ylim2 = round(max(doy_NightFlux(:,14))+.05);
ylim1 = -0.1;
ylim2 = round(max(doy_DayFlux(:,14)));
l1=line([xMedian{1}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l2=line([xMedian{2}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l3=line([xMedian{3}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l4=line([xMedian{4}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);
l5=line([xMedian{5}],[ylim1 ylim2],'LineStyle',':','Color','k','LineWidth',1.5);

hold off

% Set line properties
set(ha,'Color',ET_col,... % line properties for all years/handles
                'LineWidth',2,...
                'LineStyle','-');         
set(up_line                  , ...   % Upper SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );
set(low_line                  , ...   % Lower SD/iqr line (probably want to match area color betw. upper & lower SD)
    'LineWidth'     , 2             , ...
    'Color'         , iqr_col  );           
set(Harea(1),'FaceColor','none');           % Area below lower SD?
set(Harea(2),'FaceColor',iqr_col);    % Area between upper and lower SD
set(Harea,'LineStyle', 'none')              % Line around shape

% Adjust axes properties
set(gca, ...
    'Xlim'      , [0, 366]    , ...
    'Ylim'      , [ylim1, ylim2]    , ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.012 .012] , ...
    'LineWidth'   , 1         , ...
    'FontSize',SmallFont);
%    'xticklabel'  , {}        , ... %Removed this to allow x-tick labels on bottom panel

% Add x label for bottom graph
xlabel('Day of year','Fontsize', SmallFont)
% ylabel('Net ecosystem productivity', 'Fontsize', SmallFont)
ylabel({'ET_{nighttime}';'(mmol m^{-2} s^{-1})'}, 'Fontsize', SmallFont)

% Add subplot label (a,b,c, etc)
text(12, ylim2*.9,'f)','FontSize',MediumFont,'HorizontalAlignment','right');

%% Section : Find edges for use with histc, and period lengths for all years

% First calculate sum of NEP for each season for each year

% Use histc to bin data
% Edges for beginning of year to SM, and start of winter to end of year
% vary for leap/nonleap years
nonleap_y = [1998,1999,2001,2002,2003,2005,2006,2007,2009,2010,2011,2013];
leap_y = [2000,2004,2008,2012];
nonleapSS = StartStopAdjusted([1,2,4,5,6,8,9,10,12,13,14,16],[1,3,5,7,9,11]);
leapSS = StartStopAdjusted([3,7,11,15],[1,3,5,7,9,11]);
non_leap_Edges = [nonleapSS(:,1), ones(size(nonleapSS,1),1) nonleapSS(:,2:end), repmat(365,size(nonleapSS,1),1)];
leap_Edges = [leapSS(:,1), ones(size(leapSS,1),1) leapSS(:,2:end), repmat(366,size(leapSS,1),1)];

% Combine leap and non-leap edges, then sort by year
all_edges = sortrows([non_leap_Edges; leap_Edges],1);
% remove year column since it isn't an 'edge'
all_Edges = all_edges(:,2:end);

% Calculate length of each period for each year
period_lengths = diff(all_Edges,1,2); % order of periods is: winter1, snowmelt, premonsoon, monsoon, post-monsoon, winter2 
period_lengths(:,6) = period_lengths(:,6)+1; %Add one to last column so last day is included
% A test that all periods add up for each year: sum(period_lengths,2)


%% Section : Plot NEP binned by period (histogram instead of continuous as in sect 4)
% This relies on edges defined in last section.

yrs=unique(Sum_NEP(:,1));
sum_period = [];
sum_period1 = [];

for j = 1:length(yrs)
    sub_temp=[];
    sum_period1=[];
    if yrs(j)>1998
            ind = find(Sum_NEP(:,1)==yrs(j));
            sub_temp = Sum_NEP(ind,:);
            % Bin year j by period
            [N,edges,bin] = histcounts(sub_temp, all_Edges(j,:));
            % calculate sum of NEP in each period for year j
            sum_period1 = accumarray(bin(:,2),sub_temp(:,7));
            % add to matrix for all years
            sum_period = [sum_period sum_period1];
    end
end

% Add year and transpose period sums in preparation for plot
sum_period_yrs = [(1999:2013); sum_period]';

% Make new figure (could add to subplot also)
figure()

% Bar plot of NEP for each period from 1999 on
% Note that winter shows up twice for each year... pre-snowmelt and after
% post-monsoon
NEP_bar = bar(sum_period_yrs(:,1),sum_period_yrs(:,2:end),'group','BarWidth',0.9);


% Label axes
%fsize=22;
xlabel('Year','FontSize',MediumFont,'FontWeight','bold','Color','k')
ylabel('NEP for each period','FontSize',SmallFont,'FontWeight','bold','Color','k')

% Set axis properties
axesP_SWE = gca;
axesP_SWE.FontSize=16;
axesP_SWE.XTickLabelRotation=45;

% Set face color
% P_SWE_bar(1).EdgeColor = 'k';
% P_SWE_bar(1).FaceColor = [0.85,0.85,0.85];
% P_SWE_bar(2).EdgeColor = 'k';
% P_SWE_bar(2).FaceColor = [0.45,0.45,0.45];

% remove box around plot
box off

% add legend
P_SWE_leg=legend('Winter','Snow melt','Pre-monsoon','Monsoon','Post-monsoon','Winter','Location','North');


%% Section : export figures

% Tinker with positioning of subplots
% Define the current positions
pos1 = get( h_s1, 'Position' );
pos2 = get( h_s2, 'Position' );
pos3 = get( h_s3, 'Position' );
pos4 = get( h_s4, 'Position' );
pos5 = get( h_s5, 'Position' );
pos6 = get( h_s6, 'Position' );

% Define y coordinate of each subplot before running tightfig. Linspace
% calculates evenly space numbers for 'y' of 'Position'
origY = linspace(pos1(2),pos6(2),6); % current evenly spaced lower corner 'y' positions
newY = linspace(pos1(2),(pos6(2)+.15),6); % add value to bottom plot corner and calculate even spacing
%newY = origY; % keeps the original. otherwise tinker with subtracting space
pos6(2) = newY(6);
pos5(2) = newY(5);
pos4(2) = newY(4);
pos3(2) = newY(3);
pos2(2) = newY(2);
pos1(2) = newY(1);
set( h_s6, 'Position', pos6);
set( h_s5, 'Position', pos5);
set( h_s4, 'Position', pos4);
set( h_s3, 'Position', pos3);
set( h_s2, 'Position', pos2);
set( h_s1, 'Position', pos1);

% Make second subplot same height as the rest
% in 'position' the first two values are x and y of lower left corner
% [x y width height]
pos2(4) = pos1(4);
set( h_s2, 'Position', pos2 ) ;

% Make subplot tighter
addpath('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/tightfig')
tight_h_subplot = tightfig(h_subplot);

% Edit figure size of overall subplot plot
set(tight_h_subplot,'units','centimeters')
get(tight_h_subplot,'position')
width = 8.4*2;      % one column in Oecologia is 84 mm
height = 23.4;      % max height Oecologia permits is 234 mm
set(tight_h_subplot,'units','centimeters','position',[1 1 width height])

% %Change outer position to give a little more room on the left-hand side
% %https://www.mathworks.com/help/matlab/creating_plots/automatic-axes-resize.html
% test = get(tight_h_subplot, 'OuterPosition');
% test(1) = test(1) + .5;
% test(2) = test(2) - .5;
% set(tight_h_subplot, 'OuterPosition', test);

% Get the new positions of subplots after tightfig was run
pos1 = get( h_s1, 'Position' );
pos2 = get( h_s2, 'Position' );
pos3 = get( h_s3, 'Position' );
pos4 = get( h_s4, 'Position' );
pos5 = get( h_s5, 'Position' );
pos6 = get( h_s6, 'Position' );

% move each subplot a little to the right to allow more space on left-hand side
x_margin = .003; %Define margin to be added to the left of each plot
pos6(1) = pos6(1)+x_margin;
pos5(1) = pos5(1)+x_margin;
pos4(1) = pos4(1)+x_margin;
pos3(1) = pos3(1)+x_margin;
pos2(1) = pos2(1)+x_margin;
pos1(1) = pos1(1)+x_margin;

% Set each subplot with new x axis
set( h_s6, 'Position', pos6);
set( h_s5, 'Position', pos5);
set( h_s4, 'Position', pos4);
set( h_s3, 'Position', pos3);
set( h_s2, 'Position', pos2);
set( h_s1, 'Position', pos1);


% Export subplot
out_dir='/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/graphing scripts/more graphs';
cd(out_dir);

% print(h_subplot, '-deps2', 'period_graph'); %This isn't as pretty for some reason
%savefig(h_subplot, 'period_graph') % not tight version (might not work without commenting out call to tightfig)
savefig(tight_h_subplot, 'period_graph') % tight version

% Note: I manually saved as an .eps and .svg based on the .fig file saved.
% For some reason preview has trouble with the .eps this way, but if .svg
% version is opened with inkscape and saved, it can then open....