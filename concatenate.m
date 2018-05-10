%%Import data and concatenate files
%%Note that climate files and climate flag files have different
%%numbers of columns, and NEE flag and data files have different numbers
%%columns.  I emailed back and forth with Sean to determine how to match flags and data.
%%Original files are here: http://urquell.colorado.edu/data_ameriflux/data_30min/
%%Updated script for data version2015.11.10 in Jan 2017.
%%Note: The 'dlmwrite' function used here automatically caps the digits exported at 5 (default).
%%This limits the decimal places for 'decimal day' when exported but other variables have
%%less than 5, so I left the default option. See http://stackoverflow.com/questions/31661418/how-to-keep-the-precision-as-the-same-of-the-original-data-when-using-csvread-dl
%%or https://www.mathworks.com/matlabcentral/answers/100620-how-can-i-avoid-truncation-and-loss-of-precision-when-saving-my-data-in-matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%To do:
% 1) Change file path if necessary
% 2) Choose file type
% 3) Select years to concatenate (fileyear)
% 4) Names of headers in output file are hard-coded, so change these if format
% of input files changes.  Ameriflux data version is also hard-coded as
% part of file names.  There may be other things hard-coded too.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all

%Set path of Ameriflux files, define year timespan, set path for concatenated output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%filepath = char('/Users/lalbert/Dropbox/Niwot Ridge project/NR data/ameriflux_data/'); %directory where files live
filepath = char('/Users/lpapgm/Dropbox/Niwot Ridge project/NR data/ameriflux_data/ameriflux_data_ver.2015.11.10/'); %directory where files live
fileyear = [1998:1:2013]; %1998, 1999, 2000, etc...
filepathout = char('../../../NR data/Data output from matlab/');
numfiles = size(fileyear,2); %13 files

% Choose file type--this determines which part of code runs (using if stmt)
% this also determines 'type' of files to concatenate and to name output file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Choose 1 for climate flags, 
%Choose 2 for climate data, 
%Choose 3 for flux flags
%Choose 4 for flux data

datatype=4; 

if datatype == 1
    inputbasename = char('climate_flags_');
elseif datatype == 2
    inputbasename = char('climate_');
elseif datatype == 3
    inputbasename = char('flux_flags_');
elseif datatype == 4
    inputbasename = char('flux_');
end

if datatype == 1
    outputfilename = char('climate_flags_allyears.txt');
elseif datatype == 2
    outputfilename = char('climate_allyears.txt');
elseif datatype == 3
    outputfilename = char('flux_flags_allyears.txt');
elseif datatype == 4
    outputfilename = char('flux_allyears.txt');
end

% Automated stuff begins
%%%%%%%%%%%%%%%%%%%%
% Create empty vectors for each climate variable and each flux variable
Year = [];
MO = [];
DD = [];
HR = [];
MM = [];
SS = [];
DecimalDate = [];
T_21m = [];
RH_21m = [];
P_bar_12m = [];
ws_21m = [];
wd_21m = [];
ustar_21m = [];
z_L_21m = [];
precip_mm = [];
Td_21m = [];
vpd = [];
leaf_wetnes = [];
T_soil = [];
T_bole_pi = [];
T_bole_fi = [];
T_bole_sp = [];
Rppfd_in_ = [];
Rppfd_out = [];
Rnet_25m_ = [];
Rsw_in_25 = [];
Rsw_out_25 = [];
Rlw_in_25 = [];
Rlw_out_25 = [];
T_2m = [];
T_8m = [];
RH_2m = [];
RH_8m = [];
h2o_soil = [];
co2_21m = [];
h2o_picarro = [];
Fco2_21m_ne = [];
Strg_co2 = [];
Taua_21m= [];
Qh_21m = [];
Qe_21m = [];
Qe_21m_flag = [];
Qh_soil = [];
Strg_Qh = [];
Strg_Qe = [];
energy_bala = [];
stationarit = [];
integral_st = [];
Strg_bole = [];
Strg_needle = [];
Fco2_21m_nee_wust = [];
u_w_21m = [];
w_h2o_21m = [];

% Climate flags files section (automated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if datatype==1
    for i=1:numfiles %changes year in filename each time through loop
        filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2015.11.10.dat');
        filetoopen = strcat(filepath,filename); %concatenate file path with file name
        % use two lines below for climate flag files
        [tYear tMO tDD tHR tMM tSS tDecimalDate tT_21m tRH_21m tP_bar_12m tws_21m twd_21m tustar_21m tz_L_21m tprecip_mm tTd_21m tleaf_wetnes tT_soil tT_bole_pi tT_bole_fi tT_bole_sp tRppfd_in_ tRppfd_out tRnet_25m_ tRsw_out_25 tT_2m tT_8m tRH_2m tRH_8m th2o_soil tco2_21m th2o_picarro] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
        Year = [Year;tYear];
        MO = [MO;tMO];
        DD = [DD;tDD];
        HR = [HR;tHR];
        MM = [MM;tMM];
        SS = [SS;tSS];
        DecimalDate = [DecimalDate;tDecimalDate];
        T_21m = [T_21m;tT_21m];
        RH_21m = [RH_21m;tRH_21m];
        P_bar_12m = [P_bar_12m;tP_bar_12m];
        ws_21m = [ws_21m;tws_21m];
        wd_21m = [wd_21m;twd_21m];
        ustar_21m = [ustar_21m;tustar_21m];
        z_L_21m = [z_L_21m;tz_L_21m];
        precip_mm = [precip_mm;tprecip_mm];
        Td_21m = [Td_21m;tTd_21m];
        %vpd = [vpd;tvpd]; %This column doesn't exist in flags file
        leaf_wetnes = [leaf_wetnes;tleaf_wetnes];
        T_soil = [T_soil;tT_soil];
        T_bole_pi = [T_bole_pi;tT_bole_pi];
        T_bole_fi = [T_bole_fi;tT_bole_fi];
        T_bole_sp = [T_bole_sp;tT_bole_sp];
        Rppfd_in_ = [Rppfd_in_;tRppfd_in_];
        Rppfd_out = [Rppfd_out;tRppfd_out];
        Rnet_25m_ = [Rnet_25m_;tRnet_25m_];
        %Rsw_in_25 = [Rsw_in_25;tRsw_in_25]; %This column doesn't exist in flags file
        Rsw_out_25 = [Rsw_out_25;tRsw_out_25];
        %Rlw_in_25 = [Rlw_in_25;tRlw_in_25]; %This column doesn't exist in flags file
        %Rlw_out_2 = [Rlw_out_2;tRlw_out_2]; %This column doesn't exist in flags file
        T_2m = [T_2m;tT_2m];
        T_8m = [T_8m;tT_8m];
        RH_2m = [RH_2m;tRH_2m];
        RH_8m = [RH_8m;tRH_8m];
        h2o_soil = [h2o_soil;th2o_soil];
        co2_21m = [co2_21m;tco2_21m];
        % h2o_picarro = [h2o_picarro;th2o_picarro]; %I don't use this variable (added in newer, post 2013 or so data versions) so notincluding
    end
    
    %File Output
    %outputdata = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd wet_b T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_2 Rlw_in_25 Rlw_out_2 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    outputdata = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m leaf_wetnes T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_out_25 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    outputfilepath = strcat(filepathout,outputfilename);
    header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'leaf_wetnes', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_out_2', 'T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    fid = fopen(outputfilepath, 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite(outputfilepath,outputdata,'-append','delimiter','\t');

%Climate files section (automated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif datatype == 2
    for i=1:numfiles
        filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2015.11.10.dat');
        filetoopen = strcat(filepath,filename); %concatenate file path with file name
        [tYear tMO tDD tHR tMM tSS tDecimalDate tT_21m tRH_21m tP_bar_12m tws_21m twd_21m tustar_21m tz_L_21m tprecip_mm tTd_21m tvpd tleaf_wetnes tT_soil tT_bole_pi tT_bole_fi tT_bole_sp tRppfd_in_ tRppfd_out tRnet_25m_ tRsw_in_25 tRsw_out_25 tRlw_in_25 tRlw_out_25 tT_2m tT_8m tRH_2m tRH_8m th2o_soil tco2_21m pic1 pic2 pic3] = ...
                textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
        Year = [Year;tYear];
        MO = [MO;tMO];
        DD = [DD;tDD];
        HR = [HR;tHR];
        MM = [MM;tMM];
        SS = [SS;tSS];
        DecimalDate = [DecimalDate;tDecimalDate];
        T_21m = [T_21m;tT_21m];
        RH_21m = [RH_21m;tRH_21m];
        P_bar_12m = [P_bar_12m;tP_bar_12m];
        ws_21m = [ws_21m;tws_21m];
        wd_21m = [wd_21m;twd_21m];
        ustar_21m = [ustar_21m;tustar_21m];
        z_L_21m = [z_L_21m;tz_L_21m];
        precip_mm = [precip_mm;tprecip_mm];
        Td_21m = [Td_21m;tTd_21m];
        vpd = [vpd;tvpd];
        leaf_wetnes = [leaf_wetnes;tleaf_wetnes];
        T_soil = [T_soil;tT_soil];
        T_bole_pi = [T_bole_pi;tT_bole_pi];
        T_bole_fi = [T_bole_fi;tT_bole_fi];
        T_bole_sp = [T_bole_sp;tT_bole_sp];
        Rppfd_in_ = [Rppfd_in_;tRppfd_in_];
        Rppfd_out = [Rppfd_out;tRppfd_out];
        Rnet_25m_ = [Rnet_25m_;tRnet_25m_];
        Rsw_in_25 = [Rsw_in_25;tRsw_in_25];
        Rsw_out_25 = [Rsw_out_25;tRsw_out_25];
        Rlw_in_25 = [Rlw_in_25;tRlw_in_25];
        Rlw_out_25 = [Rlw_out_25;tRlw_out_25];
        T_2m = [T_2m;tT_2m];
        T_8m = [T_8m;tT_8m];
        RH_2m = [RH_2m;tRH_2m];
        RH_8m = [RH_8m;tRH_8m];
        h2o_soil = [h2o_soil;th2o_soil];
        co2_21m = [co2_21m;tco2_21m];
        %h2o_picarro = [h2o_picarro;th2o_picarro]; %I don't use this variable (added in newer, post 2013 or so data versions) so not including
        %dD_picarro = [dD_picarro;tdD_picarro]; %I don't use this variable (added in newer, post 2013 or so data versions) so not including
        %d180_picarro = [d180_picarro;td180_picarro]; %I don't use this variable (added in newer, post 2013 or so data versions) so not including
    end
    
    %File Output
    outputdata = [Year MO DD HR MM SS DecimalDate T_21m RH_21m P_bar_12m ws_21m wd_21m ustar_21m z_L_21m precip_mm Td_21m vpd leaf_wetnes T_soil T_bole_pi T_bole_fi T_bole_sp Rppfd_in_ Rppfd_out Rnet_25m_ Rsw_in_25 Rsw_out_25 Rlw_in_25 Rlw_out_25 T_2m T_8m RH_2m RH_8m h2o_soil co2_21m];
    outputfilepath = strcat(filepathout,outputfilename);
    header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'T_21m', 'RH_21m', 'P_bar_12m', 'ws_21m', 'wd_21m', 'ustar_21m', 'z_L_21m', 'precip_mm', 'Td_21m', 'vpd', 'wet_b', 'T_soil', 'T_bole_pi', 'T_bole_fi', 'T_bole_sp', 'Rppfd_in_', 'Rppfd_out', 'Rnet_25m_', 'Rsw_in_25', 'Rsw_out_2', 'Rlw_in_25', ' Rlw_out_2', 'T_2m', 'T_8m', 'RH_2m', 'RH_8m', 'h2o_soil', 'co2_21m'};
    fid = fopen(outputfilepath, 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite(outputfilepath,outputdata,'-append','delimiter','\t');

%Flux flags section (automated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif datatype == 3
    for i=1:numfiles
        filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2015.11.10.dat');
        filetoopen = strcat(filepath,filename); %concatenate file path with file name
        [tYear tMO tDD tHR tMM tSS tDecimalDate tFco2_21m_ne tStrg_co2 tTaua_21m tQh_21m tQe_21m tQe_21m_flag tQh_soil tStrg_Qh tStrg_Qe tenergy_bala tstationarit tintegral_st tStrg_bole tStrg_needle Qh_Ttc_21m] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
        Year = [Year;tYear];
        MO = [MO;tMO];
        DD = [DD;tDD];
        HR = [HR;tHR];
        MM = [MM;tMM];
        SS = [SS;tSS];
        DecimalDate = [DecimalDate;tDecimalDate];
        Fco2_21m_ne = [Fco2_21m_ne;tFco2_21m_ne];
        Strg_co2 = [Strg_co2;tStrg_co2];
        Taua_21m = [Taua_21m;tTaua_21m];
        Qh_21m = [Qh_21m;tQh_21m];
        Qe_21m = [Qe_21m;tQe_21m];
        Qe_21m_flag = [Qe_21m_flag;tQe_21m_flag];
        Qh_soil = [Qh_soil;tQh_soil];
        Strg_Qh = [Strg_Qh;tStrg_Qh];
        Strg_Qe = [Strg_Qe;tStrg_Qe];
        energy_bala = [energy_bala;tenergy_bala];
        stationarit = [stationarit;tstationarit];
        integral_st = [integral_st;tintegral_st];
        Strg_bole = [Strg_bole;tStrg_bole];
        Strg_needle = [Strg_needle;tStrg_needle];
        %Qh_Ttc_21m = [] %I don't use this variable (added in newer, post 2011 or so data versions) so not including
    end
    
    %File Output
    outputdata = [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Strg_co2 Taua_21m Qh_21m Qe_21m Qe_21m_flag Qh_soil Strg_Qh Strg_Qe energy_bala stationarit integral_st Strg_bole Strg_needle];
    outputfilepath = strcat(filepathout,outputfilename);
    %dlmwrite(outputfilepath,outputdata,'\t'); %For output without header use two lines above and this command
    header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_ne', 'Strg_co2', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'Qe_21m_flag', 'Qh_soil', 'Strg_Qh', 'Strg_Qe', 'energy_bala', 'stationarit', 'integral_st', 'Strg_bole', 'Strg_needle'};
    fid = fopen(outputfilepath, 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite(outputfilepath,outputdata,'-append','delimiter','\t');
    
    
%Flux data section (automated)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif datatype == 4
    for i=1:numfiles
        %         if fileyear(i) <=2010 %changes year in filename each time through loop
        %             filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2011.04.20.dat');
        %         elseif fileyear(i) ==2011
        %             filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2012.03.12.dat');
        %         elseif fileyear(i) ==2012
        %             filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2013.02.28.dat');
        %         elseif fileyear(i) ==2013
        %             filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2014.12.02.dat');
        %         end
        filename = strcat(inputbasename,num2str(fileyear(i)),'_ver.2015.11.10.dat');
        filetoopen = strcat(filepath,filename); %concatenate file path with file name
        [tYear tMO tDD tHR tMM tSS tDecimalDate tFco2_21m_ne tFco2_21m_nee_wust tStrg_co2 tu_w_21m tTaua_21m  tQh_21m tQe_21m tw_h2o_21m  tQh_soil tStrg_Qh tStrg_Qe tStrg_bole tStrg_needle Qh_Ttc_21] = ...
            textread(filetoopen,'%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','commentstyle','matlab');
        Year = [Year;tYear];
        MO = [MO;tMO];
        DD = [DD;tDD];
        HR = [HR;tHR];
        MM = [MM;tMM];
        SS = [SS;tSS];
        DecimalDate = [DecimalDate;tDecimalDate];
        Fco2_21m_ne = [Fco2_21m_ne;tFco2_21m_ne];
        Fco2_21m_nee_wust = [Fco2_21m_nee_wust;tFco2_21m_nee_wust];
        Strg_co2 = [Strg_co2;tStrg_co2];
        u_w_21m = [u_w_21m;tu_w_21m];
        Taua_21m = [Taua_21m ;tTaua_21m];
        Qh_21m = [Qh_21m;tQh_21m];
        Qe_21m = [Qe_21m;tQe_21m];
        w_h2o_21m  = [w_h2o_21m ;tw_h2o_21m ];
        Qh_soil = [Qh_soil;tQh_soil];
        Strg_Qh = [Strg_Qh;tStrg_Qh];
        Strg_Qe = [Strg_Qe;tStrg_Qe];
        Strg_bole = [Strg_bole;tStrg_bole];
        Strg_needle = [Strg_needle;tStrg_needle];
        %Qh_Ttc_21 = []; %I don't use this variable (added in newer, post 2011 or so data versions) so not including
    end
    
    %File Output
    outputdata = [Year MO DD HR MM SS DecimalDate Fco2_21m_ne Fco2_21m_nee_wust Strg_co2 u_w_21m Taua_21m Qh_21m Qe_21m w_h2o_21m Qh_soil Strg_Qh Strg_Qe Strg_bole Strg_needle];
    outputfilepath = strcat(filepathout,outputfilename);
    % dlmwrite(outputfilepath,outputdata,'\t'); %For output without header use two lines above and this command
    header = {'%Year', 'MO', 'DD', 'HR', 'MM', 'SS', 'DecimalDate', 'Fco2_21m_ne', 'Fco2_21m_nee_wust', 'Strg_co2', 'u_w_21m', 'Taua_21m', 'Qh_21m', 'Qe_21m', 'w_h2o_21m','Qh_soil', 'Strg_Qh', 'Strg_Qe', 'Strg_bole','Strg_needle'};
    fid = fopen(outputfilepath, 'w');
    if fid == -1; error('Cannot open file: %s', outfile); end
    fprintf(fid, '%s\t', header{:});
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite(outputfilepath,outputdata,'-append','delimiter','\t');
end