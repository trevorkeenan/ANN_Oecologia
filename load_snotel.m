% Load snotel
% Loren Albert, spring 2014
% This script loads snotel daily soil-water-equivalent data into Matlab, 
% and subsets data to match Ameriflux flux/climate timespan.  
% Units of SWE are originally inches.  This script converts them into mm.
% Make sure directory for snotel data is correct.

%close all
%clear all

% Set directory for snotel data
% cd('/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/Snotel data')
cd('/Users/lalbert/Dropbox/Niwot Ridge project/NR data/Snotel data')

% sno = xlsread('snotel_swe_niwot') %Using other format of data

% Can't get textscan to work
% fid=fopen('Snotel_swe_by_day.txt');
% C=textscan(fid,'%s,%f','delimiter',',',headerLines',7);
% 
% fclose(fid);
% column1 = C{1}{1}, column2 = C{2}

% So using textread
file='Snotel_swe_by_day.txt';
[sno_date, sno]=textread(file,'%s%f','delimiter',',','commentstyle','matlab');

% Subset snotel (might be more elegant way to do this with
% 'datenum').  Row 6606 of sno_data is Nov 1, 1998, and Day 305 of 1998 is
% Nov 1st.  Row 12145 is Dec 31, 2013
SWE=sno(6606:12145);
SWE_date=sno_date(6606:12145);

% Multiply by 25.4 to convert from inches to mm.
SWE=SWE*25.4;

% Index swe for previous month
SWE_prev30=sno(6576:12115);
SWE_prev30=SWE_prev30*25.4;

SWE_DS=dataset(SWE);
SWE_prev30DS=dataset(SWE_prev30);

clear sno_date sno


