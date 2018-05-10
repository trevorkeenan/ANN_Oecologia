% This script loads the non-gap-filled flux data output of the output of daylen_OKdata.m.
% I made it as a clean way of importing NEE so I can add previous half-day
% NEE as a driver for half-day nights in the script 'prep_data_for_ANN.m'

% Load data
%filepath = char('../../../NR data/Data output from matlab/'); %Uncomment
%if running this independently (directory where files live)
filename = strcat('flux_allyears_OKflags_daylen_thresh',num2str(threshold),'.txt'); %Input file: output from daylen_OKdata.m
filetoopen = strcat(filepath,filename); %concatenate file path with file name
[neeYear, neeDay, neequantum, GroupCount, MO, Fco2_21m_nee_stat_int_Ustar, Fco2_21m_nee_stat_int, Strg_co2, tu_w_21m, Taua_21m, Qh_21m, Qe_21m, w_h2o_21m, Qh_soil, Strg_Qh, Strg_Qe, Strg_bole, Strg_needle, q] = ...
    textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');

% Clear stuff I don't need
clear neeYear MO neeDay GroupCount  Fco2_21m_nee_stat_int Strg_co2 tu_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle q

% Make dataset
neeData = [Fco2_21m_nee_stat_int_Ustar];
header = {'Fco2_21m_nee_stat_int_Ustar'};
neeDataset = dataset({neeData,header{:}});

% Make filler to replace first row
% (Offsetting by moving down moves each row to the 'past')
filler=dataset(NaN, 'VarNames',{'Fco2_21m_nee_stat_int_Ustar'});

%Make column for previous half-day day or night NEE
NEE_prev_HDay=[filler; neeDataset(1:end-1,:)];

% Make day and night prev NEE datasets
%note: in daylen_OKdata.m 'night' and 'day' labels in dataset are converted 
% into 1 for night and 2 for day when dataset converted back to array
NEE_prev_HN_Day = NEE_prev_HDay(neequantum ==2,:);
NEE_prev_HD_Night = NEE_prev_HDay(neequantum ==1,:);

clear filler header neeData neequantum %NEE_prev_HDay