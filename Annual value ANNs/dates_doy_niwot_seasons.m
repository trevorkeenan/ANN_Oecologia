% Loren Albert spring 2014
%
% This script shows day of year for days in matrix
% 'DayStartMat.' It is for use with DayStartMat when it is in the workspace
% (so after running loadObsAndDrivers).  This is helpful to figure out
% dates that define the different seasons.

% Need in workspace: subDataYears with all years (1998-end
% of dataset), and DayStartMat.


start_doy=subDataYears(DayStartMat(:,2),3);
stop_doy=subDataYears(DayStartMat(:,3),3);
% start_doy=subDataYears(DayStartMat(:,2)-61,3);     %This is a work-around if subDataYears starts with 1999
% stop_doy=subDataYears(DayStartMat(:,3)-61,3);      %This is a work-around if subDataYears starts with 1999


% Inputs:
doyV=start_doy;
doyV2=stop_doy;
yearV=DayStartMat(:,1);


% run matlab script that converts doy to matlab date
% http://www.mathworks.com/matlabcentral/fileexchange/24235-day-of-year-to-matlab-date
addpath('/Users/lalbert/Dropbox/Niwot Ridge project/Matlab scripts/MatlabScripts/LPA-edited scripts/doy2date')
[start_MLdates]=doy2date(doyV,yearV);
[stop_MLdates]=doy2date(doyV2,yearV);


% Convert matlab dates to strings
start_dates=datestr(start_MLdates);
stop_dates=datestr(stop_MLdates);

% Make table to show dates
start_stop_date_table=char(strcat(start_dates,{''},stop_dates));
% % Make table to show dates (other way to do it... neither has spaces betw. dates)
% start_stop_date_table=[yearV, start_dates, stop_dates];
